$IPAddress = "192.168.17.145"
$Prefix = "29"
$Gateway = "192.168.17.1"
$IPAddressDNS = "127.0.0.1"

New-NetIPAddress -IPAddress $IPAddress -PrefixLength $Prefix -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ($IPAddressDNS)