//! TEP (Telecommunications Encryption Protocol)
//! Patent: US11799659B2 - Gabriele Pegoraro

use serde::{Deserialize, Serialize};
use sha2::Sha256;
use hmac::{Hmac, Mac};
use chrono::Utc;
use uuid::Uuid;
use std::collections::HashMap;
use std::time::{SystemTime, UNIX_EPOCH};

type HmacSha256 = Hmac<Sha256>;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "UPPERCASE")]
pub enum TEPPacketType { Command, Telemetry, Beacon, Alert, Config, Ack, Handshake }

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum TEPDeviceType { Drone, Satellite, IoT, Sensor, Gateway, Mobile }

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum DeviceStatus { Active, Idle, Offline, Compromised, Unknown }

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GeoLocation { pub latitude: f64, pub longitude: f64, pub altitude: f64, pub accuracy: f32 }

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TEPDescriptor {
    pub protocol: String, pub version: String, pub encryption: String,
    pub compression: bool, pub hop_count: u8, pub ttl: u32, pub flags: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TEPPacket {
    pub id: String, pub packet_type: TEPPacketType, pub source_id: String,
    pub dest_id: Option<String>, pub timestamp: u64, pub payload: Vec<u8>,
    pub signature: String, pub sequence: u32, pub priority: u8, pub descriptor: TEPDescriptor,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TEPDevice {
    pub id: String, pub device_type: TEPDeviceType, pub name: String,
    pub public_key: String, pub capabilities: Vec<String>,
    pub location: Option<GeoLocation>, pub status: DeviceStatus,
    pub last_seen: u64, pub firmware_version: String,
}

pub struct TEPProtocol { devices: HashMap<String, TEPDevice>, secret_key: Vec<u8>, packet_counter: u32 }

impl TEPProtocol {
    pub fn new(secret_key: Vec<u8>) -> Self {
        Self { devices: HashMap::new(), secret_key, packet_counter: 0 }
    }

    fn generate_signature(&self, data: &[u8]) -> String {
        let mut mac = HmacSha256::new_from_slice(&self.secret_key).expect("valid key");
        mac.update(data);
        hex::encode(mac.finalize().into_bytes())
    }

    pub fn create_packet(&mut self, packet_type: TEPPacketType, source_id: String,
        dest_id: Option<String>, payload: Vec<u8>, priority: u8) -> TEPPacket {
        self.packet_counter += 1;
        let timestamp = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
        let descriptor = TEPDescriptor {
            protocol: "TEP".into(), version: "1.0".into(),
            encryption: "AES-256-GCM".into(), compression: false,
            hop_count: 0, ttl: 3600, flags: 0,
        };
        let data = format!("{}{}{}{}", source_id, dest_id.clone().unwrap_or_default(),
            timestamp, hex::encode(&payload));
        let signature = self.generate_signature(data.as_bytes());
        TEPPacket { id: Uuid::new_v4().to_string(), packet_type, source_id, dest_id,
            timestamp, payload, signature, sequence: self.packet_counter, priority, descriptor }
    }

    pub fn verify_packet(&self, p: &TEPPacket) -> bool {
        let data = format!("{}{}{}{}", p.source_id, p.dest_id.clone().unwrap_or_default(),
            p.timestamp, hex::encode(&p.payload));
        self.generate_signature(data.as_bytes()) == p.signature
    }

    pub fn register_device(&mut self, device: TEPDevice) { self.devices.insert(device.id.clone(), device); }
    pub fn get_device(&self, id: &str) -> Option<&TEPDevice> { self.devices.get(id) }

    pub fn update_location(&mut self, device_id: &str, location: GeoLocation) -> bool {
        if let Some(d) = self.devices.get_mut(device_id) {
            d.location = Some(location);
            d.last_seen = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
            true
        } else { false }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_packet_creation_and_verification() {
        let mut tep = TEPProtocol::new(b"test_secret_key_1234567890123456".to_vec());
        let pkt = tep.create_packet(TEPPacketType::Telemetry, "drone-001".into(),
            Some("gateway-001".into()), vec![1, 2, 3, 4], 5);
        assert!(tep.verify_packet(&pkt));
    }
    #[test]
    fn test_device_registration() {
        let mut tep = TEPProtocol::new(b"test_key".to_vec());
        let device = TEPDevice { id: "drone-001".into(), device_type: TEPDeviceType::Drone,
            name: "Recon Drone".into(), public_key: "pub_key".into(),
            capabilities: vec!["video".into()], location: None,
            status: DeviceStatus::Active, last_seen: 0, firmware_version: "1.0.0".into() };
        tep.register_device(device);
        assert!(tep.get_device("drone-001").is_some());
    }
}
