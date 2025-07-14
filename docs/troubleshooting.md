# 🚨 Troubleshooting Guide

## Common Issues and Solutions

### SSH Connection Issues

#### "Permission denied (publickey)"
```bash
# Solution 1: Regenerate SSH keys
leverage ssh-setup
# Copy the output to NodeShift dashboard

# Solution 2: Check if key exists
ls -la ~/.ssh/nodeshift*
chmod 600 ~/.ssh/nodeshift

# Solution 3: Test connection
leverage test
```

#### "Connection refused"
```bash
# Check if server is running
ping 47.224.117.240

# Try different connection method
ssh -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 6489 root@47.224.117.240

# Check NodeShift dashboard for server status
```

#### "Connection timeout"
```bash
# Check your internet connection
ping google.com

# Try proxy connection (if available)
ssh -p 34004 root@ssh6.nodeshift.com

# Restart your network
sudo systemctl restart NetworkManager
```

### Docker Issues

#### "Docker not found"
```bash
# Reinstall Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Logout and login again
logout
```

#### "Permission denied (Docker)"
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again, or use:
newgrp docker

# Test Docker
docker ps
```

#### "Agent Zero won't start"
```bash
# Check Docker status
docker ps
docker images

# Kill old containers
leverage kill

# Restart Agent Zero
leverage agent

# Check logs
docker logs $(docker ps -q --filter "ancestor=frdel/agent-zero-run")
```

### GPU Issues

#### "NVIDIA driver not found"
```bash
# On GPU server, check drivers
nvidia-smi

# If not working, reinstall NVIDIA drivers
apt update
apt install -y nvidia-driver-470
reboot
```

#### "CUDA not available"
```bash
# Test CUDA
python3 -c "import torch; print(torch.cuda.is_available())"

# Reinstall CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt update
sudo apt install -y cuda
```

### NodeShift Specific Issues

#### "Can't find SSH key option in dashboard"
```bash
# Different locations to check:
# 1. Main instance page > "SSH Keys" tab
# 2. Account settings > "SSH Keys"  
# 3. Instance details > "Access" section
# 4. Security settings > "Authentication"

# If still can't find, try console access:
# Look for "Console" or "VNC" button
```

#### "Public key rejected"
```bash
# Make sure you copied the ENTIRE key including:
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... user@hostname

# Check key format
cat ~/.ssh/nodeshift_auto.pub

# Regenerate if corrupted
rm ~/.ssh/nodeshift_auto*
leverage ssh-setup
```

### Agent Zero Issues

#### "Web interface won't load"
```bash
# Check if container is running
docker ps

# Check port binding
docker port $(docker ps -q --filter "ancestor=frdel/agent-zero-run")

# Try different port
docker run -d -p 50002:50001 frdel/agent-zero-run

# Access at: http://localhost:50002
```

#### "Agent Zero gives errors"
```bash
# Check container logs
docker logs -f $(docker ps -q --filter "ancestor=frdel/agent-zero-run")

# Restart container
leverage kill
leverage agent

# Update to latest version
docker pull frdel/agent-zero-run
leverage kill
leverage agent
```

### Network Issues

#### "Can't reach any servers"
```bash
# Check internet connection
ping google.com

# Check DNS
nslookup 47.224.117.240

# Try from different network
# (mobile hotspot, etc.)

# Check firewall
sudo ufw status
sudo iptables -L
```

#### "Slow connections"
```bash
# Test connection speed
speedtest-cli

# Use compression
ssh -C -p 6489 root@47.224.117.240

# Try different DNS
sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

### Installation Issues

#### "Setup script fails"
```bash
# Run with verbose output
bash -x setup.sh

# Check permissions
ls -la ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

# Clear and restart
rm -rf ~/agent-zero
curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/setup.sh | bash
```

#### "Python errors"
```bash
# Update Python
sudo apt update
sudo apt install -y python3 python3-pip

# Install missing packages
pip3 install --user subprocess-run
pip3 install --user pathlib

# Check Python version
python3 --version
```

## Getting Help

### Debug Mode
```bash
# Run commands with verbose output
bash -x ~/agent-zero/scripts/leverage gpu

# Check all logs
journalctl -u docker
tail -f /var/log/syslog
```

### Reset Everything
```bash
# Nuclear option - start fresh
rm -rf ~/agent-zero
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/setup.sh | bash
```

### Contact Support
```bash
# Create issue with system info
leverage status > system_info.txt
# Attach system_info.txt to GitHub issue
```

## Prevention Tips

1. **Always test connections first**: `leverage test`
2. **Keep SSH keys backed up**: `cp ~/.ssh/nodeshift* ~/backup/`
3. **Monitor server status**: `leverage status`
4. **Update regularly**: `leverage update`
5. **Use screen/tmux for long operations**: `screen -S gpu_setup`

---

**Remember**: If all else fails, you can always start fresh with a new NodeShift instance and run the automation again. That's the beauty of automation - reproducible setup!