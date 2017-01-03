#This script is designed to shut down the Virtual Machines, Nested ESXi and Physical Machines 


#All virtual machine IP addresses should be included here. 
#Restart-Computer -Computer localhost -Force -Credential michael.cade@outlook.com


Stop-Computer -Computer 192.168.2.16,192.168.2.17, 192.168.2.18 -Force -Credential Administrator@vzilla.co.uk

#Connect to VC which is hosted on MSI (MGMT) and then Nested ESXi Hosts are shut down. 
Connect-VIServer -server 192.168.2.11 -Protocol https -User Administrator@vsphere.local 
Stop-VMhost 192.168.2.125,192.168.2.126,192.168.2.127,192.168.2.128 -Confirm -Force


#The command below will shut down all physical ESXi hosts
Stop-VMhost 192.168.2.121,192.168.2.122,192.168.2.123 -Confirm -Force

#This command will shut down the Management nested ESXi host on the MSI 
Stop-Computer -Computer 192.168.2.10 -Force -Credential Administrator@vZilla.co.uk
Get-VM 
Stop-VM -VM untangle -Confirm 
Stop-VMhost 192.168.2.124 -Confirm -Force 

Stop-VM NetApp_AltaVault01 -confirm



