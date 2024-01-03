# Prerequisites
=============
- A Kubernetes cluster running version 1.25 or later.
- kubectl or dashboard kube
- grant ```cluster-admin``` permission to the current user

Install tekton Pipeline
============
- Clone this repo ```git clone https://github.com/viyancs/kubernetes-rancher-scratch.git workspace```
- ```cd workspace/rke2/ha/pipelines/tekton```
- Install Operator
    ```
    kubectl apply -f operator.yaml
    ```
- Install Components
    ```
    kubectl apply -f operator_v1alpha1_config_cr.yaml
    ```


Expose DNS and pointing to tekton-dashboard pod
================
- create host tekton.vyn.com pointing to fixed server address
- create ingreess under tekton-pipeline namespace and pick tekton-dashboard service that listen on 9097 to be accessed from tekton.vyn.com domain
- fix firewall by adding port 80 on each server and fixed server because accessed from 80 port (tekton.vyn.com) 

config-tekton
============
 ```
    kubectl apply -f tekton-git-ssh-key.yaml
    kubectl apply -f 05-pipeline-account.yaml
    # before execute below change config.json auth value with out put from
    echo -n USER:ACCESS_TOKEN(github access token) | base64
    kubectl create secret generic kaniko-secret --from-file=config.json -n tekton-pipelines
    kubectl apply -f piperun-01-test.yaml
    kubectl apply -f pipeline-account.yaml
```
