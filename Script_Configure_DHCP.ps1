# Installer le service DHCP :
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Créer un security group :
netsh dhcp add securitygroups 
Restart-Service dhcpserver 

# Vérification de l'existence du serveur DHCP dans le DC : 
Get-DhcpServerInDC

$Scopes = @{
       'Prod' = @{
           Mask = "255.255.255.0"
           Network = "10.20.30.0"
           StartRange = "10.20.30.94"
           EndRange = "10.20.30.254"
           Gateway = "10.20.30.255"
    }
    AdresseDNS = "192.168.17.145"
    NameDomain = "virtu-09.tpv.cpe.localdomain"
}


foreach ($item in $Scopes.sites.Keys) {
    Add-DHCPServerv4Scope -Name $Scopes.sites.$item -StartRange $Scopes.sites.$item.StartRange -EndRange $Scopes.sites.$item.EndRange -SubnetMask $Scopes.sites.$item.Mask -State Active
    Set-DHCPServerv4OptionValue -ScopeID $Scopes.sites.$item.Network  -DnsDomain $Scopes.NameDomain -DnsServer $Scopes.AdresseDNS -Router $Scopes.sites.$item.Gateway
    Add-DhcpServerInDC -DnsName $Scopes.NameDomain -IpAddress $Scopes.AdresseDNS
}

Get-DhcpServerv4Scope
Restart-service dhcpserver
