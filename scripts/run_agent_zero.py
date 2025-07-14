#!/usr/bin/env python3
import subprocess
import json
import sys
import time
from pathlib import Path

def run_nodeshift_task(task_file):
    """Execute NodeShift automation task"""
    with open(task_file, 'r') as f:
        task = json.load(f)
    
    print(f"🚀 Running task: {task['task_name']}")
    print(f"📋 Description: {task['description']}")
    print("")
    
    for i, step in enumerate(task['steps'], 1):
        action = step['action']
        print(f"📋 Step {i}/{len(task['steps'])}: {action}")
        
        if action == "ssh_connect":
            # SSH connection handled by ssh_manager.py
            print(f"   Connecting to {step['target']} ({step['ip']}:{step['port']})")
            continue
        elif 'commands' in step:
            for j, cmd in enumerate(step['commands'], 1):
                print(f"   [{j}/{len(step['commands'])}] Running: {cmd}")
                try:
                    result = subprocess.run(cmd, shell=True, check=True, 
                                          capture_output=True, text=True, timeout=300)
                    if result.stdout:
                        print(f"       Output: {result.stdout.strip()}")
                except subprocess.CalledProcessError as e:
                    print(f"       ❌ Error: {e}")
                    print(f"       ❌ Stderr: {e.stderr}")
                    # Continue with next command
                except subprocess.TimeoutExpired:
                    print(f"       ⏰ Command timed out after 5 minutes")
                    # Continue with next command
                
                # Small delay between commands
                time.sleep(1)
        
        print(f"   ✅ Step {i} completed")
        print("")
    
    print("🎉 Task completed successfully!")

def run_custom_commands(commands):
    """Run a list of custom commands"""
    print("🚀 Running custom commands...")
    
    for i, cmd in enumerate(commands, 1):
        print(f"📋 Command {i}/{len(commands)}: {cmd}")
        try:
            result = subprocess.run(cmd, shell=True, check=True, 
                                  capture_output=True, text=True, timeout=300)
            if result.stdout:
                print(f"   Output: {result.stdout.strip()}")
            print(f"   ✅ Command {i} completed")
        except subprocess.CalledProcessError as e:
            print(f"   ❌ Error: {e}")
            print(f"   ❌ Stderr: {e.stderr}")
        except subprocess.TimeoutExpired:
            print(f"   ⏰ Command timed out after 5 minutes")
        
        print("")
    
    print("🎉 All commands completed!")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: run_agent_zero.py <task_file_or_command>")
        print("")
        print("Examples:")
        print("  run_agent_zero.py ~/agent-zero/configs/nodeshift_setup.json")
        print("  run_agent_zero.py 'nvidia-smi'")
        print("  run_agent_zero.py 'docker ps && nvidia-smi'")
        sys.exit(1)
    
    arg = sys.argv[1]
    
    # Check if it's a file path
    if Path(arg).exists() and arg.endswith('.json'):
        run_nodeshift_task(arg)
    else:
        # Treat as command(s)
        commands = arg.split(' && ')
        run_custom_commands(commands)
