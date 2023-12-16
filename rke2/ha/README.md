# Documentation Installation Rancher

Quickly stand up an  RKE2 HA-style installation of Ubuntu Rancher products on your infrastructure.

# Setting up an HA cluster requires the following steps:

1. Configure a fixed registration address
2. Launch the first server node
3. Join additional server nodes
4. Join agent nodes

## Rancher Management Vshpere
### Clone Repository for guidlines
```
git clone https://github.com/viyancs/kubernetes-rancher-scratch.git
cd kubernetes-rancher-scratch/rke2/ha
```
### Run this configurationto install server rke2
- Create 3 vm Ubuntu 22.04.2  with rsa key access 
- Create unique hostname in each server node , put 1 node for fixed-server
- Run this script on each server ``` chmod+x server.sh && ./server.sh ``` 
- SSH into fixed-server 
- Modify my-shared-secret on ```fixed-server.sh``` and run ``` chmod+x server.sh && ./fixed-server.sh ```

