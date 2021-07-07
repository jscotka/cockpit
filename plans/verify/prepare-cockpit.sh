#!/bin/sh
# This script is meant to be run on an ephemeral CI host, for packit/Fedora/RHEL gating.
set -eux

# show some system info
nproc
free -h
rpm -q cockpit-system

# HACK: setroubleshoot-server crashes/times out randomly (breaking TestServices),
# and is hard to disable as it does not use systemd
if rpm -q setroubleshoot-server; then
    dnf remove -y setroubleshoot-server
fi

if grep -q 'ID=.*fedora' /etc/os-release; then
    # required by TestLogin.testBasic, but tcsh is not available in CentOS/RHEL
    dnf install -y tcsh
fi

# make libpwquality less aggressive, so that our "foobar" password works
printf 'dictcheck = 0\nminlen = 6\n' >> /etc/security/pwquality.conf

# disable core dumps, we rather investigate them upstream where test VMs are accessible
echo core > /proc/sys/kernel/core_pattern

# make sure that we can access cockpit through the firewall
systemctl start firewalld
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --add-service=cockpit
