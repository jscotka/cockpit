#!/usr/bin/python

from nrun import *

sys_setup()
spawn_guest("abc","fedora-21")
test_func("abc")

spawn_guest("abd","centos-6")
test_func("abd")
#echo_log("testing")
#test_func(guest)

#echo_success("success", always_show = True)

