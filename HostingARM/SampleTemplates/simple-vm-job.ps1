cls

$rgPrefix = 'adTestb'
$dnsPrefix='parks65b'


$testNbr = 0
$testNbr++ 
$resourceGroup = "$rgPrefix$testNbr"


$scriptBlock = {
    param($resourceGroup, $testNbr)
$templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.json'
$parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.parameters.json"
$adminUsername = "parksadmin"
$deploymentName = 'DomainARM'
$location = 'West US'

    $SubscriptionName = 'aVisual Studio Ultimate with MSDN'
    $TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

    $user = "scripts@parks65.com"
    $pw = ConvertTo-SecureString "Caviar!65" -AsPlainText -Force
    $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

    $Account = Add-AzureRmAccount -Credential $Cred
    $subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription

    $adminPassword = ConvertTo-SecureString "Caviar!60062" -AsPlainText -Force
    $parameters = @{
        "newStorageAccountName"="armtestStorageACC";
        "location"="$location";
        "adminUsername" = "$adminUsername";
        "adminPassword" = $adminPassword;
        "dnsLabelPrefix" =  "$dnsPrefix$testNbr"
    }

    $parameters 
    get-date -Format 'yyyy-MM-dd hh:mm:ss'

    New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

    get-date -Format 'yyyy-MM-dd hh:mm:ss'

    New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

    get-date -Format 'yyyy-MM-dd hh:mm:ss'
}
Start-Job –Name $resourceGroup –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $testNbr


$testNbr++
$resourceGroup = "$rgPrefix$testNbr"

$scriptBlock = {
    param($resourceGroup, $testNbr)
$templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.json'
$parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.parameters.json"
$adminUsername = "parksadmin"
$deploymentName = 'DomainARM'
$location = 'West US'
    $SubscriptionName = 'aVisual Studio Ultimate with MSDN'
    $TenantId = '88b84882-dd0c-4637-8524-eaa033ca7305'

    $user = "scripts@parks65.com"
    $pw = ConvertTo-SecureString "Caviar!65" -AsPlainText -Force
    $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

    $Account = Add-AzureRmAccount -Credential $Cred
    $subout = Get-AzureRmSubscription -SubscriptionName $SubscriptionName -TenantId $TenantId  | Select-AzureRmSubscription

    $adminVaultPwd = Get-AzureKeyVaultSecret -VaultName "parks65keyvault" -Name "AdminPassword"
    $parameters = @{
        "newStorageAccountName"="armtestStorageACC";
        "location"="$location";
        "adminUsername" = "$adminUsername";
        "adminPassword" = "$adminVaultPwd";
        "dnsLabelPrefix" =  "$dnsPrefix$testNbr"
    }
    $parameters 

    get-date -Format 'yyyy-MM-dd hh:mm:ss'

    New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Verbose -Force

    get-date -Format 'yyyy-MM-dd hh:mm:ss'

    New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

    get-date -Format 'yyyy-MM-dd hh:mm:ss'
}
Start-Job –Name $resourceGroup –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $testNbr




$testNbr++
$resourceGroup = "$rgPrefix$testNbr"

$scriptBlock = {
    param($resourceGroup, $testNbr)
$templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.json'
$parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm.parameters.json"
$adminUsername = "parksadmin"
$deploymentName = 'DomainARM'
$location = 'West US'
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

    New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterFile $parameterFilePath 

    get-date -Format 'yyyy-MM-dd hh:mm:ss'
}

Start-Job –Name $resourceGroup –Scriptblock $scriptBlock -ArgumentList $resourceGroup, $testNbr


$jobs = get-job

#$jobs | Wait-Job

#foreach ($job in get-job) {receive-job $job}

#$jobs | Remove-Job
