
$resourceGroup = 'adTestNetA'
$vnetName = 'CompA-vnet'
$subnetName = 'FrontEnd'
$baseName = 'Parks65NICa'

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup
$subNet = $vnet.Subnets | where-object Name -eq $subnetName

$subNet.Id



$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\NIC_DynamicNoPip.json'
$parameters = @{
    "vmName" = "$($baseName)D";
    "dnsName" = "$($baseName)D";
    "subnetID" = $subNet.Id;
    "ipAddress" = "10.210.10.50"
}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\NIC_DynamicPip.json'
$parameters = @{
    "vmName" = "$($baseName)DP";
    "dnsName" = "$($baseName)DP";
    "subnetID" = $subNet.Id;
    "ipAddress" = "10.210.10.51"
}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\NIC_StaticNoPip.json'
$parameters = @{
    "vmName" = "$($baseName)S";
    "dnsName" = "$($baseName)S";
    "subnetID" = $subNet.Id;
    "ipAddress" = "10.210.10.60"
}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\NIC_StaticPip.json'
$parameters = @{
    "vmName" = "$($baseName)SP";
    "dnsName" = "$($baseName)SP";
    "subnetID" = $subNet.Id;
    "ipAddress" = "10.210.10.61"
}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

