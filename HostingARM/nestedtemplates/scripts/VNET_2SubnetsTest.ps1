
$deploymentName = 'NetworkARM'

$location = 'East US'
$resourceGroup = 'NetworkRGCompA'

get-date -Format 'yyyy-MM-dd hh:mm:ss'

New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNET_2Subnets.json'
$parameters = @{
    "virtualNetworkName" = "CompA-vnet";
    "addressSpace" = "10.200.0.0/16";
    "subnet1Name" = "FrontEnd";
    "subnet1AddrPrefix" = "10.200.0.0/24";
    "subnet2Name" = "BackEnd";
    "subnet2AddrPrefix" = "10.200.10.0/24";
    "dnsAddress" = "10.200.0.10"
}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date -Format 'yyyy-MM-dd hh:mm:ss'
