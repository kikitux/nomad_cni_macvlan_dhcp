#!/usr/bin/env bash

systemctl stop dnsmasq 
cp /vagrant/conf/dnsmasq.conf /etc/dnsmasq.conf
systemctl start dnsmasq 
netstat -anp | grep -i dnsmasq

