#!/bin/bash
####  "Must exec on all kubernetes node or on the storage only worker!!"
sudo apt update
sudo apt install nfs-common open-iscsi
#start the service now and on reboot
sudo systemctl enable open-iscsi --now
sudo systemctl start open-iscsi
sudo systemctl status open-iscsi
