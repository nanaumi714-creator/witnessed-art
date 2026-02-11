# Non-Functional Requirements

- **API Latency (Non-Generation)**: SLO P95 < 200ms.
- **Image Generation (SDXL img2img)**: Target < 30s (95% of requests).
- **Availability**: 99.0% monthly uptime for API.
- **Observability**: Centralized logging and error tracking (Sentry) mandatory.
- **Scalability**: Initial support for 50 concurrent users.
- **Cost Efficiency**: Automated S3 cleanup (immediate disposal of high-resolution intermediates).

