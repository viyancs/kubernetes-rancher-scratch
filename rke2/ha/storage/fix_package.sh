#!/bin/bash
apt-get install nfs-common
systemctl stop multipathd
systemctl disable multipathd