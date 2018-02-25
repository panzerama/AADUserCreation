# Creates a set of AD users from a csv file and puts the created Object ID to a
# users.json file

# input data 

$Filename = "user-source-file.csv"
$UserCSV = Import-Csv $Filename	

# AAD connection 
# When connecting an AAD account, we must specify tenant

$TenantID = "obliviate"
Connect-AzureAD -TenantId $TenantID

# Creating a password object
# We will set the initial password to the same value for each

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Event123"

$userArray = @()

foreach ($line in $UserCsv){
	$UserName = $line.UserName
	$PrincipalName = $line.PrincipalName
	$Nickname = $line.Nickname

	$NewUserOutput = New-AzureADUser -AccountEnabled $True `
									-DisplayName $UserName `
									-UserPrincipalName $PrincipalName `
									-PasswordProfile $PasswordProfile `
									-mailNickname $Nickname 
	Write-Host $NewUserOutput.ObjectId
	$PropertyHash = @{
		UserID = $NewUserOutput.ObjectId | Out-String
		FirstName = $line.FirstName
		LastName = $line.LastName
		Email = $PrincipalName
	}

	$UserObject = New-Object PSObject -Property $PropertyHash

	$userArray += $UserObject 
}

$userArray | ConvertTo-Json > userOutput.txt