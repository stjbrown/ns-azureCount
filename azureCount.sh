#!/bin/bash

VMCOUNT=$(az resource list | jq " .[] .type" | grep -c -w '"Microsoft.Compute/virtualMachines"')
SQLCOUNT=$(az resource list | jq " .[] .type" | grep -c '"Microsoft.Sql/servers/databases"')
COSMOSCOUNT=$(az cosmosdb list | jq " . | length")
FUNCTIONAPPS=$(az functionapp list | jq " . | length")
CONTAINERCOUNT=0

for row in $(az storage account list | jq -r ".[] | @base64"); do
  _jq() {
                echo ${row} | base64 --decode | jq -r ${1}

  }
 if [ $(_jq '.kind') = "BlobStorage" ]; then
     NEWCOUNT="$(az storage container list --account-name $(_jq '.name') | jq '. | length')"
     CONTAINERCOUNT=$(($CONTAINERCOUNT + $NEWCOUNT))
fi
done






echo "VM Count: $VMCOUNT"
echo "Blob Storage Containers: $CONTAINERCOUNT"
echo "SQL DB Count: $SQLCOUNT"
echo "Cosmos DB Count: $COSMOSCOUNT"
#echo "Functions App Count: $FUNCTIONAPPS"
