#!/usr/bin/python

from nrun import *

sys_setup()
spawn_guest("abc","fedora-21")

echo_log("testing")

test_func("abc")
guest_flavor("abc","lib/guest-basic-redhat.sh",)
upload("abc","../tools/cockpit.spec","/var/tmp/cockpit.spec")
guest_flavor("abc","lib/guest-cockpit-redhat.sh", "/var/tmp/cockpit.spec")
avocado_run("abc",'checklogin-basic.py')



