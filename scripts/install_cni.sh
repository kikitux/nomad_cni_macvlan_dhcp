#!/usr/bin/env bash

cni_version="${cni_version:-v1.1.1}"
echo $cni_version

arch=$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)
echo $arch

mkdir -p /opt/cni/bin
[ -f /var/tmp/cni-plugins.tgz ] || curl \
  -L -o /var/tmp/cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/${cni_version}/cni-plugins-linux-${arch}-${cni_version}.tgz"

tar -C /opt/cni/bin -xzf /var/tmp/cni-plugins.tgz
