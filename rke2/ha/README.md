# Documentation Installation Rancher

Quickly stand up an HA-style installation of Ubuntu Rancher products on your infrastructure.

**You will be responsible for any and all infrastructure costs incurred by these resources.**
As a result, this repository minimizes costs by standing up the minimum required resources for a given provider.

## Rancher Management Vshpere
### Clone Repository for guidlines
```
git clone https://github.com/viyancs/kubernetes-rancher-scratch.git
cd kubernetes-rancher-scratch/rke2/ha
```
### Run this configuration Cluster on 3 node (vm)
- Create  one Ubuntu 22.04.2 VM with rsa key access with name of vm is rke2-server
- Update the system
    ```
    sudo apt update && sudo apt install curl -y
    ```
- Run Installer
    ```
    curl -sfL https://get.rke2.io | sh -
    # enable service
    systemctl enable rke2-server.service
    systemctl start rke2-server.service
    ```

- Install RKE 
    ```
    curl -O https://github.com/rancher/rke/releases/download/v1.5.0/rke_linux-amd64
    mv rke_linux-amd64 rke
    chmod +x rke
    rke --version
    ```
- create 3 vm with specification ubuntu os 22.04, and ssh access that can be accessed from rancher node 
permission : 

To                         Action      From
--                         ------      ----
22/tcp                     LIMIT       Anywhere
2375/tcp                   ALLOW       Anywhere
2376/tcp                   ALLOW       Anywhere
2380                       ALLOW       Anywhere
2379                       ALLOW       Anywhere
22/tcp (v6)                LIMIT       Anywhere (v6)
2375/tcp (v6)              ALLOW       Anywhere (v6)
2376/tcp (v6)              ALLOW       Anywhere (v6)
2380 (v6)                  ALLOW       Anywhere (v6)
2379 (v6)                  ALLOW       Anywhere (v6)

spec:
200GB HDD
12 core


- create racher-cluster.yml file 
- run cluster


