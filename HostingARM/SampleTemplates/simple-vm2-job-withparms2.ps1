
# Load generic Job starter
. C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\StartARMJob.ps1

function tmpcreate-job{
    [cmdletbinding()]
    Param($resourceGroup, $vmName, $dnsName, $vlanRGName, $vlanName, $subnetName)

    write-host "$resourceGroup $vmName $dnsName"

    $templatePath      = 'C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm2NoIP.json'
    $parameterFilePath = "C:\GitHub\ARM-Templates\HostingARM\SampleTemplates\simple-vm2NoIP.parameters.json"
    $location = 'South Central US'

    $tmpFilePath = "$parameterFilePath.$vmName.json"

    # Override the configurable job parms for just thie job
    $jobParms = Get-Content $parameterFilePath | Out-String | ConvertFrom-Json

    $jobParms.parameters.vmName.value = $vmName
#    $jobParms.parameters.dnsName.value = $dnsName
    $jobParms.parameters.vlanRGName.value = $vlanRGName
    $jobParms.parameters.vlanName.value = $vlanName
    $jobParms.parameters.subnetName.value = $subnetName

    ConvertTo-Json -InputObject $jobParms -Depth 30 -Compress | Out-File $tmpFilePath -Encoding utf8

    $jobName = "simple-vm2NoIP-$vmName"
    start-armjobparmfile $resourceGroup $location $jobName $templatePath $tmpFilePath
}

$runId = 'V'

$resourceGroup = "adTestVM$runId"
$dnsPrefix     = "parks65$runId"

tmpcreate-job $resourceGroup "$($dnsPrefix)A" "$($dnsPrefix)A" 'adTestNetA' 'CompA-vnet' 'FrontEnd'
tmpcreate-job $resourceGroup "$($dnsPrefix)B" "$($dnsPrefix)B" 'adTestNetA' 'CompA-vnet' 'FrontEnd'




#get-job | Remove-Job
#get-job | Remove-Job

$jobs = get-job | Where { $_.State -eq "Running" }
While ($jobs.Count -ne 0) {
    Write-Host "$(get-date -Format 'hh:mm:ss') Waiting for $($jobs.Count) background jobs..."
    Start-Sleep -Seconds 10
    $jobs = get-job | Where { $_.State -eq "Running" }
}

foreach ($job in get-job) {
    write-host $job.Name 
    receive-job $job
    remove-job $job
    write-host $job.Name 
}

