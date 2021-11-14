# vbox_backups
## Summary  
A very simple bash script to backup local VirtualBox VMs, primarily intended to be placed in a cronjob. This script will collect all VMs that the virtualbox user has access to, then export them to the `export_directory`. Each VM will get a folder in the base directory based on the VMs id, and every export will be named as follows: year-month-day_vm_name.ova. The full path example: `/home/daemonslayer2048/VirtualBox VMs/Backups/5fb8e0b0-6342-4878-a3c6-c7eeed5d2eb4/2021-11-13_Dev_VM.ova`

## Variables
The script contains two basic variables that can be edited.

__ignore_ids:__ This is a list of VMs by idthat the script should ignore when backuping up.
Example:
``` bash
ignore_ids=(
  "bcc069d4-12d5-4641-ad3d-6cfd6f24541c"
  "a67ee283-7cc0-4082-ab97-4756941a2447"
)
```

__retention_time:__ Simply how many days a backup should be kept.  

Example:
``` bash
retention_time="7"
```

__export_directory:__ The base directory to store the backups.
Example:
``` bash
export_directory="/home/$(whoami)/VirtualBox VMs/Backups"
```
