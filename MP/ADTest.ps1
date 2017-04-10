cls
$adminUsername = "parksadmin"
$adminPassword = ConvertTo-SecureString "Caviar!60062" -AsPlainText -Force

$deploymentName = 'DomainARM'

$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\ad-new-domain.json'

$testNbr++

$location = 'West US'
$resourceGroup = "adTest$testNbr"

get-date -Format 'yyyy-MM-dd hh:mm:ss'

New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'

$parameters = @{
    "adminUsername" = "$adminUsername";
    "adminPassword" = "$adminPassword";
    "domainName" = "parks.local";
    "dnsPrefix" =  "parks65ad$testNbr";
    "windowsserver" = "2012-R2-Datacenter"
}


New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

get-date -Format 'yyyy-MM-dd hh:mm:ss'
