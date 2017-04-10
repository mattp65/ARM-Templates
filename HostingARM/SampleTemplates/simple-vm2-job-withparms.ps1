

function create-ARMJOB {
    [cmdletbinding()]
    Param($resourceGroup, $vmname, $dnsName, $vlanRGName, $vlanName, $subnetName)

    $scriptBlock = {
        param($resourceGroup, $vmname, $dnsName, $vlanRGName, $vlanName, $subnetName)
        
        Write-Output "Create - $resourceGroup"

        $templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm2.json'
        $parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm2.parameters.json"
        $adminUsername = "parksadmin"
        $deploymentName = 'DomainARM'
        $location = 'West US'

        $tmpFilePath = $parameterFilePath + "$resourceGroup.json"

        # Override the configurable job parms for just thie job
        $jobParms = Get-Content $parameterFilePath | Out-String | ConvertFrom-Json

        $jobParms.parameters.vmName.value = $vmname
        $jobParms.parameters.dnsName.value = $dnsName
        $jobParms.parameters.vlanRGName.value = $vlanRGName
        $jobParms.parameters.vlanName.value = $vlanName
        $jobParms.parameters.subnetName.value = $subnetName

        ConvertTo-Json -InputObject $jobParms -Depth 30 -Compress | Out-File $tmpFilePath -Encoding utf8

        $SubscriptionName = 'aVisual Studio Ultimate with MSDN'
        $TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

        $user = "scripts@parks65.com"
        $pw = ConvertTo-SecureString "Caviar!65" -AsPlainText -Force
        $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

        $Account = Add-AzureRmAccount -Credential $Cred
        $subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription

        get-date -Format 'yyyy-MM-dd hh:mm:ss'

        New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

        get-date -Format 'yyyy-MM-dd hh:mm:ss'

        New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterFile $tmpFilePath 

        get-date -Format 'yyyy-MM-dd hh:mm:ss'
        
        #Remove-Item -Path $tmpFilePath
    }

    Start-Job –Name "C$resourceGroup" –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $vmname, $dnsName, $vlanRGName, $vlanName, $subnetName
}


$rgPrefix = 'adTestVMA'
$dnsPrefix='parks65A'


$comp = 'A'
$role = 'FE'
$resourceGroup ="$rgPrefix$Role"
$subnet = 'FrontEnd'
create-ARMJOB $resourceGroup "UWP$($role)01" "parks65uwp$($role)01" "Comp$($comp)Network" "Comp$($comp)-vnet" $subnet 
#create-ARMJOB $resourceGroup "UWP$($role)02" "parks65uwp$($role)02" "Comp$($comp)Network" "Comp$($comp)-vnet" $subnet 
$comp = 'A'
$role = 'BE'
$resourceGroup ="$rgPrefix$Role"
$subnet = 'BackEnd'
create-ARMJOB $resourceGroup "UWP$($role)01" "parks65uwp$($role)01" "Comp$($comp)Network" "Comp$($comp)-vnet" $subnet 
#create-ARMJOB $resourceGroup "UWP$($role)02" "parks65uwp$($role)02" "Comp$($comp)Network" "Comp$($comp)-vnet" $subnet 
$comp = 'Z'
$role = 'CORE'
$resourceGroup ="$rgPrefix$Role"
$subnet = 'Core'
create-ARMJOB $resourceGroup "UWP$($role)01" "parks65uwp$($role)01" "Comp$($comp)Network" "Comp$($comp)-vnet" $subnet 
#create-ARMJOB $resourceGroup "UWP$($role)02" "parks65uwp$($role)02" "Comp$($comp)Network" "Comp$($comp)-vnet" $subnet 

$jobs = get-job

#$jobs | Wait-Job

#foreach ($job in get-job) {receive-job $job}

#get-job | Remove-Job
#get-job | Remove-Job

$jobs = get-job | Where { $_.State -eq "Running" }
While ($jobs.Count -ne 0) {
    Write-Host "$(get-date -Format 'hh:mm:ss') Waiting for $($jobs.Count) background jobs..."
    Start-Sleep -Seconds 30
    $jobs = get-job | Where { $_.State -eq "Running" }
}

foreach ($job in get-job) {receive-job $job}
