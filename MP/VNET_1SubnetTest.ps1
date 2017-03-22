
$SubscriptionName = 'aVisual Studio Ultimate with MSDN'
$TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

$user = "scripts@parks65.com"
$pw = ConvertTo-SecureString "Caviar!65" -AsPlainText -Force
$Cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pw

Write-Output 'Connecting to Azure credential'
$Account = Add-AzureRmAccount -Credential $Cred
if (!$Account) {
    # Throw "Could not authenticate using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct."
    Throw "Could not authenticate using entered credentials. Make sure the user name and password are correct."
}

Write-Output 'Setting the Subscription'
$subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription



$LocName = “South Central US”

$templatePath = “C:\GitHub\ARM-Templates\MP\VNET_1Subnet.json”
$parameterFilePath = “C:\GitHub\ARM-Templates\MP\VNET_1Subnet.parameters.json”

$adminUsername = ”parks65”
$adminPassword = ConvertTo-SecureString "Caviar!60062" -AsPlainText -Force

$deploymentName = “NetworkARMTest”

get-date


$rgName = “aNetworkRGCompZ”

$rg = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue

if ($rg -eq $null) {
    New-AzureRmResourceGroup -Name $rgName -Location $LocName 
}

get-date


$parameters = @{
    "newStorageAccountName" = "$newStorageAccountName";
    "location" = "$LocName”;
    ”adminUsername” = ”$adminUsername”;
    ”adminPassword” = ”$adminPassword”;
    ”dnsLabelPrefix” = ”$dnsLabelPrefix"
}



# New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templatePath -TemplateParameterFile $parameterFilePath 
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date



