class HyperV {

    #Variables
    [String[]]$HyperVServer
    [ipaddress[]]$HyperVIPAddress
    [Int]$HyperVServerCount

    #Constructor
    HyperV()
    {
        #Initialize the connection to one or multiple hyperV Servers (local or remote ?)
        #Does Hyper-v feature are enabled ?
        if ((Get-CimInstance -ClassName Win32_OperatingSystem -eq "WS2016") -and (Get-WindowsFeature -name Hyper-V)) {
                "The role Hyper-V is present and you connected to the local Hypervisor"
                "Loading"
        }
        else {
            "The role Hyper-V is not present and you have to connect to the remote Hypervisor with invoke-command"
            $this.InvokeCommand
        }

    }

    #Methods

    #if local
            #import module hyper into powershell session
    #if remote
        #invoke-command -scriptblock {} -credential (domain or workgroup group admins hyperv)
    #How to connect to HyperV (Domain vs Workgroup)
    #test the connection ? ping ? dcom ? wmi ? tcp ?
    #Admin hyperV accounts only ?
    #Differents methods ? Enable-PSRemoting ? Cluster HyperV ?
    #HyperV in workgroup ? Set-Item WSMan:\localhost\Client\TrustedHosts -Value "fqdn-of-hyper-v-host"
    #Enable-WSManCredSSP -Role client -DelegateComputer "fqdn-of-hyper-v-host"
    #method reboot server
    #method new hyperv vm
        #method add processor
        #method add NICs
        #method add HDs
        #method add RAM
    #method new template hyperv vm
        #Template DC (Harden)
        #Template Exchange 2016 (Harden)
        #Template Windows 10 (Harden)
    #method add hyperv vm
    #method remove hyperv vm
        #remove one or many vms
    #method set hyperv vm
        #method set SCSI Controller
        #method set Nics
        #method set HDs
        #method set RAM
        #method set SCSI Controller
    #method reboot hyperv vm

    [void] HyperVServerReboot(){
        $this.HyperVServer.shutdown()
        $this.HyperVServerCount++
    }

    #Manage Switch Manager

    #Manage Virtual San Manager

}
