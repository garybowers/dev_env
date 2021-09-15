#!/usr/bin/env bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get full-upgrade -y --allow-downgrades
sudo apt-get install -y ca-certificates gnupg apt-transport-https samba-client cifs-utils software-properties-common gnupg-agent nfs-common keepassxc vim byobu htop mc git tig wireguard wireguard-tools wireguard-dkms dconf-editor dconf-cli openvpn network-manager-openvpn-gnome fish steam libsdl2-dev

mkdir -p ~/.local/bin

# Google Chrome
if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update -y && sudo apt-get install -y google-chrome-stable
fi

# KVM
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager ssh-askpass-gnome
sudo adduser gary libvirt

# Terraform
TFVER=1.0.6
if [ ! -f /usr/local/bin/terraform ]; then
cd /tmp && wget https://releases.hashicorp.com/terraform/$TFVER/terraform_${TFVER}_linux_amd64.zip && unzip terraform_${TFVER}_linux_amd64.zip && sudo mv /tmp/terraform /usr/local/bin && rm terraform_*.zip
fi

# Gcloud SDK
if [ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]; then
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update -y && sudo apt-get install -y google-cloud-sdk kubectl
fi

# Golang
GOVER=1.17.1
if [ ! -d "/usr/local/go" ]; then
cd /tmp && wget https://golang.org/dl/go${GOVER}.linux-amd64.tar.gz && tar xvzf go${GOVER}.linux-amd64.tar.gz && rm go${GOVER}.tar.gz* && sudo mv ./go /usr/local/
fi
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bachrc

# Docker
if [ ! -f /usr/bin/docker ]; then
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo apt-key add - \
  && sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
focal \
stable"
sudo apt-get update -y && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker gary
fi

flatpak install -y flathub spotify slack app/org.videolan.VLC/x86_64/stable remmina app/io.github.Hexchat/x86_64/stable
