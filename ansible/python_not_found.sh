#/usr/bin/sh
ansible $1 --sudo -m raw -a "apt-get --yes install python python-simplejson"
