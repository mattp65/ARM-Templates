

function delete-resgrp {
    [cmdletbinding()]
    param($resourceGroup)
    Start-Job –Name "RM$resourceGroup" -ArgumentList $resourceGroup  –Scriptblock {
        param($resourceGroup)
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

        Remove-AzureRmResourceGroup -Name $resourceGroup -Force
    }
}

#for($i=8; $i -le 10; $i++){Remove-AzureRmResourceGroup -Name "adTest$i" -Force}

$rgPrefix = 'adTest'

for($i=6; $i -le 9; $i++){
    $rgName ="$rgPrefix$i"
    #$rgName ="adtestvmben"
    delete-resgrp $rgName 
}


delete-resgrp 'adtestvmabe'
delete-resgrp 'adtestvmafe'
delete-resgrp 'adtestvmacore'
delete-resgrp 'NetworkRGCompA'
delete-resgrp 'NetworkRGCompZ'


#foreach ($job in get-job) {receive-job $job}
#foreach ($job in get-job) {remove-job $job}

$jobs = get-job | Where { $_.State -eq "Running" }
While ($jobs.Count -ne 0) {
    Write-Host "$(get-date -Format 'hh:mm:ss') Waiting for $($jobs.Count) background jobs..."
    Start-Sleep -Seconds 15
    $jobs = get-job | Where { $_.State -eq "Running" }
}
