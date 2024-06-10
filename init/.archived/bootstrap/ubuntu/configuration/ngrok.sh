#!/bin/bash

# your token from https://dashboard.ngrok.com/get-started/your-authtoken
xdg-open https://dashboard.ngrok.com/get-started/your-authtoken
echo "agrega tu token de https://dashboard.ngrok.com/get-started/your-authtoken"
read -s -p "token: " token
ngrok config add-authtoken "$token"
