
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



$LocName = "South Central US"

$deploymentName = "ArmTest"

$templatePath = "C:\GitHub\ARM-Templates\101-vm-simple-windows\azuredeploy.json"


$newStorageAccountName = "armtestStorageACC"
$adminUsername = "�parks65"
$adminPassword = ConvertTo-SecureString "Caviar!60062" -AsPlainText -Force

get-date
 
if (1 -eq 2){
#In the command pane, type and run the following commands: 
$TestNbr=1
$rgName = “MyDeploymentRG$TestNbr”
$dnsLabelPrefix=”armtest$TestNbr"

New-AzureRmResourceGroup -Name $rgName -Location $LocName 

# Create a deployment using inline parameters
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templatePath -newStorageAccountName $newStorageAccountName -location $LocName -adminUsername $adminUsername  -adminPassword $adminPassword  -dnsLabelPrefix $dnsLabelPrefix
}

get-date

if (1 -eq 2){
$TestNbr=2
$rgName = “MyDeploymentRG$TestNbr”
$dnsLabelPrefix=”armtest$TestNbr"
New-AzureRmResourceGroup -Name $rgName -Location $LocName 

# Create a deployment using a parameter object
$parameters = @{"newStorageAccountName"="$newStorageAccountName";"location"="$LocName”;”adminUsername”=”$adminUsername”;”adminPassword”=”$adminPassword”;”dnsLabelPrefix”=”$dnsLabelPrefix"}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templatePath -TemplateParameterObject $parameters 
}
get-date



if (1 -eq 2){
$TestNbr=3
$rgName = “MyDeploymentRG$TestNbr”
$dnsLabelPrefix=”armtest$TestNbr"
New-AzureRmResourceGroup -Name $rgName -Location $LocName 

# Create a deployment using a parameter file
$parameterFilePath = “C:\GitHub\ARM-Templates\101-vm-simple-windows\azuredeploy.parameters3.json"
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templatePath -TemplateParameterFile $parameterFilePath 
}
get-date

if (1 -eq 2){
$TestNbr=4
$rgName = “MyDeploymentRG$TestNbr”
$dnsLabelPrefix=”armtest$TestNbr"
New-AzureRmResourceGroup -Name $rgName -Location $LocName 

# Create a deployment using an online template
$templateURI = “https://raw.githubusercontent.com/mattp65/ARM-Templates/master/101-vm-simple-windows/azuredeploy.json”
$parameterFilePath = “C:\GitHub\ARM-Templates\101-vm-simple-windows\azuredeploy.parameters4.json"
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateUri $templateURI -TemplateParameterFile $parameterFilePath 
}
get-date

if (1 -eq 1){
$TestNbr=5
$rgName = “MyDeploymentRG$TestNbr”
$dnsLabelPrefix=”armtest$TestNbr"
New-AzureRmResourceGroup -Name $rgName -Location $LocName 

# Create a deployment using an online template
$templateURI = “https://raw.githubusercontent.com/mattp65/ARM-Templates/master/101-vm-simple-windows/azuredeploy.json”
$parameters = @{"newStorageAccountName"="$newStorageAccountName";"location"="$LocName”;”adminUsername”=”$adminUsername”;”adminPassword”=”$adminPassword”;”dnsLabelPrefix”=”$dnsLabelPrefix"}
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateUri $templateURI -TemplateParameterObject $parameters  
}
get-date



