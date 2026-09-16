#!/bin/bash

# Start minikube with specified resources and addons
minikube start --cpus=4 --memory=8192 --disk-size=20g --ports=80:80 --driver=docker --mount-string="/var/lib/sre-challenge:/mnt/sre-challenge" --addons=ingress,metrics-server,dashboard
