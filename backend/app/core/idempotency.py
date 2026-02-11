from fastapi import Request, Response, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
import time

class IdempotencyMiddleware(BaseHTTPMiddleware):
    def __init__(self, app):
        super().__init__(app)
        # In production, use Redis. For MVP/Local, use a simple dict (Careful with memory).
        self.cache = {}

    async def dispatch(self, request: Request, call_next):
        if request.method != "POST":
            return await call_next(request)

        idempotency_key = request.headers.get("X-Idempotency-Key")
        if not idempotency_key:
            # We decided it's mandatory in api_contracts.md
            raise HTTPException(status_code=400, detail="X-Idempotency-Key header is missing")

        # Basic Cache Check
        cache_key = f"{request.url.path}:{idempotency_key}"
        if cache_key in self.cache:
            cached_res = self.cache[cache_key]
            # Simple check for expiration (e.g., 24h)
            if time.time() - cached_res["timestamp"] < 86400:
                return Response(
                    content=cached_res["content"],
                    status_code=cached_res["status_code"],
                    media_type=cached_res["media_type"]
                )

        response = await call_next(request)

        # Only cache successful or specific client errors
        if response.status_code < 500:
            # Consume response body to cache it
            response_body = b""
            async for chunk in response.body_iterator:
                response_body += chunk
            
            self.cache[cache_key] = {
                "content": response_body,
                "status_code": response.status_code,
                "media_type": response.media_type,
                "timestamp": time.time()
            }

            return Response(
                content=response_body,
                status_code=response.status_code,
                media_type=response.media_type,
                headers=dict(response.headers)
            )

        return response
