#allowing remote access to machine
Set-Item wsman:\localhost\Client\TrustedHosts -value *

Set-Item wsman:\localhost\Client\TrustedHosts 192.168.2.10 -Concatenate -Force
Set-Item wsman:\localhost\Client\TrustedHosts DC01 -Concatenate -Force
Set-Item wsman:\localhost\Client\TrustedHosts DC01.vzilla.co.uk -Concatenate -Force