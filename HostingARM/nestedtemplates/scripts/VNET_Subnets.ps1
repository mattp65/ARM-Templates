function start-armjob{
    [cmdletbinding()]
    param($resourceGroup, $jobName, $templatePath, $parameters)
    Start-Job –Name "$jobName" -ArgumentList $resourceGroup, $templatePath, $parameters  –Scriptblock {
        param($resourceGroup, $templatePath, $parameters)
        Write-Output "$resourceGroup"
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
        
        $deploymentName = 'DomainARM'

        New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 
    }
}

$resourceGroup = "adTestNetZ"
$location = 'South Central US'

get-date -Format 'yyyy-MM-dd hh:mm:ss'

New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'


$jobName      = 'VNetCoreZ' 
$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNET_1SubnetGW.json'
$parameters = @{
    "virtualNetworkName" = "CompZ-vnet";
    "addressSpace" = "10.200.0.0/16";
    "subnetName" = "FrontEnd";
    "subnetAddrPrefix" = "10.200.0.0/24";
    "gwSubnetAddrPrefix" = "10.200.255.0/27";
    "dnsAddress" = "10.200.0.10"
}
start-armjob $resourceGroup $jobName $templatePath $parameters

$resourceGroup = "adTestNetA"
$location = 'South Central US'

get-date -Format 'yyyy-MM-dd hh:mm:ss'

New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

get-date -Format 'yyyy-MM-dd hh:mm:ss'
$jobName      = 'VNetCoreA' 
$templatePath = 'C:\GitHub\ARM-Templates\HostingARM\nestedtemplates\VNET_2SubnetsGW.json'
$parameters = @{
    "virtualNetworkName" = "CompA-vnet";
    "addressSpace" = "10.210.0.0/16";
    "subnet1Name" = "FrontEnd";
    "subnet1AddrPrefix" = "10.210.10.0/24";
    "subnet2Name" = "BackEnd";
    "subnet2AddrPrefix" = "10.210.20.0/24";
    "gwSubnetAddrPrefix" = "10.210.255.0/27";
    "dnsAddress" = "10.200.0.10"
}
start-armjob $resourceGroup $jobName $templatePath $parameters

$jobs = get-job | Where { $_.State -eq "Running" }
While ($jobs.Count -ne 0) {
    Write-Host "$(get-date -Format 'hh:mm:ss') Waiting for $($jobs.Count) background jobs..."
    Start-Sleep -Seconds 30
    $jobs = get-job | Where { $_.State -eq "Running" }
}

foreach ($job in get-job) {
    write-host $job.Name 
    receive-job $job
    write-host $job.Name 
}

#foreach ($job in get-job) {remove-job $job}
