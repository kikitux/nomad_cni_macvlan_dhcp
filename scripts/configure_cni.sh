#!/usr/bin/env bash

IFACE="${IFACE:-enp0s8}"
echo ${IFACE}

let i=0
while [ ! -d /proc/sys/net/bridge ]; do
  if [ $i -gt 5 ]; then
    echo INFO: no bridge, skipping
    break
  fi
  echo INFO: waiting for bridge, sleeping 5
  sleep 5
  let i++
done

if [ -d /proc/sys/net/bridge ]; then
  echo INFO: bridge found, configuring sysctl.conf
  cp /vagrant/conf/sysctl.conf /etc/sysctl.conf
  sysctl -p
fi

mkdir -p /etc/cni/net.d/

systemctl stop nomad

systemctl status cni_dhcp &>/dev/null && systemctl stop cni_dhcp
[ /run/cni/dhcp.sock ] && rm -f /run/cni/dhcp.sock

cp /vagrant/conf/cni_config.conflist /etc/cni/net.d/cni_config.conflist
sed -i -e "s/enp0s8/${IFACE}/g" /etc/cni/net.d/cni_config.conflist

cp /vagrant/conf/cni_dhcp.service /etc/systemd/system/cni_dhcp.service
systemctl daemon-reload

cp /vagrant/conf/cni.hcl /etc/nomad.d/cni.hcl 

systemctl enable cni_dhcp
systemctl start cni_dhcp

systemctl start nomad
