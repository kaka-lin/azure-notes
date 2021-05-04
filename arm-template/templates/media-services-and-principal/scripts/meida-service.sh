#!/bin/bash

# =========================================================
# Define helper function for logging
# =========================================================

UUID=`date +"%Y-%m-%dT%T"`-`cat /proc/sys/kernel/random/uuid | cut -c1-8`

info() {
    echo "$(date +"%Y-%m-%d %T") [INFO]"
}

# Define helper function for logging. This will change the Error text color to red
error() {
    #echo "$(tput setaf 1)$(date +"%Y-%m-%d %T") [ERROR]"
    # tput doent work in 2.15.1
    echo "$(date +"%Y-%m-%d %T") [ERROR]"
}

printf "\n%60s\n" " " | tr ' ' '-'
echo "$(info) installing azure iot extension"
az extension add --name azure-iot

# Media Services
#AMS_CONNECTION=""
SPN=""
AAD_SERVICE_PRINCIPAL_SECRET=""

if [ -z "$(az ams account list --query "[?name=='${AMS_ACCOUNT}']" -o tsv)" ]; then
    echo "$(error) AMS ACCOUNT \"${AMS_ACCOUNT}\" does not exist"
else
    SPN="${AMS_ACCOUNT}-access-sp"
    if [ -z "$(az ad sp list --display-name ${SPN} --query="[].displayName" -o tsv)" ]; then
        echo "$(info) ADD \"${SPN}\" does not exist, creating..."
        #AMS_CONNECTION=$(az ams account sp create -o yaml --resource-group ${RESOURCE_GROUP} --account-name ${AMS_ACCOUNT})
        AAD_SERVICE_PRINCIPAL_SECRET=$(az ams account sp create --resource-group ${RESOURCE_GROUP} --account-name ${AMS_ACCOUNT} | jq ".AadSecret")
        echo "$(info) AAD_SERVICE_PRINCIPAL_SECRET: \"${AAD_SERVICE_PRINCIPAL_SECRET}\""
    else
        echo "$(info) ADD \"${SPN}\" existing, reset-credential..."
        #AMS_CONNECTION=$(az ams account sp reset-credentials -o yaml --resource-group ${RESOURCE_GROUP} --account-name ${AMS_ACCOUNT})
        AAD_SERVICE_PRINCIPAL_SECRET=$(az ams account sp reset-credentials --resource-group ${RESOURCE_GROUP} --account-name ${AMS_ACCOUNT} | jq ".AadSecret")
        echo "$(info) AAD_SERVICE_PRINCIPAL_SECRET: \"${AAD_SERVICE_PRINCIPAL_SECRET}\""
    fi

    #re="AadSecret:[[:space:]]([0-9a-z\-]*)"
    #AAD_SERVICE_PRINCIPAL_SECRET=$([[ "${AMS_CONNECTION}" =~ ${re} ]] && echo ${BASH_REMATCH[1]})
fi

echo "$(info) AAD_SERVICE_PRINCIPAL_SECRET: \"${AAD_SERVICE_PRINCIPAL_SECRET}\""

output="{
    \"amsinfo\":{
        \"servicesPrincipalName\":\"${SPN}\",
        \"servicesPrincipalSecret\":\"${AAD_SERVICE_PRINCIPAL_SECRET}\"
    }
}"

echo "${output}" > ${AZ_SCRIPTS_OUTPUT_PATH}
