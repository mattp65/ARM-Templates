cls
$adminUsername = "parksadmin"

$deploymentName = 'DomainARM'

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\test_file2.json'
$location = 'West US'

$adminPassword = ConvertTo-SecureString "Caviar!60062" -AsPlainText -Force
$adminVaultPwd = Get-AzureKeyVaultSecret -VaultName "parks65keyvault" -Name "AdminPassword"


$testNbr++


$resourceGroup = "adTest$testNbr"

get-date -Format 'yyyy-MM-dd hh:mm:ss'

New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'

$parameters = @{
    "adminUsername" = "$adminUsername";
    "adminPassword" = "$adminPassword";
    "dnsLabelPrefix" =  "parks65vm$testNbr"
}
$parameters2 = @{
    "newStorageAccountName"="$newStorageAccountName";
    "location"="$location";
    "adminUsername" = "$adminUsername";
    "dnsLabelPrefix" =  "parks65vm$testNbr"
}
$parameters
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date -Format 'yyyy-MM-dd hh:mm:ss'
