$SubscriptionName = 'aVisual Studio Ultimate with MSDN'
$TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

$user = 'scripts@parks65.com'
$pw = ConvertTo-SecureString 'Caviar!65' -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

Write-Output 'Connecting to Azure credential'
$Account = Add-AzureRmAccount -Credential $Cred
if (!$Account) {
    # Throw 'Could not authenticate using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct.'
    Throw 'Could not authenticate using entered credentials. Make sure the user name and password are correct.'
}

Write-Output 'Setting the Subscription'
$subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription

$adminUsername =  'parks65'
$adminPassword = ConvertTo-SecureString 'Caviar!60062' -AsPlainText -Force

$deploymentName = 'NetworkARM'

$templatePath = 'C:\GitHub\ARM-Templates\MP\VNET_1Subnet.json'

$location = 'East US'
$resourceGroup = 'NetworkRGCompZ'

get-date -Format 'yyyy-MM-dd hh:mm:ss'

cls
New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'

$parameters = @{
    'virtualNetworkName' = 'VNetCompZ';
    'addressSpace' = '10.1.0.0/16';
    'secGroup1Name' = 'SecGroupCompZFE';
    'subnet1Name' = 'Core';
    'subnet1AddrPrefix' = '10.1.0.0/24';
    'dnsAddress' = '10.1.0.10';
    'gwSubnetAddrPrefix' = '10.1.255.0/27';
    'gatewayName' = 'VNetCompZGW';
    'gatewayPublicIPName' = 'VNetCompZGWIP';
    'gatewayIPConf' = 'VNetCompZGWIPConf'
}

New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date -Format 'yyyy-MM-dd hh:mm:ss'



