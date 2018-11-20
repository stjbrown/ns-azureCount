#Netskope Azure Count

$VMCOUNT = (az resource list | jq " .[] .type" | Select-String -Pattern '"Microsoft.Compute/virtualMachines"').length

$SQLCOUNT = (az resource list | jq " .[] .type" | Select-String -Pattern '"Microsoft.Sql/servers/databases"').length

$COSMOSCOUNT = az cosmosdb list | jq " . | length"

#$FUNCTIONAPPS = az functionapp list | jq " . | length"

$CONTAINERCOUNT = 0

$STORAGEACCOUNTS = az storage account list | jq -r ".[] | @base64" 

foreach ($row in $STORAGEACCOUNTS) {
	
	$ACCOUNT = $row | base64 --decode

	$ACCOUNTKIND = $ACCOUNT | jq " .kind"
	$ACCOUNTNAME = $ACCOUNT | jq " .name"
    IF ($ACCOUNTKIND -eq '"BlobStorage"') {     	

    	$NEWCOUNT = az storage container list --account-name $ACCOUNTNAME | jq ". | length"
        $CONTAINERCOUNT = $CONTAINERCOUNT + $NEWCOUNT
  	} 
}


Write-Host "VM Count: $VMCOUNT"
Write-Host "Blob Storage Containers: $CONTAINERCOUNT"
Write-Host "SQL DB Count: $SQLCOUNT"
Write-Host "Cosmos DB Count: $COSMOSCOUNT"
#Write-Host "Functions App Count: $FUNCTIONAPPS"
