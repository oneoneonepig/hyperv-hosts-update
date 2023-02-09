# hyperv-hosts-update
Updates the hosts file using PowerShell for Hyper-V VMs

For VMs with DHCP configured, everytime the host machine reboots, the VM Switch will be regenerated and the VMs will retrieve different addresses. After running the script, hosts file will be updated to allow you to use VM Name to access the VMs.

```
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#       127.0.0.1       localhost
#       ::1             localhost
172.25.123.123 ubuntu01 #Hyper-V <------------------
172.25.123.234 ubuntu02 #Hyper-V
```

## Prerequisites
- Hyper-V KVP enabled and running
- Administrative privilege

## Running the Script
1. Start a PowerShell with administrative privilege
2. Set execution policy to `Unrestricted` in the `Process` scope
3. Run the script

## Misc
- Do not run the script multiple times without some delay between
- The script generated hosts entries will end with `#Hyper-V`
- The script will grab the first entry in the `.IPAddresses` property
- Check KVP status by running `(Get-VM).VMIntegrationService` on the host or by running `ps -ef | grep kvp` in the VM
- In `Get-Content | Where | Set-Content`, use parentheses to wrap the `Get-Content` command to prevent writing to a opening file
- Only running VMs' IP address will be updated
