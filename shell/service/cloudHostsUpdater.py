#! /usr/local/bin/python
# -*- coding:utf-8 -*-

# Created by:yanghua
# Date      :2013-10-03

import sys
import urllib
import os
from shutil import copyfile


HOSTS_URL='https://smarthosts.googlecode.com/svn/trunk/hosts'

LOCAL_HOSTS='/etc/hosts'

def main():
    copyfile(LOCAL_HOSTS,'hosts.bak')
    with open(LOCAL_HOSTS,'aw') as hosts:
        hosts.write(os.linesep)
        for line in urllib.urlopen(HOSTS_URL):
            hosts.write(line.strip()+os.linesep)

    print "success!"

if __name__ == '__main__':
    if len(sys.argv)>1:
        HOSTS_URL = sys.argv[1]
    main()