# SentinelAI Threat Models

## AI Attack Taxonomy (Ω Levels)

### Ω1: External Attacks
- Prompt Injection, Jailbreaking, Context Overflow

### Ω2: Peripheral Attacks
- API Poisoning, Plugin Exploitation, Vector Database Attacks

### Ω3: Agent-Level Compromise
- Goal Manipulation, Memory Poisoning, Tool Abuse

### Ω4: Coordination Attacks
- Multi-Agent Collusion, Hierarchy Manipulation, Belief Contamination

### Ω5: Systemic Compromise
- Infrastructure Attack, Model Theft, Supply Chain

## IOA Detection Patterns

### Persistence Indicators
- Scheduled task creation
- Registry run key modifications
- Startup folder additions

### Lateral Movement Indicators
- Unusual RDP connections, SMB traffic anomalies, Pass-the-hash attempts

### Exfiltration Indicators
- Unusual outbound traffic, DNS tunneling, Data staging in temp folders

## MITRE ATT&CK Mapping

| SentinelAI Detection | MITRE Technique | Phase |
|---------------------|-----------------|-------|
| Anomalous Process Creation | T1053.005 | Persistence |
| Unusual Network Connections | T1048 | Exfiltration |
| Registry Modifications | T1112 | Defense Evasion |
| Script Execution | T1059 | Execution |
| Service Installation | T1543.003 | Persistence |
