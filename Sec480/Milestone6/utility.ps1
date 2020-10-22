$connectVIS = read-host -Prompt "Please provide the vcenter hostname/ipaddress"
Connect-VIServer -Server $connectVIS

function menu {
    Write-Host "Welcome to the Utility Model 1."
    Write-Host "How can I help you?"
    Write-Host " [1] Change VMs Network Adapter"
    Write-Host " [2] Get IP Address of VM"
    Write-Host " [Q] Exit"
    Write-Host ""
    $menusel = Read-Host -Prompt "Select"

    if ( "$menusel" -eq "1") {
        Write-Host "Please Select the Host"
        $lhost = Get-VMHost
        $lhost.name
        $vmhost = read-host -Prompt "Host Name/Ip Address"
        $vmlist = Get-VM
        $vmlist.name
        $vmname = read-host -Prompt "What VM Do You Wish to Confgiure?"
        $vm = Get-VM -Name $vmname
        Write-Host "Loading"
        $interfaces = $vm | Get-NetworkAdapter
        $interfaces
        $internum = read-host -Prompt "What Network?"
        $esx_host = Get-VMHost -Name $vmhost
        $hosts = $esx_host | Get-VirtualSwitch -Name *
        $hosts.name
        $netname = read-host -Prompt "What Interface?"
        $interfaces[$internum] | Set-NetworkAdapter -NetworkName $netname
    }

    elseif ( "$menusel" -eq "2") {
        $lvm = GET-VM
        $lvm.name
        $vmname = read-host -Prompt "What VMdo You Want?"
        $vm = Get-VM -Name $vmname
        Write-Host $vm.Guest.IPAddress[0] hostname=$vmname
    }

    elseif ( "$menusel" -match "^[qQ]$" ) {
        exit
    }

    else {
        menu
    }
}

menu