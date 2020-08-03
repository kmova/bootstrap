## Reference:
- https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1

## Install Docker
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo usermod -aG docker $USER
sudo rm -rf ~/.docker
sudo chmod 666 /var/run/docker.sock
```

## Verify 
```
docker run hello-world
```
