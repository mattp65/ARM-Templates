
#$jobs | Remove-Job


$rgPrefix = 'adTestj'
$dnsPrefix='parks65j'

for($testNbr=2; $testNbr -le 2; $testNbr++){

    $resourceGroup ="$rgPrefix$testNbr"
    $scriptBlock = {
        param($resourceGroup, $dnsPrefix, $testNbr)
        
        Write-Output "Create - $resourceGroup"

        $templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.json'
        $parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.parameters.json"
        $adminUsername = "parksadmin"
        $deploymentName = 'DomainARM'
        $location = 'West US'



        $tmpFilePath = $parameterFilePath + "$resourceGroup.json"

        # Override the configurable job parms for just thie job
        $jobParms = Get-Content $parameterFilePath | Out-String | ConvertFrom-Json
        $jobParms.parameters.dnsLabelPrefix.value = $dnsPrefix + $testNbr
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
        
        Remove-Item -Path $tmpFilePath
    }

    Start-Job –Name "C$resourceGroup" –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $dnsPrefix, $testNbr

}



$jobs = get-job

#$jobs | Wait-Job

#foreach ($job in get-job) {receive-job $job}

#$jobs | Remove-Job
#get-job | Remove-Job
