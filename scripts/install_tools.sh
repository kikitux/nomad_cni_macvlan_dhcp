#!/usr/bin/env bash

until ping -c1 archive.ubuntu.com &>/dev/null; do
  echo "waiting for networking to initialise"
  sleep 3
done

apt-get update
apt-get install -y jq htop atop sysstat mc nmap net-tools
