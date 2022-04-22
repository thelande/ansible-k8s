#!/bin/bash
#
# Configure the system to use the squid caching VM.
#
# Expects the Squid VM IP address/hostname as the only argument.
#
set -e

echo "Args: $*"
echo "Configuring proxy to $1"

echo "Writing proxy.sh"
cat<<! >/etc/profile.d/proxy.sh
export HTTP_PROXY="http://$1:3128"
export HTTPS_PROXY="http://$1:3128"
export FTP_PROXY="http://$1:3128"
export NO_PROXY="localhost,127.0.0.1,::1"
!

echo "Configuring apt"
cat<<! >/etc/apt/apt.conf.d/30proxy
Acquire::http::Proxy "http://$1:3128";
Acquire::https::Proxy "http://$1:3128";
!
