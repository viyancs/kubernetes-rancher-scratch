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
- Config Hostname on each server ```chmod +x config-hostname.sh && ./config-hostname.sh```
- Config Hostname code part ```/usr/local/nginx/conf.d/stream.conf```, Run script for config load balancer ``` chmod +x load-balancer.sh && ./load-balancer.sh ```
- Run firewall script on each server ``` chmod +x firewall.sh && ./firewall.sh```
- quit from ssh fixed server
- ssh into each server for the first server create this config file 
```
# Define the file path
# create file on this location /etc/rancher/rke2/config.yaml

# Content for the RKE2 config file
 tls-san:
   - fxd.vyn.com
   - 10.130.0.2

```
- for the second and the other server
```
# Define the file path
# create file on this location /etc/rancher/rke2/config.yaml

# Content for the RKE2 config file
 server: https://fxd.vyn.com:9345
 token: token from first server

 tls-san:
   - fxd.vyn.com
   - 10.130.0.2

```
- Config Hostname on each server ```chmod +x config-hostname.sh && ./config-hostname.sh```
- Run firewall script on each server ``` chmod +x firewall.sh && ./firewall.sh```
- Run this script on each server ``` chmod +x server.sh && ./server.sh ``` 
- restart rke2 service each server 
```
systemctl stop rke2-server
systemctl start rke2-server
```
- ensure each server kube cluster for the cluster by running this && the result should show 3 nodes
```
kubectl get nodes 
```

# add node agent
- ssh into node agent 
- Config Hostname on each server ```chmod +x config-hostname.sh && ./config-hostname.sh```
- Run firewall script on each server ``` chmod +x firewall.sh && ./firewall.sh```
- Run this script on each server ``` chmod +x worker.sh && ./worker.sh ``` 


# install rancher
- ssh into server 1
- config hostname on ``` install-ranher.sh ```
- run installer ``` chmod +x install-rancher.sh && install-rancher.sh```
