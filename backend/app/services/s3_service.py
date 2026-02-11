import boto3
from botocore.exceptions import ClientError
from app.core.config import settings
import httpx
from io import BytesIO

class S3Service:
    def __init__(self):
        self.s3_client = boto3.client(
            "s3",
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
            region_name=settings.AWS_REGION
        )
        self.bucket = settings.AWS_S3_BUCKET

    def upload_from_url(self, url: str, key: str):
        """Fetch image from URL and upload to S3."""
        try:
            with httpx.Client() as client:
                response = client.get(url)
                if response.status_code != 200:
                    return None
                
                image_data = BytesIO(response.content)
                self.s3_client.upload_fileobj(image_data, self.bucket, key)
                return f"s3://{self.bucket}/{key}"
        except Exception as e:
            print(f"S3 Upload Error: {e}")
            return None

    def delete_file(self, key: str):
        """Delete file from S3."""
        try:
            self.s3_client.delete_object(Bucket=self.bucket, Key=key)
            return True
        except ClientError:
            return False

    def generate_presigned_url(self, key: str, expiration=900):
        """Generate a presigned URL for secure access (15 min default)."""
        try:
            response = self.s3_client.generate_presigned_url(
                'get_object',
                Params={'Bucket': self.bucket, 'Key': key},
                ExpiresIn=expiration
            )
            return response
        except ClientError:
            return None

s3_service = S3Service()
