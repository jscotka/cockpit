#!/bin/bash

BASE_PCKGS="avocado avocado-plugins-output-html"
if rpm -q $BASE_PCKGS >& /dev/null; then
    echolog "All packages alread installed"
else
    if cat /etc/redhat-release | grep "Red Hat"; then
        curl https://copr.fedoraproject.org/coprs/lmr/Autotest/repo/epel-7/lmr-Autotest-epel-7.repo > /etc/yum.repos.d/lmr-Autotest-epel-7.repo
        yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
        yum -y install $BASE_PCKGS
    elif cat /etc/redhat-release | grep "Fedora"; then
        yum -y install yum-plugin-copr
        yum -y copr enable lmr/Autotest
        yum -y install $BASE_PCKGS
    else
        echolog "Now are supported only Fedora and Red Hat installation methods"
        exit 10
    fi
fi

BASE_PCKGS="nodejs npm bind-utils freeipa-client sssd"
if rpm -q $BASE_PCKGS; then
    echo "npm already installed"
else
    yum -y -q install $BASE_PCKGS
    npm -g install phantomjs
fi

