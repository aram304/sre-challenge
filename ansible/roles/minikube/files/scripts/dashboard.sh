#!/bin/bash

# IP-address of the host machine
ipaddress=$(ip addr | grep eth0 | grep 192.168 | awk '{print $2}' | cut -d/ -f1)

# Port forward the Kubernetes dashboard service to the host machine
minikube kubectl -- -n kubernetes-dashboard port-forward --address "$ipaddress" svc/kubernetes-dashboard 8001:80

