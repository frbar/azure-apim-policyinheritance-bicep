# Purpose

This repository contains a Bicep template to create APIM Consumption and simple API / API operations, with XML policies.

# Deploy the infrastructure

```powershell
az login

$subscription = "My Subscription"
az account set --subscription $subscription

$rgName = "frbar-apim-poc"
$envName = "fbapim01"
$location = "West Europe"

az group create --name $rgName --location $location

# Deploy infrastructure
az deployment group create --resource-group $rgName `
                           --template-file infra.bicep `
                           --mode complete `
                           --parameters envName=$envName publisherName=$envName publisherEmail="admin@example.com"

```

# Tear down

```powershell
az group delete --name $rgName
```