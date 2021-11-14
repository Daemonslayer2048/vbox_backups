#!/bin/bash
# Base directory to stroe VMs in
export_directory="/home/$(whoami)/VirtualBox VMs/Backups"
declare -A available_vms
date=$(date +%Y-%m-%d)

# How many days to keep a backup
retention_time="7"

# VirtualBox VM IDs to not archive
ignore_ids=()

function setup_environment () {
  for vm in ${!available_vms[@]}; do
    # Create VMs export directory if it does not exist
    if [ ! -d "$export_directory/$vm" ]; then
      mkdir -p "$export_directory/$vm"
    fi
  done
}

function get_available_vms () {
  while IFS= read -r line; do
    vm_name=$(echo $line | grep -oP '^\"(.+)\"' | sed 's/"//g' | sed 's/ /_/g')
    vm_id=$(echo $line | grep -oP '{(?P<vm_id>.+)}' | sed 's/[{}]//g')
    available_vms["$vm_id"]="$vm_name"
  done <<<$(vboxmanage list vms)
  return $available_vms
}

function export_vms () {
  for vm in ${!available_vms[@]}; do
    if [[ ! "${ignore_ids[*]}" =~ "$vm" ]]; then
      echo "Exporting VM ID: $vm"
      response=$((vboxmanage export "$vm" -o "$export_directory/$vm/$1_${available_vms[${vm}]}.ova" 1> /dev/null) 2>&1)
      if [[ "$response" =~ "VERR_ALREADY_EXISTS" ]]; then
        echo "VM has already been exported today"
      elif [ $? -eq 1 ]; then
        echo "VM failed to export, reason: $response"
      else
        echo "VM successfully exported"
      fi
    else
      echo "Skipping VM ID: $vm"
    fi
    echo ""
  done
}

function prune_vms () {
  for vm in ${!available_vms[@]}; do
    find "$export_directory/$vm/" -type f -mtime +"$retention_time" -name '*.ova' -execdir rm -- '{}' \;
  done
}

get_available_vms
setup_environment
export_vms $date
prune_vms
