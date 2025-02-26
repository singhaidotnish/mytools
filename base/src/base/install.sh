#!/bin/bash

# Update and install essential packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget build-essential

# Clone a GitHub repository (replace with your repo URL)
git clone https://github.com/singhaidotnish/mytools.git ~/mytools

# Navigate to the repository
cd ~/mytools

# Check if there's an install script, then run it
if [ -f install.sh ]; then
    chmod +x install.sh
    ./install.sh
fi

# Alternatively, run a manual setup (replace with actual commands)
# sudo make install
# sudo ./setup.py install

echo "Installation complete!"
