sudo usermod -aG docker $USER
sudo rm -rf ~/.docker
sudo chmod 666 /var/run/docker.sock
