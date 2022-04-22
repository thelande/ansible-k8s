#!/bin/bash
#
# Configure the squid proxy VM
#
set -e

apt update
apt install -y squid

cat<<! >/etc/squid/conf.d/disk_cache.conf
maximum_object_size 1024 MB
cache_dir aufs /var/spool/squid 5000 24 256
!

sed -i 's/^#http_access allow localnet/http_access allow localnet/' \
    /etc/squid/conf.d/debian.conf

systemctl restart squid
