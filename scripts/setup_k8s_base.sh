#!/bin/bash
#
# Base setup for k8s nodes.
#
set -e

apt update
apt upgrade -y
apt install -y python3-pip
