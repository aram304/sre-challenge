#!/bin/bash

# Start minikube with specified resources and addons
minikube start --cpus=4 --memory=8192 --disk-size=20g --ports=80:80 --driver=docker --addons=ingress,metrics-server,dashboard
