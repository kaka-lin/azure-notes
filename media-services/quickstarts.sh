#!/bin/bash

RESOURCE_GROUP="KakaEdgeResources"
LOCATION="southeastasia"
AMS_ACCOUNT="kakamedia"
AMS_STORAGE_ACCOUNT="${AMS_ACCOUNT}storage"

echo "Creating a resource group"
az group create --name ${RESOURCE_GROUP} --location ${LOCATION}

echo "Creating a storage account"
az storage account create --name $AMS_STORAGE_ACCOUNT --kind StorageV2 --sku Standard_LRS -l westus2 -g $RESOURCE_GROUP

echo "Creating a media services account"
az ams account create --n $AMS_ACCOUNT -g $RESOURCE_GROUP --storage-account $AMS_STORAGE_ACCOUNT -l westus2

# Creates an Azure AD application
# and attaches a service principal to the account
echo "Creating an Azure application and attaches a service principal to the account"
SPN="$AMS_ACCOUNT-access-sp" # this is the default naming convention used by `az ams account sp`

if [ -z "$(az ad sp list --display-name $SPN --query="[].displayName" -o tsv)" ]; then
    AMS_CONNECTION=$(az ams account sp create -o yaml --resource-group $RESOURCE_GROUP --account-name $AMS_ACCOUNT)
else
    AMS_CONNECTION=$(az ams account sp reset-credentials -o yaml --resource-group $RESOURCE_GROUP --account-name $AMS_ACCOUNT)
fi

# Capture config information
re="AadTenantId:[[:space:]]([0-9a-z\-]*)"
AAD_TENANT_ID=$([[ "$AMS_CONNECTION" =~ $re ]] && echo ${BASH_REMATCH[1]})

re="AadClientId:[[:space:]]([0-9a-z\-]*)"
AAD_SERVICE_PRINCIPAL_ID=$([[ "$AMS_CONNECTION" =~ $re ]] && echo ${BASH_REMATCH[1]})

re="AadSecret:[[:space:]]([0-9a-z\-]*)"
AAD_SERVICE_PRINCIPAL_SECRET=$([[ "$AMS_CONNECTION" =~ $re ]] && echo ${BASH_REMATCH[1]})

echo "AAD_SERVICE_PRINCIPAL_NAME=$SPN"
echo "AAD_SERVICE_PRINCIPAL_ID=$AAD_SERVICE_PRINCIPAL_ID"
echo "AAD_SERVICE_PRINCIPAL_SECRET=$AAD_SERVICE_PRINCIPAL_SECRET"
