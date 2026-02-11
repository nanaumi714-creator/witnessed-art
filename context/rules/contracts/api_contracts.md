# API Contracts

Authoritative API contract references for app-backend communication.

## Base Configuration
- **Base URL**: `https://api.witnessed-art.com/api/v1`
- **Auth**: Bearer Token (Firebase ID Token)
- **Content-Type**: `application/json`
- **Idempotency**: `X-Idempotency-Key` header (UUID v4) mandatory for all POST requests.

## Endpoints

### 1. User Initialization
`POST /user/init`
- **Description**: Register or retrieve user profile.
- **Request**: `{ "timezone": "Asia/Tokyo" }`
- **Response**:
  ```json
  {
    "user_id": "string",
    "seed": "int64",
    "step": 0,
    "current_image_url": "string | null",
    "max_save_slots": 1,
    "tickets": 0
  }
  ```

### 2. Daily Progression
`POST /progress`
- **Description**: Advance image by one step.
- **Request**: `{ "timestamp": 123456789 }` (Unix timestamp, server allows ±300s drift).
- **Response (200)**:
  ```json
  {
    "status": "success",
    "before_url": "string",
    "after_url": "string",
    "new_step": 1,
    "ticket_used": false
  }
  ```
- **Response (429 - Locked)**: `{ "status": "rate_limited", "next_available_at": "ISO8601" }`

### 3. Save Current Run
`POST /save`
- **Description**: Move current image (atomically) to a save slot.
- **Response**: `{ "saved_image_id": "uuid", "remaining_slots": 0 }`

### 4. Saved List
`GET /saved-images`
- **Response**: `{ "images": [{ "id": "uuid", "url": "string", "final_step": 14 }], "max_slots": 1 }`

### 5. Reset Run
`POST /reset`
- **Request**: `{ "confirmation": "I understand this is irreversible" }`
- **Response**: `{ "new_seed": "int64", "step": 0 }`

### 6. Ad Reward
`POST /ad/reward`
- **Description**: Grants a ticket via ad completion.
- **Request**: `{ "ad_id": "string", "ad_network": "admob" }`
- **Response**: `{ "status": "success", "tickets": 1 }`

## Error Codes
| Code | HTTP | Description |
|---|---|---|
| AUTH_001 | 401 | Invalid token |
| RATE_001 | 429 | 24h limit active |
| GEN_001 | 500 | Generation failed |
| SAVE_001 | 400 | Slots full |


