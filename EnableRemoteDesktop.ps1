#Enable Remote Desktop 

Set-ItemProperty -Path 'HKLM:\system\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections"-value 0 
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-itemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'-name "UserAuthentication"-Value 1

