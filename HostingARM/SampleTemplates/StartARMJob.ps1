function start-armjob{
    [cmdletbinding()]
    param($resourceGroup, $location, $jobName, $templatePath, $parameters)
    Start-Job –Name "$jobName" -ArgumentList $resourceGroup, $location, $jobName, $templatePath, $parameters  –Scriptblock {
        param($resourceGroup, $location, $jobName, $templatePath, $parameters)
        Write-Output "$jobName - start"
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

        New-AzureRmResourceGroupDeployment -Name $jobName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters 

        get-date -Format 'yyyy-MM-dd hh:mm:ss'
    }
}

function start-armjobparmfile{
    [cmdletbinding()]
    param($resourceGroup, $location, $jobName, $templatePath, $parmfile)
    Start-Job –Name "$jobName" -ArgumentList $resourceGroup, $location, $jobName, $templatePath, $parmfile  –Scriptblock {
        param($resourceGroup, $location, $jobName, $templatePath, $parmfile)
        Write-Output "$jobName - start"
        Write-Output $resourceGroup 
        Write-Output $location 
        Write-Output $jobName 
        Write-Output $templatePath 
        Write-Output $parmfile 

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

        New-AzureRmResourceGroupDeployment -Name $jobName -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterFile $parmfile 

        get-date -Format 'yyyy-MM-dd hh:mm:ss'
        
        Remove-Item -Path $parmfile
    }
}

