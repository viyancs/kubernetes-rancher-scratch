# Documentation Installation Rancher

Quickly stand up an  RKE2 HA-style installation of Ubuntu Rancher products on your infrastructure.

## Rancher Management Vshpere
### Clone Repository for guidlines
```
git clone https://github.com/viyancs/kubernetes-rancher-scratch.git
cd kubernetes-rancher-scratch/rke2/ha
```
### Run this configurationto install server rke2
- Create 3 vm Ubuntu 22.04.2  with rsa key access 
- Create unique hostname in each server node
- run script ``` server.sh ``` do ``` chmod+x server.sh ``` first
