

function create-DCJOB {
    [cmdletbinding()]
    Param($resourceGroup, $dnsName)

    $scriptBlock = {
        param($resourceGroup, $dnsName)
        
        Write-Output "Create - $resourceGroup"

        $templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\ad-ha-2dc.json'
        $parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\ad-ha-2dc.parameters.json"
        $deploymentName = 'DomainARM'
        $location = 'South Central US'

        $tmpFilePath = $parameterFilePath + "$resourceGroup.json"

        # Override the configurable job parms for just thie job
        $jobParms = Get-Content $parameterFilePath | Out-String | ConvertFrom-Json

        $jobParms.parameters.dnsPrefix.value = $dnsName
        $jobParms.parameters.newStorageAccountName.value = $dnsName + 'dcstgrp'

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

    Start-Job –Name "C$resourceGroup" –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $dnsName
}


$Suffix  ="r"
$dnsName ='parks65dc' + $Suffix

$resourceGroup = 'dcTest' + $Suffix
create-DCJOB $resourceGroup $dnsName

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
