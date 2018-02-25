# Delete users in list
# Useful for cleaning up the test users in a particular list

# data source

$Filename = "user-source-file.csv"
$UserCSV = Import-Csv $Filename	

# AAD connection 
# When connecting an AAD account, we must specify tenant

$TenantID = "obliviate"
Connect-AzureAD -TenantId $TenantID

foreach ($line in $UserCsv){
	Remove-AzureADUser -ObjectId $line.PrincipalName
}