#!/bin/bash

printf "\n%60s\n" " " | tr ' ' '-'
echo "$(info) Installing apt-packages "
# apt-get update && apt-get install -y jq coreutils unzip
echo "$(info) Apt-packages installed"

# printf "\n%60s\n" " " | tr ' ' '-'
# echo "$(info) Installing pip packages."
# python -m pip -q install --upgrade pip
# echo "$(info) Installing iotedgedev."
# pip -q install --upgrade iotedgedev==${IOTEDGE_DEV_VERSION}

# echo "$(info) Updating Azure CLI."
# pip -q install --upgrade azure-cli
# pip -q install --upgrade azure-cli-telemetry

# printf "\n%60s\n" " " | tr ' ' '-'
# echo "$(info) Installing Azure IoT extension."
# az extension add --name azure-iot
# pip -q install --upgrade jsonschema
echo "Installing iotedgedev"
pip install iotedgedev==2.1.4

echo "Updating az-cli"
pip install --upgrade azure-cli
pip install --upgrade azure-cli-telemetry

echo "installing azure iot extension"
az extension add --name azure-iot

pip3 install --upgrade jsonschema
apk add coreutils
echo "Installation complete"

az iot hub device-identity create --device-id ${IoTEdgeDeviceId} --edge-enabled --hub-name ${IoTHubName}
