# SentinelAI System Architecture

## Overview

SentinelAI is built on a modular microservices architecture extending WorldMonitor's core capabilities. The platform integrates multiple security modules with a unified dashboard and API layer.

## Core Components

### 1. Frontend Layer
- **Technology**: React + TypeScript + deck.gl
- **Purpose**: Interactive 3D globe visualization, real-time dashboards
- **Key Features**: Geospatial attack visualization, real-time threat monitoring, honeypot management interface, TEP device tracking

### 2. Backend Layer
- **Technology**: Rust (Tauri) for performance and memory safety
- **Purpose**: API gateway, business logic, data processing
- **Modules**: Authentication & Authorization, Threat intelligence correlation, IOA/IoC management, TEP protocol gateway

### 3. Data Layer
- **PostgreSQL**: Relational data, user management, threat history
- **Redis**: Caching, real-time metrics, session management
- **IndexedDB**: Client-side vector storage for RAG

### 4. AI/ML Modules
- **Deepfake Detection**: Vision Transformer models
- **Cognitive Security**: Prompt injection defense
- **Local LLM**: Ollama/LM Studio integration
- **RAG Engine**: Semantic search on threat data

### 5. Security Modules
- **Honeypot AI**: Dynamic trap generation
- **IOA Detector**: Behavioral anomaly detection
- **Fork Bomb Protection**: Resource exhaustion prevention
- **Signed URL Security**: HMAC-SHA256 endpoint protection

### 6. TEP Protocol Integration
- **Purpose**: Telecommunications protocol for IoT/Drone/Satellite
- **Patent**: US11799659B2 (Gabriele Pegoraro)
- **Features**: Encrypted packet transmission, device fingerprinting, geolocation tracking, C2 for defensive countermeasures

## Data Flow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Frontend  │────▶│   API Gateway│────▶│  Backend    │
│   (React)   │◀────│   (Rust)     │◀────│  Services   │
└─────────────┘     └──────────────┘     └─────────────┘
                           │                      │
                           ▼                      ▼
                    ┌──────────────┐     ┌─────────────┐
                    │   Redis      │     │  PostgreSQL │
                    │   (Cache)    │     │  (Storage)  │
                    └──────────────┘     └─────────────┘
                           │                      │
                           ▼                      ▼
                    ┌──────────────┐     ┌─────────────┐
                    │   Modules    │     │   XDR/EDR   │
                    │   (AI/ML)    │────▶│ Integrations│
                    └──────────────┘     └─────────────┘
```

## Deployment Options

- **Single Node**: All-in-one Docker deployment
- **Kubernetes**: Scalable microservices architecture
- **Edge**: Raspberry Pi/Raspbian optimized deployment
- **Air-Gapped**: Fully offline capable with local LLMs
