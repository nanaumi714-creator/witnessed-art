import replicate
import random
from app.core.config import settings

class AIService:
    def __init__(self):
        self.client = replicate.Client(api_token=settings.REPLICATE_API_TOKEN)
        # SDXL Model on Replicate: stability-ai/sdxl
        self.model_version = "stability-ai/sdxl:7762fdc0e1e3568273c095e6a50360063567d9a58b99f2a7cac127311c9911ef"

    def get_phase_params(self, step: int):
        if step <= 2:
            return {"denoise": 0.95, "steps": 12, "cfg": 4.5}
        elif step <= 5:
            return {"denoise": 0.80, "steps": 18, "cfg": 5.0}
        elif step <= 9:
            return {"denoise": 0.60, "steps": 24, "cfg": 5.5}
        elif step <= 14:
            return {"denoise": 0.40, "steps": 32, "cfg": 6.0}
        else:
            return {"denoise": 0.30, "steps": 36, "cfg": 6.0}

    def nsfw_check(self, image_url: str):
        """Check if image is NSFW using a detection model on Replicate."""
        nsfw_model = "lucataco/nsfw-detection:695cd05f03f39a4891e4b85da8b356d7f0ec40108398188095bd4122d99c4ef7"
        try:
            output = self.client.run(nsfw_model, input={"image": image_url})
            if isinstance(output, dict):
                return output.get("nsfw_score", 0) > 0.7
            return False
        except:
            return False

    def generate_step_0(self, seed: int):
        """Initial run using txt2img."""
        params = self.get_phase_params(1)
        prompt = "abstract watercolor painting, serene landscape, gentle colors, artistic, dreamy atmosphere, soft lighting, peaceful, professional digital art, high quality, safe for work"
        negative_prompt = "nude, nsfw, explicit, sexual content, violence, gore, blood, disturbing, horror, scary, inappropriate, realistic photo, text, watermark, signature, low quality, blurry"
        
        def _run(**kwargs):
            output = self.client.run(self.model_version, input=kwargs)
            return output[0] if output else None

        return self.generate_with_retry(
            _run, 
            prompt=prompt, 
            negative_prompt=negative_prompt, 
            seed=seed, 
            num_inference_steps=params["steps"], 
            guidance_scale=params["cfg"], 
            width=512, 
            height=512
        )

    def advance_step(self, image_url: str, seed: int, step: int):
        """img2img progression."""
        params = self.get_phase_params(step)
        prompt = "abstract watercolor painting, serene landscape, gentle colors, artistic, dreamy atmosphere, soft lighting, peaceful, professional digital art, high quality, safe for work"
        negative_prompt = "nude, nsfw, explicit, sexual content, violence, gore, blood, disturbing, horror, scary, inappropriate, realistic photo, text, watermark, signature, low quality, blurry"

        def _run(**kwargs):
            output = self.client.run(self.model_version, input=kwargs)
            return output[0] if output else None

        return self.generate_with_retry(
            _run, 
            image=image_url, 
            prompt=prompt, 
            negative_prompt=negative_prompt, 
            seed=seed, 
            num_inference_steps=params["steps"], 
            guidance_scale=params["cfg"], 
            prompt_strength=params["denoise"], 
            width=512, 
            height=512
        )

    def generate_with_retry(self, fn, **kwargs):
        """Retry generation up to 3 times if NSFW is detected."""
        initial_seed = kwargs.get("seed", 0)
        for i in range(3):
            kwargs["seed"] = initial_seed + i
            url = fn(**kwargs)
            if not url:
                continue
            if not self.nsfw_check(url):
                return url
        return None

ai_service = AIService()
