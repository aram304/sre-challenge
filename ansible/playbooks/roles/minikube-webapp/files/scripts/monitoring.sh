#!/bin/bash

URL="http://localhost:5000/health"
MAIL_TO=aram.airapetian@gmail.com


STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" != "200" ]; then
   mail -s "MINIKUBE-WEBSERVER HEALTH CHECK FAILED" "$MAIL_TO"
fi

