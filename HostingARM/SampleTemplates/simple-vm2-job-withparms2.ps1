function create-ARMJOB {
    [cmdletbinding()]
    Param($dnsPrefix, $Suffix, $vlanRGName, $vlanName, $subnetName)

    $resourceGroup ="$rgPrefix$Suffix"
    $scriptBlock = {
        param($resourceGroup, $dnsPrefix, $Suffix, $vlanRGName, $vlanName, $subnetName)

        $SubscriptionName = 'aVisual Studio Ultimate with MSDN'
        $TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

        $user = "scripts@parks65.com"
        $pw = ConvertTo-SecureString "Caviar!65" -AsPlainText -Force
        $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

        $Account = Add-AzureRmAccount -Credential $Cred
        $subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription



        $templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm2.json'
        $parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm2.parameters.json"
        $adminUsername = "parksadmin"
        $deploymentName = 'DomainARM'
        $location = 'East US'

        $tmpFilePath = $parameterFilePath + "$resourceGroup.json"

        # Override the configurable job parms for just thie job
        $jobParms = Get-Content $parameterFilePath | Out-String | ConvertFrom-Json

        $jobParms.parameters.vmName.value = $dnsPrefix + $Suffix
        $jobParms.parameters.dnsName.value = $dnsPrefix + $Suffix
        $jobParms.parameters.vlanRGName.value = $vlanRGName
        $jobParms.parameters.vlanName.value = $vlanName
        $jobParms.parameters.subnetName.value = $subnetName

        ConvertTo-Json -InputObject $jobParms -Depth 30 -Compress | Out-File $tmpFilePath -Encoding utf8




        get-date -Format 'yyyy-MM-dd hh:mm:ss'

        New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

        get-date -Format 'yyyy-MM-dd hh:mm:ss'

        New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterFile $tmpFilePath 

        get-date -Format 'yyyy-MM-dd hh:mm:ss'
        
    }

    Start-Job –Name "C$resourceGroup" –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $dnsPrefix, $Suffix, $vlanRGName, $vlanName, $subnetName
}


$rgPrefix = 'adTestVM'
$dnsPrefix='parks65A'

create-ARMJOB $dnsPrefix 'BEo' 'NetworkRGCompA' 'VNetCompA' 'BackEnd'


