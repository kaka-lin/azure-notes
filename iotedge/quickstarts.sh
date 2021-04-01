#!/bin/bash

echo "Create Resource Group"
az group create --name KakaEdgeResources --location southeastasia

echo "Create IoT Hub"
az iot hub create --resource-group KakaEdgeResources --name kakaiothub --sku S1 --partition-count 2

echo "Register an IoT Edge device"
az iot hub device-identity create --device-id kakaEdgeDevice --edge-enabled --hub-name kakaiothub

echo "Create VM and install IoT Edge runtime"
az deployment group create \
--resource-group KakaEdgeResources \
--template-uri "https://aka.ms/iotedge-vm-deploy" \
--parameters dnsLabelPrefix='kaka-edge' \
--parameters adminUsername='kaka' \
--parameters deviceConnectionString=$(az iot hub device-identity connection-string show --device-id kakaEdgeDevice --hub-name kakaiothub -o tsv) \
--parameters authenticationType='password' \
--parameters adminPasswordOrKey="Password123@"
