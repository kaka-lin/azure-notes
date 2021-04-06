#!/bin/bash

RESOURCE_GROUP="KakaEdgeResources"
LOCATION="southeastasia"
IOTHUB_NAME="kakaiothub"
DEVICE_NAME="kakaEdgeDevice"
CUSTOM_VISION_NAME="kakafactoryai"
CUSTOM_VISION_TYPE="CustomVision.Training"
CUSTOM_VISION_LOCATION="westus2"

# echo "Create Resource Group"
az group create --name ${RESOURCE_GROUP} --location ${LOCATION}

# echo "Create IoT Hub"
az iot hub create --resource-group ${RESOURCE_GROUP} --name ${IOTHUB_NAME} --sku S1 --partition-count 2

# echo "Register an IoT Edge device"
az iot hub device-identity create --device-id ${DEVICE_NAME} --edge-enabled --hub-name ${IOTHUB_NAME}

echo "Create VM and install IoT Edge runtime"
az deployment group create \
    --resource-group ${RESOURCE_GROUP} \
    --template-uri "https://aka.ms/iotedge-vm-deploy" \
    --parameters dnsLabelPrefix='kaka-edge' \
    --parameters adminUsername='kaka' \
    --parameters deviceConnectionString=$(az iot hub device-identity connection-string show --device-id ${DEVICE_NAME} --hub-name ${IOTHUB_NAME} -o tsv) \
    --parameters authenticationType='password' \
    --parameters adminPasswordOrKey="Password123@"

echo "Registry a Custom Vision service"
az cognitiveservices account create \
    --name ${CUSTOM_VISION_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --kind ${CUSTOM_VISION_TYPE} \
    --sku S0 \
    --location ${CUSTOM_VISION_LOCATION} \
    --yes
