#!/bin/bash
#
# Setup the server as a simple NFS server.
#
set -e

DATA_DIR="/k8s_data"

apt update
apt install -y nfs-kernel-server

# Create directory for kubernetes
mkdir -p "$DATA_DIR"

EXPORT_SUBNET="$1.0/24"
echo "Exporting NFS to $EXPORT_SUBNET"

# Export it
if ! grep -q -E "^$DATA_DIR" /etc/exports; then
    echo "$DATA_DIR  $EXPORT_SUBNET(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
    exportfs -ra
fi

showmount -e localhost
