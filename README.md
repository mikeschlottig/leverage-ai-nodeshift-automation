# 🚀 LEVERAGE AI NodeShift Automation Suite

**Never touch SSH manually again!** Complete automation for NodeShift GPU clusters with Agent Zero integration.

## 🎯 What This Solves

- ❌ **Manual SSH connection hell**
- ❌ **Repetitive server setup tasks**  
- ❌ **Complex GPU cluster management**
- ❌ **Agent Zero configuration headaches**
- ❌ **SSH key management nightmare**

## ✅ What You Get

- 🔥 **2-word commands** to connect anywhere
- 🤖 **Complete Agent Zero automation**
- ⚡ **Auto GPU cluster setup** with AI frameworks
- 🔑 **Automated SSH key management**
- 📊 **Infrastructure status dashboard**
- 🛡️ **Docker-isolated environments**

## 🚀 Quick Start (< 2 minutes)

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/setup.sh | bash

# Setup SSH keys (one time)
leverage ssh-setup

# Copy the output to your NodeShift dashboard
# Then you're done forever!
```

## 💥 Ultra-Simple Commands

| Command | Action | Words |
|---------|--------| ----- |
| `leverage gpu` | Connect to 4x RTX 3060 cluster | 2 |
| `leverage agent` | Start Agent Zero interface | 2 |
| `leverage setup-gpu` | Auto-install AI frameworks | 2 |
| `leverage status` | Check infrastructure status | 2 |

## 🏗️ Architecture

```
🖥️  Your Machine
    ↓
🤖 Agent Zero (localhost:50001)
    ↓
🔗 Automated SSH Manager
    ↓
┌─────────────────────────────────────┐
│  🔥 GPU Cluster (4x RTX 3060)       │
│  • 64 vCPU                         │
│  • 157GB RAM                       │
│  • Auto: Docker + NVIDIA + Ollama  │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│  💻 CPU VPS Farm                    │
│  • Auto: Load balancing            │
│  • Auto: Service coordination      │
│  • Auto: Health monitoring         │
└─────────────────────────────────────┘
```

## 🛠️ What Gets Installed Automatically

### On GPU Cluster
- ✅ Docker + NVIDIA Docker
- ✅ Ollama (local LLM server)
- ✅ PyTorch with CUDA support
- ✅ Agent Weaver framework
- ✅ Transformers + Accelerate
- ✅ All dependencies

### On Your Machine  
- ✅ Agent Zero (web interface)
- ✅ SSH automation scripts
- ✅ Connection management
- ✅ Master control interface

## 📁 Project Structure

```
~/agent-zero/
├── scripts/
│   ├── leverage          # Master control script
│   ├── ssh_manager.py    # SSH automation
│   ├── gpu              # GPU connection (2 words)
│   ├── cpu1             # CPU VPS 1 connection  
│   └── cpu2             # CPU VPS 2 connection
├── configs/
│   └── nodeshift_setup.json  # Auto-setup tasks
└── docs/
    ├── troubleshooting.md
    └── advanced.md
```

## 🔧 Configuration

Edit your server IPs in the setup script:

```bash
# NodeShift Details (update with your values)
NODESHIFT_GPU_IP="47.224.117.240"
NODESHIFT_GPU_PORT="6489"
NODESHIFT_CPU_IP_1="45.138.27.27"
NODESHIFT_CPU_IP_2="84.32.131.190"
```

## 🎮 Usage Examples

### Connect to GPU cluster
```bash
leverage gpu
# You're now on the 4x RTX 3060 cluster
nvidia-smi  # Check your GPUs
```

### Start Agent Zero interface
```bash
leverage agent
# Open: http://localhost:50001
# Give it tasks like: "Set up Llama4 on my GPU cluster"
```

### Auto-setup everything on GPU
```bash
leverage setup-gpu
# Installs: Docker, NVIDIA, Ollama, PyTorch, Agent Weaver
# Takes ~10 minutes, fully automated
```

### Check infrastructure status
```bash
leverage status
# Shows: GPU status, VPS status, Agent Zero status
```

## 🚨 Troubleshooting

### "Permission denied (publickey)"
```bash
# Regenerate SSH keys
leverage ssh-setup
# Copy output to NodeShift dashboard
```

### "Docker not found"
```bash
# Rerun setup (installs Docker automatically)
curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/setup.sh | bash
```

### Agent Zero not starting
```bash
# Check Docker status
docker ps
# Restart Agent Zero
leverage agent
```

## 🔮 Advanced Features

### Multi-Agent Coordination
```bash
# Agent Zero can coordinate multiple instances
# across your GPU cluster and VPS farm
# Example: "Deploy my app across all servers"
```

### Persistent Memory
```bash
# Agent Zero remembers:
# • Your server configurations
# • Successful deployment patterns
# • Troubleshooting solutions
# • Custom workflows
```

### Custom Tasks
```bash
# Add your own automation tasks
vim ~/agent-zero/configs/custom_task.json
# Run with: python3 ~/agent-zero/scripts/run_agent_zero.py custom_task.json
```

## 🤝 Contributing

1. Fork this repository
2. Create your feature branch
3. Test on your NodeShift setup
4. Submit a pull request

## 📄 License

MIT License - Feel free to use for LEVERAGE AI or any commercial projects!

## 🔗 Links

- [Agent Zero Framework](https://github.com/frdel/agent-zero)
- [NodeShift Cloud](https://nodeshift.com)
- [LEVERAGE AI](https://github.com/mikeschlottig)

---

**Made with 💀 by LEVERAGE AI team**

*"Because life's too short for manual SSH connections."*