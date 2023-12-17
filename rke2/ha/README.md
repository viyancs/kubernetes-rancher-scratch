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
- SSH into fixed-server 
- Config Host & Replace my-shared-secret with token from ```cat /var/lib/rancher/rke2/server/node-token``` on ```fixed-server.sh``` and then run ``` chmod +x server.sh && ./fixed-server.sh ```
- Config Host, Run script for config load balancer ``` chmod +x load-balancer.sh && ./load-balancer.sh ```
- quit from ssh fixed server
- Run firewall script on each server ``` chmod +x firewall.sh && ./firewall.sh```
- Run this script on each server ``` chmod +x server.sh && ./server.sh ``` 
- SSH into each server 
- Config Host, Config server url rke2 config file, Replace my-shared-secret with token from ```cat /var/lib/rancher/rke2/server/node-token``` on ```add-server-node.sh``` and then run ``` chmod +x add-server-node.sh && ./add-server-node.sh ```
- restart rke2 service each server 
```
systemctl stop rke2-server
systemctl start rke2-server
```
- ensure each server kube cluster for the cluster by running this
```
kubectl get nodes 
```


