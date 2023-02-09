# check if you have administrator privilege
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$is_admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($is_admin -eq $False) {
    Write-Host "Administrator privilege required."
    Exit
}

# get the hosts file
$hostfile = "$env:windir\system32\drivers\etc\hosts"
# $hostfile = "hosts-test.txt"

# remove the old entries, which starts with "#Hyper-V"
# the parentheses between Get-Content is to prevent writing the same file while reading it
#   reference: https://learn.microsoft.com/en-us/previous-versions//dd347736(v=technet.10)?redirectedfrom=MSDN#example-3
(Get-Content $hostfile) | Where-Object { $_ -notmatch '#Hyper-V' } | Set-Content $hostfile

# sleeping prevents writing to file before the previous operation finish
Start-Sleep 1

# write VM IP addresses to hosts file
$vms = Get-VM | Where-Object { $_.State -eq "Running" }
ForEach ($vm in $vms) {
    if ($vm -ne $vms[-1]) {
        Add-Content -Path $hostfile -Value "$(($vm | Get-VMNetworkAdapter).IPAddresses[0]) $($vm.VMName) #Hyper-V"
    }
    # no newline for the last entry
    else {
        Add-Content -Path $hostfile -Value "$(($vm | Get-VMNetworkAdapter).IPAddresses[0]) $($vm.VMName) #Hyper-V" -NoNewline
    }
}

# verify the results
Get-Content $hostfile
