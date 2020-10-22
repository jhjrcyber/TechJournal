$configuration_path = "cloner.json"

$mode = read-host -Prompt "Used Save Configs? [Y/n]"

if ( "$mode" -match "^[nN]$" ) {
    Write-Host "Entering Interactive Mode"
    $connectVIS = read-host -Prompt "Please provide the vcenter hostname/ipaddress"
    Connect-VIServer -Server $connectVIS
    Write-Host "--- Connected ---"
    ### VMHost
    Write-Host "Please Select the Host"
    $lhost = Get-VMHost
    $lhost.name
    $vmhost = read-host -Prompt "Host Name/Ip Address"

    ### VM Folders
    Write-Host "Please Select the folder from the list below"
    $lfolder = Get-Folder -Type VM
    $lfolder.name
    $folder = read-host -Prompt "Folder Name"

    ### BaseVM
    Write-Host - "Here are the VMs in this folder"
    $lvm = Get-VM -Location $folder
    $lvm.name
    $basevm = read-host -Prompt "Which VM would you liked cloned?"

    ### Snapshot
    Write-Host - "Here are the SnapShots Available"
    $lsnap = Get-Snapshot -VM $basevm
    $lsnap.name
    $snapshot = read-host -Prompt "What Snapshot would you like"

    ### Database
    Write-Host "Please Select the Databse from the list below"
    $ldatas = Get-DataStore
    $ldatas.name
    $dstore = read-host -Prompt "Database"

    ### Clone
    $clonetype = read-host -Prompt "Would you like [1].Full Clone, [2]. Linked Clone"

    if ( "$clonetype" -eq "1" ) {
        $newvm = New-VM -Name "$basevm-linked" -Vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore -Location $folder
        $newvm = New-VM -Name "$basevm-base" -Vm $basevm-linked -VMHost $vmhost -Datastore $dstore -Location $folder
        $cleanup = read-host -Prompt "Now that we are done with $basevm-linked would you like to delete it? [Y/n]"
        if ( "$cleanup" -match "^[nN]$" ) {
            Write-Host "Did Not Delete"
            exit
        }

        else {
            Remove-VM -VM "$basevm-linked"
        }
    }

    elseif ( "$clonetype" -eq "2" ) {
        $newvm = New-VM -Name "$basevm-linked" -Vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore -Location $folder
    }

    else {
        exit
    }
}

else {
    Write-Host "Using Saved Data"
    Get-Content -Raw -Path $configuration_path | ConvertFrom-Json
    $connectVIS = read-host -Prompt "Please provide the vcenter hostname/ipaddress"
    Connect-VIServer -Server $connectVIS
    
    ### BaseVM
    Write-Host - "Here are the VMs in this folder"
    $lvm = Get-VM -Location $folder
    $lvm.name
    $basevm = read-host -Prompt "Which VM would you liked cloned?"

    ### Snapshot
    Write-Host - "Here are the SnapShots Available"
    $lsnap = Get-Snapshot -VM $basevm
    $lsnap.name
    $snapshot = read-host -Prompt "What Snapshot would you like"

    ### Clone
    $clonetype = read-host -Prompt "Would you like [1].Full Clone, [2]. Linked Clone"

    if ( "$clonetype" -eq "1" ) {
        $newvm = New-VM -Name "$basevm-linked" -Vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore -Location $folder
        $newvm = New-VM -Name "$basevm-base" -Vm $basevm-linked -VMHost $vmhost -Datastore $dstore -Location $folder
        $cleanup = read-host -Prompt "Now that we are done with $basevm-linked would you like to delete it? [Y/n]"
        if ( "$cleanup" -match "^[nN]$" ) {
            Write-Host "Did Not Delete"
            exit
        }

        else {
            Remove-VM -VM "$basevm-linked"
        }
    }

    elseif ( "$clonetype" -eq "2" ) {
        $newvm = New-VM -Name "$basevm-linked" -Vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore -Location $folder
    }

    else {
        exit
    }
}