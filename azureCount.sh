#!/bin/bash


vmCount=$(az resource list | jq " .[] .type" | grep -c -w '"Microsoft.Compute/virtualMachines"')

blobCount=$(az storage account list | jq " .[] .kind" | grep -c '"BlobStorage"')

sqlDbs=$(az resource list | jq " .[] .type" | grep -c '"Microsoft.Sql/servers/databases"')

cosmosDbs=$(az cosmosdb list | jq " .[] .provisioningState" | grep -c "Succeeded")

functionApps=$(az functionapp list | jq " .[] .kind" | grep -c "functionapp")

echo "VM Count: $vmCount"
echo "Blob Storage Count: $blobCount"
echo "SQL DB Count: $sqlDbs"
echo "Cosmos DB Count: $cosomosDbs"
echo "Functions App Count: $functionApps"
