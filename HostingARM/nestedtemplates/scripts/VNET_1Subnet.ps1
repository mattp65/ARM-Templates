cls

$deploymentName = 'DomainARM'

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNET_1Subnet.json'

$resourceGroup = "adTestNet"
$location = 'South Central US'

get-date -Format 'yyyy-MM-dd hh:mm:ss'

New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'

$parameters = @{
    "virtualNetworkName" = "CompA-vnet";
    "addressSpace" = "10.200.0.0/16";
    "subnetName" = "FrontEnd";
    "subnetAddrPrefix" = "10.200.0.0/24";
    "dnsAddress" = "10.200.0.10"
}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date -Format 'yyyy-MM-dd hh:mm:ss'
