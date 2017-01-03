#This report will allow for specific virtual machines to be started, this script will contain all scripts not all should be run at the same time. 

#Connect to VC which is hosted on MSI (MGMT) and then Nested ESXi Hosts are shut down. 
Connect-VIServer -server 192.168.2.11 -Protocol https -User Administrator@vzilla.co.uk
Get-VM

#Start NetApp AltaVault Appliance 
Start-VM NetApp_AltaVault01 -confirm

#Can we be used to pause commands 
Start-Sleep -Seconds    60
Get-VM


#Start Veeam servers
Start-VM Veeam_BR01,Veeam_ONE -confirm 

#Start Nested ESXi hosts - takes 5 minutes for this to complete.
Start-VM ESX01,ESX02,ESX03,ESX04 -Confirm

#Start Exchange VM
Start-VM Exch01 -confirm

#Start SQL VM 
Start-VM SQL01 -confirm

#Start Oracle VM
Start-VM Ora01 -confirm

#Start Sharepoint VM
Start-VM SP01 -confirm 