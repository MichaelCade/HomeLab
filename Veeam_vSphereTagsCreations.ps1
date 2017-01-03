#Connect to VC which is hosted on MSI (MGMT) and then Nested ESXi Hosts are shut down. 
Connect-VIServer -server 192.168.2.11 -Protocol https -User Administrator@vzilla.co.uk

New-TagCategory -Name "Expiry Date" -Cardinality "Single" -EntityType "VirtualMachine" -Description "Expiry Date for VM"

New-TagCategory -Name "Veeam" -Description "vSphere Tags for Backup and Replication tasks" 

New-Tag -Name "Platinum Backup - 15Mins" -Category "Veeam"
New-Tag –Name “Gold Backup - Hourly” –Category “Veeam”
New-Tag –Name “Silver Backup - Daily” –Category “Veeam”
New-Tag –Name “Bronze Backup - Weekly” –Category “Veeam”
New-Tag –Name “Storage Snapshots Only” –Category “Veeam”

New-Tag –Name “Platinum Replication - 15Mins” –Category “Veeam”
New-Tag –Name “Gold Replication - Hourly” –Category “Veeam”
New-Tag –Name “Silver Replication - Daily” –Category “Veeam”
New-Tag –Name “Bronze Replication - Weekly” –Category “Veeam”
New-Tag –Name “Storage Replication Only” –Category “Veeam”