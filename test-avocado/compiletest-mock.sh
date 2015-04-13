#!/bin/bash
set +x


yum -y install mock || dnf -y install mock
USER=mocktest
useradd $USER
usermod -a -G mock $USER
cp -rf /root/cockpit /home/$USER
chown -R $USER /home/$USER/cockpit
su $USER -c "cd /home/$USER/cockpit; ./tools/make-srpm"
#&& mock -r fedora-rawhide-x86_64 cockpit-wip-2.*.src.rpm"
yum install /home/$USER/cockpit/*.rpm