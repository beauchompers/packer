#!/bin/bash

echo "==> Installing updates"
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential linux-headers-$(uname -r)
sudo apt install -y dkms