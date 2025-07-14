# 🔮 Advanced Usage Guide

## Multi-Agent Orchestration

### Coordinating Multiple GPU Clusters
```bash
# Set up multiple GPU instances
export GPU_CLUSTER_1="47.224.117.240:6489"
export GPU_CLUSTER_2="your-second-gpu-ip:port"

# Create parallel workflows
leverage gpu &     # Connect to cluster 1
leverage gpu2 &    # Connect to cluster 2 (if configured)
```

### Agent Zero Swarm Management
```python
# Custom Agent Zero configuration
cat > ~/agent-zero/configs/swarm_config.json << 'EOF'
{
  "agents": [
    {
      "name": "gpu_manager",
      "role": "GPU resource allocation",
      "target": "47.224.117.240:6489"
    },
    {
      "name": "model_trainer", 
      "role": "AI model training",
      "target": "47.224.117.240:6489"
    },
    {
      "name": "inference_server",
      "role": "Model serving",
      "target": "45.138.27.27"
    }
  ]
}
EOF
```

## Custom Task Automation

### Creating Custom Tasks
```json
{
  "task_name": "deploy_custom_model",
  "description": "Deploy a custom AI model across GPU cluster",
  "steps": [
    {
      "action": "model_download",
      "commands": [
        "cd /workspace/models",
        "wget https://huggingface.co/your-model/resolve/main/model.bin",
        "wget https://huggingface.co/your-model/resolve/main/config.json"
      ]
    },
    {
      "action": "model_setup",
      "commands": [
        "python3 -c \"from transformers import AutoModel; model = AutoModel.from_pretrained('/workspace/models')\"",
        "docker run -d --gpus all -p 8000:8000 -v /workspace/models:/models your-inference-server"
      ]
    }
  ]
}
```

### Running Custom Tasks
```bash
# Save custom task to config file
vim ~/agent-zero/configs/my_custom_task.json

# Run the task
python3 ~/agent-zero/scripts/run_agent_zero.py ~/agent-zero/configs/my_custom_task.json
```

## Advanced SSH Configuration

### SSH Multiplexing for Fast Connections
```bash
# Add to ~/.ssh/config
cat >> ~/.ssh/config << 'EOF'
Host nodeshift-gpu
    HostName 47.224.117.240
    Port 6489
    User root
    IdentityFile ~/.ssh/nodeshift_auto
    ControlMaster auto
    ControlPath ~/.ssh/master-%r@%h:%p
    ControlPersist 10m
    Compression yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
EOF

# Now connect with: ssh nodeshift-gpu
```

### Port Forwarding for Services
```bash
# Forward Jupyter notebook
ssh -L 8888:localhost:8888 -p 6489 root@47.224.117.240

# Forward multiple services
ssh -L 8888:localhost:8888 \
    -L 6006:localhost:6006 \
    -L 8000:localhost:8000 \
    -p 6489 root@47.224.117.240

# Access services locally:
# Jupyter: http://localhost:8888
# TensorBoard: http://localhost:6006  
# API: http://localhost:8000
```

## GPU Cluster Optimization

### Distributed Training Setup
```bash
# On GPU cluster - set up distributed training
cat > /workspace/distributed_setup.py << 'EOF'
import torch
import torch.distributed as dist
import torch.multiprocessing as mp
from torch.nn.parallel import DistributedDataParallel as DDP

def setup(rank, world_size):
    dist.init_process_group("nccl", rank=rank, world_size=world_size)
    torch.cuda.set_device(rank)

def cleanup():
    dist.destroy_process_group()

# Use all 4 GPUs
world_size = 4
mp.spawn(train_function, args=(world_size,), nprocs=world_size, join=True)
EOF
```

### GPU Monitoring Dashboard
```bash
# Set up real-time GPU monitoring
docker run -d \
  --name gpu-dashboard \
  --gpus all \
  -p 3000:3000 \
  nvidia/nvml-dashboard

# Access at: http://your-gpu-ip:3000
```

## Agent Zero Advanced Features

### Custom Instruments
```python
# Create custom Agent Zero instrument
cat > ~/agent-zero/instruments/nodeshift_manager.py << 'EOF'
class NodeShiftManager:
    def __init__(self):
        self.clusters = {
            'gpu': '47.224.117.240:6489',
            'cpu1': '45.138.27.27', 
            'cpu2': '84.32.131.190'
        }
    
    def execute_on_cluster(self, cluster, command):
        """Execute command on specified cluster"""
        if cluster in self.clusters:
            # SSH and execute command
            import subprocess
            ssh_cmd = f"ssh -p {self.clusters[cluster].split(':')[1]} root@{self.clusters[cluster].split(':')[0]} '{command}'"
            return subprocess.run(ssh_cmd, shell=True, capture_output=True, text=True)
    
    def load_balance_task(self, task):
        """Distribute task across available clusters"""
        # Implement load balancing logic
        pass
EOF
```

### Agent Zero API Integration
```python
# Create API wrapper for Agent Zero
import requests
import json

class AgentZeroAPI:
    def __init__(self, base_url="http://localhost:50001"):
        self.base_url = base_url
    
    def send_task(self, task_description):
        """Send task to Agent Zero via API"""
        payload = {
            "task": task_description,
            "priority": "high",
            "target": "gpu_cluster"
        }
        response = requests.post(f"{self.base_url}/api/tasks", json=payload)
        return response.json()
    
    def get_status(self):
        """Get Agent Zero status"""
        response = requests.get(f"{self.base_url}/api/status")
        return response.json()

# Usage
agent = AgentZeroAPI()
result = agent.send_task("Set up Llama 3.2 on the GPU cluster")
```

## Production Deployment

### Docker Compose for Full Stack
```yaml
# docker-compose.yml for production
version: '3.8'
services:
  agent-zero:
    image: frdel/agent-zero-run
    ports:
      - "50001:50001"
    volumes:
      - ./agent-zero:/workspace
      - ~/.ssh:/root/.ssh
    restart: unless-stopped
    
  gpu-monitor:
    image: nvidia/nvml-dashboard
    ports:
      - "3000:3000"
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    
  model-server:
    image: huggingface/transformers:latest
    ports:
      - "8000:8000"
    volumes:
      - ./models:/models
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
```

### Kubernetes Deployment
```yaml
# kubernetes/agent-zero-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: agent-zero
spec:
  replicas: 1
  selector:
    matchLabels:
      app: agent-zero
  template:
    metadata:
      labels:
        app: agent-zero
    spec:
      containers:
      - name: agent-zero
        image: frdel/agent-zero-run
        ports:
        - containerPort: 50001
        resources:
          limits:
            nvidia.com/gpu: 4
        volumeMounts:
        - name: workspace
          mountPath: /workspace
      volumes:
      - name: workspace
        persistentVolumeClaim:
          claimName: agent-zero-pvc
```

## Monitoring and Alerting

### Health Check Scripts
```bash
# Create automated health checks
cat > ~/agent-zero/scripts/health_check.sh << 'EOF'
#!/bin/bash

# Check GPU cluster health
gpu_status=$(python3 ~/agent-zero/scripts/ssh_manager.py test 47.224.117.240 6489)
if [[ $gpu_status == *"successful"* ]]; then
    echo "✅ GPU cluster healthy"
else
    echo "❌ GPU cluster down - sending alert"
    # Send alert (email, Slack, etc.)
fi

# Check Agent Zero health
if curl -s http://localhost:50001/health > /dev/null; then
    echo "✅ Agent Zero healthy"
else
    echo "❌ Agent Zero down - restarting"
    leverage kill
    leverage agent
fi
EOF

# Run health checks every 5 minutes
echo "*/5 * * * * /bin/bash ~/agent-zero/scripts/health_check.sh" | crontab -
```

### Performance Monitoring
```python
# GPU performance monitoring
import psutil
import nvidia_ml_py3 as nvml

def monitor_resources():
    # CPU monitoring
    cpu_percent = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory()
    
    # GPU monitoring
    nvml.nvmlInit()
    gpu_count = nvml.nvmlDeviceGetCount()
    
    for i in range(gpu_count):
        handle = nvml.nvmlDeviceGetHandleByIndex(i)
        gpu_mem = nvml.nvmlDeviceGetMemoryInfo(handle)
        gpu_util = nvml.nvmlDeviceGetUtilizationRates(handle)
        
        print(f"GPU {i}: {gpu_util.gpu}% utilization, {gpu_mem.used/1024**3:.1f}GB used")
    
    return {
        'cpu': cpu_percent,
        'memory': memory.percent,
        'gpus': gpu_stats
    }
```

## Integration with Other Tools

### Airweave Integration
```python
# Integrate with Airweave for advanced agent workflows
from airweave import AgentManager, Workflow

# Create Airweave workflow using LEVERAGE AI infrastructure
workflow = Workflow("leverage-ai-pipeline")
workflow.add_node("data-prep", target="cpu1")
workflow.add_node("model-training", target="gpu")  
workflow.add_node("deployment", target="cpu2")

# Execute workflow
manager = AgentManager()
manager.execute(workflow)
```

### LiveKit Integration
```bash
# Set up LiveKit for voice AI on GPU cluster
docker run -d \
  --name livekit-server \
  --gpus all \
  -p 7880:7880 \
  -p 7881:7881/udp \
  livekit/livekit-server:latest \
  --config /etc/livekit.yaml
```

## Security Hardening

### SSH Security
```bash
# Harden SSH configuration
cat >> ~/.ssh/config << 'EOF'
Host *
    Protocol 2
    Compression yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking yes
    VerifyHostKeyDNS yes
    PasswordAuthentication no
    PubkeyAuthentication yes
    AuthenticationMethods publickey
EOF
```

### Docker Security
```bash
# Run containers with restricted privileges
docker run -d \
  --name agent-zero-secure \
  --user 1000:1000 \
  --read-only \
  --security-opt no-new-privileges \
  --cap-drop ALL \
  -p 50001:50001 \
  frdel/agent-zero-run
```

## Backup and Recovery

### Automated Backups
```bash
# Create backup script
cat > ~/agent-zero/scripts/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/leverage-ai-$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Backup SSH keys
cp -r ~/.ssh $BACKUP_DIR/

# Backup Agent Zero configs
cp -r ~/agent-zero/configs $BACKUP_DIR/

# Backup custom scripts
cp -r ~/agent-zero/scripts $BACKUP_DIR/

# Create tarball
tar -czf $BACKUP_DIR.tar.gz $BACKUP_DIR
rm -rf $BACKUP_DIR

echo "✅ Backup created: $BACKUP_DIR.tar.gz"
EOF

# Schedule daily backups
echo "0 2 * * * /bin/bash ~/agent-zero/scripts/backup.sh" | crontab -
```

### Disaster Recovery
```bash
# Quick recovery script
cat > ~/agent-zero/scripts/recover.sh << 'EOF'
#!/bin/bash
echo "🚨 Initiating disaster recovery..."

# Stop all services
leverage kill
docker stop $(docker ps -q) 2>/dev/null

# Restore from backup
if [ -f "/backup/latest.tar.gz" ]; then
    tar -xzf /backup/latest.tar.gz -C ~/
    echo "✅ Configuration restored"
fi

# Reinstall everything
curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/setup.sh | bash

echo "✅ Disaster recovery complete"
EOF
```

---

**Remember**: With great power comes great responsibility. Use these advanced features wisely and always test in a safe environment first!