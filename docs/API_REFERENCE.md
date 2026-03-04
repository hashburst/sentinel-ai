# SentinelAI API Reference

## Base URL
`https://sentinel.local:8080/api/v1`

## Authentication
All API requests require an API key in the header:
```
Authorization: Bearer <your_api_key>
```

## Endpoints

### Threat Intelligence

#### GET /threats
Query recent threats with filters.

**Parameters:**
- `type` (optional): ioa, ioc, attack, anomaly
- `severity` (optional): low, medium, high, critical
- `hours` (optional): 1, 6, 12, 24, 48, 168
- `source` (optional): IP, domain, hash

**Response:**
```json
{
  "threats": [
    {
      "id": "threat-123",
      "type": "ioa",
      "severity": 0.85,
      "timestamp": "2024-01-15T10:30:00Z",
      "source": "192.168.1.100",
      "mitre_id": "T1053.005"
    }
  ],
  "total": 42
}
```

#### POST /threats
Submit new IoC/IOA.

### AI Analysis

#### POST /ai/analyze
AI-powered threat analysis.

#### POST /ai/detect-deepfake
Analyze image/video for deepfake.

### Honeypot Management

#### POST /honeypot/deploy
Deploy new AI honeypot instance.

#### GET /honeypot/{id}/interactions
Get honeypot interaction logs.

### TEP Protocol

#### POST /tep/device/register
Register TEP-enabled device.

#### POST /tep/command/send
Send command to TEP device.

### XDR/EDR Integration

#### POST /xdr/alert
Forward alert to connected XDR.

#### GET /xdr/status
Get XDR integration status.

## WebSocket

Connect to `ws://sentinel.local:8080/api/v1/ws` for real-time updates.

**Events:** `threat.new`, `honeypot.interaction`, `tep.device.status`, `alert.update`

## Rate Limiting
- 100 requests per minute per API key
- 1000 requests per hour per API key
