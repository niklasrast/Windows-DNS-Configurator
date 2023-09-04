<#
    .SYNOPSIS 
    Add DNS Servers to Windows NIC

    .DESCRIPTION
    Install:   C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\Add-DNSServer.ps1
    
    .ENVIRONMENT
    PowerShell 5.0
    
    .AUTHOR
    Niklas Rast
#>

#Script configuration
$ErrorActionPreference = "SilentlyContinue"
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))
Start-Transcript -path $logFile

#Set wired and wireless nic names
$WiredInterfaceName = "Ethernet"
$WirelessInterfaceName = "WLAN"

#Configure DNS servers
$dnsclient = Get-DnsClient | Get-DnsClientServerAddress | where {$_.InterfaceAlias -match $WiredInterfaceName -or $_.InterfaceAlias -match $WirelessInterfaceName}
foreach($nic in $dnsclient){
    #Add DNS server ips to nic
    Set-DnsClientServerAddress -InterfaceIndex $nic.InterfaceIndex -ServerAddresses ("8.8.8.8","8.8.8.4")
}

Stop-Transcript