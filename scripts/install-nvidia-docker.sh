#!/bin/bash

if which nvidia-docker; then
	echo "Nvidia-docker is already installed on this machine"
	if ! docker volume ls | awk '{print $1}' | grep 'nvidia-docker'; then
    	echo "Nvidia driver volume not found. Creating..."
		sudo nvidia-docker run nvidia/cuda nvidia-smi
		echo "Check [docker volume ls]"
	else
		echo "Nvidia-docker and driver volume is ready"
	fi
    exit 0
fi

wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1_amd64.tar.xz
sudo tar --strip-components=1 -C /usr/bin -xvf /tmp/nvidia-docker*.tar.xz && rm /tmp/nvidia-docker*.tar.xz

# Run nvidia-docker-plugin
sudo -b nohup nvidia-docker-plugin > /tmp/nvidia-docker.log

sudo systemctl start nvidia-docker
sudo systemctl enable nvidia-docker

if ! docker volume ls | awk '{print $1}' | grep 'nvidia-docker'; then
    echo "Creating nvidia driver volume..."
	sudo nvidia-docker run nvidia/cuda nvidia-smi
fi
