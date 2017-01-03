<#
    STOP-HOMELAB Function
    http://myrandomthoughts.co.uk/2015/01/shutdown-your-homelab-with-powercli

    -------------------------------------------------------------------------------------------------

    This script will shutdown your homelab in case of an emergency.
	Make sure you fill in the all the details at the top, and test before putting into production.!

    -------------------------------------------------------------------------------------------------

    See the above blog post for detailed instructions
#>

function Stop-HomeLab
{
    [string]$vCenter_Server                    = "192.168.2.11"
    [string]$vCenter_Server_UserName           = "Administrator@vSphere.local"
    [string]$vCenter_Server_Password           = ""

    [string]$Known_ESX_Host                    = "192.168.2.121"
    [string]$Known_ESX_Host_UserName           = "root"
    [string]$Known_ESX_Host_Password           = "Passw0rd"

    [string]$Critical_Folder                   = ""
    [string[]]$Critical_Servers_Shutdown_Order = ("", "", "", "")

    [int]$Shutdown_TimeOut                     = 180 # Seconds
   

# DO NOT CHANGE ANYTHING BELOW THIS LINE
# -------------------------------------------------------------------------------------------------

  # Let's Start...
    Write-Host "Starting HomeLab Shutdown" -ForegroundColor Green
    Write-Host " "



  # Connect to the vCenter server...
    Write-Host "   Connecting To Virtual Center Server: " -NoNewline
    $x = Connect-VIServer -Server $vCenter_Server -User $vCenter_Server_UserName -Password $vCenter_Server_Password -Force -WarningAction SilentlyContinue
    Write-Host "Done"



  # Configure DRS to manual on all clusters (do not disable or remove DRS)
    Write-Host "   Configuring DRS Settings: " -NoNewline
    $x = Get-Cluster | Set-Cluster -DrsAutomationLevel Manual -Confirm: $false
    Write-Host "Done"



  # Shutdown all non-critical VMs...
    Write-Host "   Shutting Down Non-Critical VMs: "
    $x = Get-VM | Where {$_.Folder -notlike $Critical_Folder -and $_.PowerState -eq "PoweredOn"} | Shutdown-VMGuest -Confirm: $false



  # Wait for timeout to complete, then kill...
    $CurrentTime = (Get-Date).TimeofDay
    Write-Host "      VMs Remaining: " -NoNewline
    Do 
    {
	    Sleep -s 5.0
	    $RemainingVMs = (Get-VM | Where {$_.Folder -notlike $Critical_Folder -and $_.PowerState -eq "PoweredOn"}).Count
	    $NewTime = (Get-Date).TimeofDay - $CurrentTime
	    Write-Host "$RemainingVMs, " -NoNewline
    }
    Until (($RemainingVMs -eq 0) -or (($NewTime).Seconds -ge $Shutdown_TimeOut))
    Write-Host "   Done"



  # Force Kill any remaining...
    $x = Get-VM | Where {$_.Folder -notlike $Critical_Folder -and $_.PowerState -eq "PoweredOn"} | Stop-VM -Kill -Confirm: $false

    

  # Move all VMs off all hosts, onto known host
    Write-Host "   Migrating remaining VMs (may take a while): " -NoNewline
    $x = Get-VM | Where {$_.VMHost.Name -ne $Known_ESX_Host} | Move-VM -Destination (vmhost -Name $Known_ESX_Host) -Confirm: $false
    Write-Host "Done"



  # Put hosts into maintenance mode..
    Write-Host "   Entering Maintenance Mode: " -NoNewline
    $x = Get-VMHost | Where {$_.Name -ne $Known_ESX_Host} | Set-VMHost -State Maintenance -Confirm: $false
    Write-Host "Done"



  # Shutdown hosts ESX1 and ESX2...
    Write-Host "   Shutting Down Hosts: " -NoNewline
    $x = Get-VMHost | Where {$_.Name -ne $Known_ESX_Host} | Stop-VMHost -Force -Confirm: $false
    Write-Host "Done"



  # Connect to the known host...
    $x = Disconnect-VIServer -Server $vCenter_Server -Confirm:$false
    $x = Connect-VIServer -Server $Known_ESX_Host -User $Known_ESX_Host_UserName -Password $Known_ESX_Host_Password -Force -WarningAction SilentlyContinue


    
  # Shutdown Critical Servers...
    Write-host "   Shutting Down Critical VMs:"
    ForEach ($vm in $Critical_Servers_Shutdown_Order)
    {
        $currVM = get-vm -Name $vm
        $CurrentTime = (Get-Date).TimeofDay
        Write-host "      $vm : " -NoNewline
        Shutdown-VMGuest -VM $currVM -Confirm: $false
        Do 
        {
	        Sleep -s 5.0
	        $NewTime = (Get-Date).TimeofDay - $CurrentTime
            Write-host "." -NoNewline
        }
        Until (($currVM.PowerState -ne "PoweredOn") -or (($NewTime).Seconds -ge $Shutdown_TimeOut))
        $x = Stop-VM -VM $currVM -Kill -Confirm: $false
        Write-Host "Done"
    }



  # Enter maintenance mode and power off ESX3
    Write-Host "   Shutting Down Known Host: " -NoNewline
    $x = Set-VMHost  -VMHost $Known_ESX_Host -State Maintenance -Confirm: $false
    $x = Stop-VMHost -VMHost $Known_ESX_Host -Force             -Confirm: $False
    Write-Host "   Done"



  # SCRIPT END
    Write-Host " "
    Write-Host "Script Complete - Homelab shutdown" -ForegroundColor Green
}

Add-PSSnapIn -Name "VMware.VimAutomation.Core"
Stop-HomeLab
