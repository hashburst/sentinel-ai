#!/usr/bin/env python3
"""SentinelAI Test Data Generator"""
import json, random, uuid, argparse
from datetime import datetime, timedelta

SEVERITIES = ["low", "medium", "high", "critical"]
MITRE = ["T1053.005", "T1550.002", "T1048", "T1055", "T1112", "T1059", "T1543.003"]
IPS = ["192.168.1.100", "10.0.0.50", "172.16.1.200", "45.33.22.11", "89.160.20.112"]
DOMAINS = ["evil.com", "malware.net", "c2.biz", "phishing.org", "malicious.io"]
HOSTS = ["DC-01", "SQL-01", "WEB-01", "WS-001", "WS-002", "FS-01"]
COUNTRIES = ["US", "RU", "CN", "IR", "KP", "UA", "DE", "GB"]

def generate_ioc():
    return {
        "id": f"ioc-{uuid.uuid4().hex[:8]}",
        "type": random.choice(["ip", "domain", "hash", "url"]),
        "value": random.choice(IPS + DOMAINS),
        "confidence": round(random.uniform(0.7, 1.0), 2),
        "severity": random.choice(SEVERITIES),
        "first_seen": (datetime.now() - timedelta(days=random.randint(0, 30))).isoformat(),
        "tags": random.sample(["malware", "c2", "phishing", "ransomware"], random.randint(1, 3))
    }

def generate_ioa():
    return {
        "id": f"ioa-{uuid.uuid4().hex[:8]}",
        "type": random.choice(["persistence", "lateral_movement", "exfiltration"]),
        "source": random.choice(IPS + HOSTS),
        "target": random.choice(HOSTS),
        "timestamp": (datetime.now() - timedelta(minutes=random.randint(1, 1440))).isoformat(),
        "severity": round(random.uniform(0.5, 1.0), 2),
        "mitre_id": random.choice(MITRE),
    }

def generate_honeypot_interaction():
    return {
        "id": f"hp-{uuid.uuid4().hex[:8]}",
        "timestamp": (datetime.now() - timedelta(minutes=random.randint(1, 1440))).isoformat(),
        "source_ip": random.choice(IPS),
        "source_country": random.choice(COUNTRIES),
        "target_service": random.choice(["ssh", "http", "https", "mysql", "smb"]),
    }

def generate_dataset(size=100, output_file="test_data.json"):
    data = {
        "generated_at": datetime.now().isoformat(),
        "iocs": [generate_ioc() for _ in range(size)],
        "ioas": [generate_ioa() for _ in range(size)],
        "honeypot_interactions": [generate_honeypot_interaction() for _ in range(size)],
    }
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"Generated {size} records to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--size", type=int, default=100)
    parser.add_argument("--output", type=str, default="test_data.json")
    args = parser.parse_args()
    generate_dataset(args.size, args.output)
