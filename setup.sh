#!/bin/bash
# =================================================================
# Agent Zero NodeShift Automation Suite
# Complete automation - no manual SSH ever again
# =================================================================

set -e

echo "🚀 LEVERAGE AI - Agent Zero NodeShift Automation Setup"
echo "======================================================="

# =================================================================
# CONFIGURATION
# =================================================================

# NodeShift Details (update these with your actual values)
NODESHIFT_GPU_IP="47.224.117.240"
NODESHIFT_GPU_PORT="6489"
NODESHIFT_CPU_IP_1="45.138.27.27"
NODESHIFT_CPU_IP_2="84.32.131.190"

# Agent Zero Configuration
AGENT_ZERO_DIR="$HOME/agent-zero"
DOCKER_IMAGE="frdel/agent-zero-run"
AGENT_ZERO_PORT="50001"

# =================================================================
# STEP 1: Install Agent Zero
# =================================================================

install_agent_zero() {
    echo "📦 Installing Agent Zero..."
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        echo "⚠️  Please logout and login again for Docker permissions"
        exit 1
    fi
    
    # Pull Agent Zero Docker image
    docker pull $DOCKER_IMAGE
    
    # Create Agent Zero workspace
    mkdir -p $AGENT_ZERO_DIR/scripts
    mkdir -p $AGENT_ZERO_DIR/configs
    
    echo "✅ Agent Zero installed successfully"
}

# =================================================================
# STEP 2: Create Automated SSH Management
# =================================================================

create_ssh_automation() {
    echo "🔑 Setting up SSH automation..."
    
    # Download SSH manager script
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/scripts/ssh_manager.py -o $AGENT_ZERO_DIR/scripts/ssh_manager.py
    chmod +x $AGENT_ZERO_DIR/scripts/ssh_manager.py
    
    echo "✅ SSH automation created"
}

# =================================================================
# STEP 3: Create One-Command Connection Scripts
# =================================================================

create_connection_scripts() {
    echo "⚡ Creating one-command connection scripts..."
    
    # Download connection scripts
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/scripts/gpu -o $AGENT_ZERO_DIR/scripts/gpu
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/scripts/cpu1 -o $AGENT_ZERO_DIR/scripts/cpu1
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/scripts/cpu2 -o $AGENT_ZERO_DIR/scripts/cpu2
    
    # Make scripts executable
    chmod +x $AGENT_ZERO_DIR/scripts/gpu
    chmod +x $AGENT_ZERO_DIR/scripts/cpu1
    chmod +x $AGENT_ZERO_DIR/scripts/cpu2
    
    # Add to PATH
    echo "export PATH=\$PATH:$AGENT_ZERO_DIR/scripts" >> ~/.bashrc
    
    echo "✅ Connection scripts created:"
    echo "   • Type 'gpu' to connect to 4x RTX 3060 cluster"
    echo "   • Type 'cpu1' to connect to VPS 1"
    echo "   • Type 'cpu2' to connect to VPS 2"
}

# =================================================================
# STEP 4: Create Agent Zero Task Automation
# =================================================================

create_agent_zero_tasks() {
    echo "🤖 Creating Agent Zero automation tasks..."
    
    # Download configuration files
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/configs/nodeshift_setup.json -o $AGENT_ZERO_DIR/configs/nodeshift_setup.json
    
    # Download Agent Zero runner
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/scripts/run_agent_zero.py -o $AGENT_ZERO_DIR/scripts/run_agent_zero.py
    chmod +x $AGENT_ZERO_DIR/scripts/run_agent_zero.py
    
    echo "✅ Agent Zero tasks created"
}

# =================================================================
# STEP 5: Create Master Control Script
# =================================================================

create_master_control() {
    echo "👑 Creating master control interface..."
    
    # Download master control script
    curl -fsSL https://raw.githubusercontent.com/mikeschlottig/leverage-ai-nodeshift-automation/main/scripts/leverage -o $AGENT_ZERO_DIR/scripts/leverage
    chmod +x $AGENT_ZERO_DIR/scripts/leverage
    
    # Create symlink for global access
    sudo ln -sf $AGENT_ZERO_DIR/scripts/leverage /usr/local/bin/leverage
    
    echo "✅ Master control created"
}

# =================================================================
# STEP 6: Start Agent Zero Service
# =================================================================

start_agent_zero() {
    echo "🏁 Starting Agent Zero service..."
    
    # Start Agent Zero container
    docker run -d \
        --name agent-zero-leverage \
        -p $AGENT_ZERO_PORT:50001 \
        -v $AGENT_ZERO_DIR:/workspace \
        -v $HOME/.ssh:/root/.ssh \
        --restart unless-stopped \
        $DOCKER_IMAGE
    
    echo "✅ Agent Zero started at: http://localhost:$AGENT_ZERO_PORT"
}

# =================================================================
# MAIN EXECUTION
# =================================================================

main() {
    echo "🎯 Starting complete automation setup..."
    
    install_agent_zero
    create_ssh_automation  
    create_connection_scripts
    create_agent_zero_tasks
    create_master_control
    start_agent_zero
    
    echo ""
    echo "🎉 SETUP COMPLETE!"
    echo "=================="
    echo ""
    echo "🔥 ULTRA-SIMPLE COMMANDS (< 15 words each):"
    echo ""
    echo "   leverage gpu        # Connect to GPU cluster"
    echo "   leverage agent      # Open Agent Zero interface" 
    echo "   leverage setup-gpu  # Auto-install everything"
    echo ""
    echo "🔑 NEXT STEPS:"
    echo "1. Run: leverage ssh-setup"
    echo "2. Copy the public key to your NodeShift dashboard"
    echo "3. Run: leverage gpu"
    echo ""
    echo "💀 NO MORE MANUAL SSH HELL! 💀"
}

# Run main function
main