#!/usr/bin/python

# we need to be able to find and import seleniumlib, so add this directory
import os
import sys
import time
machine_test_dir = os.path.dirname(os.path.abspath(__file__))
if not machine_test_dir in sys.path:
    sys.path.insert(1, machine_test_dir)

from avocado import main
from avocado.utils import process
import libdisc
from seleniumlib import *
from testvm import Timeout

class SosReportingTab(SeleniumTest):
    """
    :avocado: enable
    """
    def test10SosReport(self):
        self.login()
        self.wait_id("sidebar")
        self.wait_id("tools-panel",cond=invisible)
        self.click(self.wait_link('Tools', cond=clickable))
        self.wait_id("tools-panel")
        self.click(self.wait_link('Diagnostic report', cond=clickable))
        self.wait_frame("sosreport")
        self.wait_text("This tool will collect system configuration and diagnostic")
        self.click(self.wait_xpath('//button[@data-target="#sos"]', cond=clickable))
        self.wait_id("sos")
        self.wait_text("Generating report")
        process.run("pgrep sosreport", shell=True)
        # duration of report generation depends on the target system - as along as sosreport is active, we don't want to timeout
        # it is also important to call some selenium method there to ensure that connection to HUB will not be lost
        with Timeout(seconds=240, error_message="Timeout: sosreport did not finished"):
            while True:
                try:
                    process.run("pgrep sosreport", shell=True)
                    self.wait_text("Generating report", overridetry=5)
                except:
                    break
                time.sleep(1)
        element = self.wait_id("sos-download")
        self.wait_xpath('//button[contains(text(), "%s")]' % "Download", cond=clickable, baseelement=element)
        self.click(self.wait_id("sos-cancel", cond=clickable))
        self.wait_text("This tool will collect system configuration and diagnostic")
        self.mainframe()
        self.error = False
