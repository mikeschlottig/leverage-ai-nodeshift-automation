#!/usr/bin/env python3
import subprocess
import requests
import json
import os
import sys
from pathlib import Path

class NodeShiftSSHManager:
    def __init__(self):
        self.ssh_dir = Path.home() / '.ssh'
        self.ssh_dir.mkdir(exist_ok=True)
        
    def generate_ssh_key(self, key_name="nodeshift_auto"):
        """Generate SSH key pair automatically"""
        key_path = self.ssh_dir / key_name
        
        if key_path.exists():
            print(f"SSH key {key_name} already exists")
            return str(key_path)
            
        cmd = [
            'ssh-keygen', 
            '-t', 'rsa', 
            '-b', '4096',
            '-f', str(key_path),
            '-N', '',  # No passphrase
            '-C', 'auto-generated@leverageai.network'
        ]
        
        subprocess.run(cmd, check=True)
        os.chmod(key_path, 0o600)
        
        print(f"✅ Generated SSH key: {key_path}")
        return str(key_path)
    
    def get_public_key(self, key_name="nodeshift_auto"):
        """Get public key content"""
        pub_key_path = self.ssh_dir / f"{key_name}.pub"
        with open(pub_key_path, 'r') as f:
            return f.read().strip()
    
    def connect_to_nodeshift(self, ip, port, key_name="nodeshift_auto"):
        """Connect to NodeShift instance"""
        key_path = self.ssh_dir / key_name
        
        cmd = [
            'ssh',
            '-i', str(key_path),
            '-p', str(port),
            '-o', 'StrictHostKeyChecking=no',
            '-o', 'UserKnownHostsFile=/dev/null',
            f'root@{ip}'
        ]
        
        print(f"🔗 Connecting to {ip}:{port}")
        subprocess.run(cmd)

    def test_connection(self, ip, port, key_name="nodeshift_auto"):
        """Test SSH connection without connecting"""
        key_path = self.ssh_dir / key_name
        
        cmd = [
            'ssh',
            '-i', str(key_path),
            '-p', str(port),
            '-o', 'StrictHostKeyChecking=no',
            '-o', 'UserKnownHostsFile=/dev/null',
            '-o', 'ConnectTimeout=10',
            '-o', 'BatchMode=yes',
            f'root@{ip}',
            'echo "Connection successful"'
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=15)
            if result.returncode == 0:
                print(f"✅ Connection to {ip}:{port} successful")
                return True
            else:
                print(f"❌ Connection to {ip}:{port} failed: {result.stderr}")
                return False
        except subprocess.TimeoutExpired:
            print(f"⏰ Connection to {ip}:{port} timed out")
            return False

if __name__ == "__main__":
    manager = NodeShiftSSHManager()
    
    if len(sys.argv) < 2:
        print("Usage: ssh_manager.py [generate|connect|pubkey|test] [args...]")
        sys.exit(1)
    
    action = sys.argv[1]
    
    if action == "generate":
        manager.generate_ssh_key()
    elif action == "pubkey":
        print(manager.get_public_key())
    elif action == "connect":
        if len(sys.argv) < 4:
            print("Usage: ssh_manager.py connect <ip> <port>")
            sys.exit(1)
        manager.connect_to_nodeshift(sys.argv[2], sys.argv[3])
    elif action == "test":
        if len(sys.argv) < 4:
            print("Usage: ssh_manager.py test <ip> <port>")
            sys.exit(1)
        manager.test_connection(sys.argv[2], sys.argv[3])