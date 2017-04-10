
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
