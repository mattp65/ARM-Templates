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

$templatePath = 'C:\GitHub\ARM-Templates\MP\VNET_2Subnets.json'

$location = 'East US'
$resourceGroup = 'NetworkRGCompA'

get-date -Format 'yyyy-MM-dd hh:mm:ss'

cls
New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'

$parameters = @{
    'virtualNetworkName' = 'VNetCompA';
    'addressSpace' = '10.10.0.0/16';
    'secGroup1Name' = 'SecGroupCompAFE';
    'secGroup2Name' = 'SecGroupCompABE';
    'subnet1Name' = 'FrontEnd';
    'subnet1AddrPrefix' = '10.10.10.0/24';
    'subnet2Name' = 'BackEnd';
    'subnet2AddrPrefix' = '10.10.20.0/24';
    'dnsAddress' = '10.1.0.10';
    'gwSubnetAddrPrefix' = '10.10.255.0/27';
    'gatewayName' = 'VNetCompAGW';
    'gatewayPublicIPName' = 'VNetCompAGWIP';
    'gatewayIPConf' = 'VNetCompAGWIPConf'
}

New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date -Format 'yyyy-MM-dd hh:mm:ss'
