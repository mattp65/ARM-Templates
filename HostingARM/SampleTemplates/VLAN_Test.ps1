
function create-meprmjob{
    [cmdletbinding()]
    param($deploymentName, $resourceGroup, $location, $templatePath, $parameters)
    Start-Job –Name "$resourceGroup" -ArgumentList $deploymentName, $resourceGroup, $location, $templatePath, $parameters  –Scriptblock {
        param($deploymentName, $resourceGroup, $location, $templatePath, $parameters)
        Write-Output "Remove - $resourceGroup"
        $SubscriptionName = 'aVisual Studio Ultimate with MSDN'
        $TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

        $user = "scripts@parks65.com"
        $pw = ConvertTo-SecureString "Caviar!65" -AsPlainText -Force
        $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

        Write-Output 'Connecting to Azure credential'
        $Account = Add-AzureRmAccount -Credential $Cred
        if(!$Account) {
            # Throw "Could not authenticate using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct."
            Throw "Could not authenticate using entered credentials. Make sure the user name and password are correct."
        }

        Write-Output 'Setting the Subscription'
        $subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription

        get-date -Format 'yyyy-MM-dd hh:mm:ss'

        New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

        get-date -Format 'yyyy-MM-dd hh:mm:ss'

        New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

        get-date -Format 'yyyy-MM-dd hh:mm:ss'
    }
}

$deploymentName = 'NetworkBuild'
$location = 'West US'

$resourceGroup  = 'CompZNetwork'
$templatePath   = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNET_1SubnetNOGW.json'
$templatePath   = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNET_1Subnet.json'
                   
$parameters = @{
    'virtualNetworkName' = 'CompZ-vnet';
    'addressSpace' = '10.1.0.0/16';
    'subnet1Name' = 'Core';
    'subnet1AddrPrefix' = '10.1.0.0/24';
    'dnsAddress' = '10.1.0.10';
    'gwSubnetAddrPrefix' = '10.1.255.0/27'
}
create-meprmjob $deploymentName $resourceGroup $location $templatePath $parameters

$resourceGroup  = 'CompANetwork'
$templatePath   = 'C:\GitHub\ARM-Templates\HostingARM\NestedTemplates\VNET_2SubnetsNOGW.json'
$templatePath   = 'C:\GitHub\ARM-Templates\HostingARM\NestedTemplates\VNET_2Subnets.json'
$parameters = @{
    'virtualNetworkName' = 'CompA-vnet';
    'addressSpace' = '10.10.0.0/16';
    'subnet1Name' = 'FrontEnd';
    'subnet1AddrPrefix' = '10.10.10.0/24';
    'subnet2Name' = 'BackEnd';
    'subnet2AddrPrefix' = '10.10.20.0/24';
    'dnsAddress' = '10.1.0.10';
    'gwSubnetAddrPrefix' = '10.10.255.0/27'
}

create-meprmjob $deploymentName $resourceGroup $location $templatePath $parameters

Get-Job

$jobs = get-job | Where { $_.State -eq "Running" }
While ($jobs.Count -ne 0) {
    Write-Host "$(get-date -Format 'hh:mm:ss') Waiting for $($jobs.Count) background jobs..."
    Start-Sleep -Seconds 15
    $jobs = get-job | Where { $_.State -eq "Running" }
}
foreach ($job in get-job) {receive-job $job}

#foreach ($job in get-job) {receive-job $job}
#foreach ($job in get-job) {remove-job $job}




$resourceGroup  = 'CompANetwork'
$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNETtoVNET.json'
$parameters = @{
    'sharedkey' = 'DXCDynamics2017';
    'rg1Name' = 'CompZNetwork';
    'rg2Name' = 'CompANetwork';
    'location1' = 'West US';
    'location2' = 'West US';
    'gateway1Name' = 'CompZ-vnet-gw';
    'gateway2Name' = 'CompA-vnet-gw';
    'conn1Name' = 'CompZ-vnet-to-CompA-vnet-conn';
    'conn2Name' = 'CompA-vnet-to-CompZ-vnet-conn'
}

create-meprmjob $deploymentName $resourceGroup $location $templatePath $parameters
