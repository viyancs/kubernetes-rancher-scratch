#!/bin/bash
### fixing firewall ###
ufw enable
ufw allow 22
ufw allow 9345
ufw allow 6443
ufw allow 8472/udp 
ufw allow 10250
ufw allow 2379
ufw allow 2380
ufw allow 2381
ufw allow 30000:32767/tcp
ufw allow 8472/udp
ufw allow 4240
ufw allow proto icmp type 8/0
ufw allow 179
ufw allow 4789/udp
ufw allow 5473
ufw allow 9098
ufw allow 9099
ufw allow 5473
ufw allow 8472/udp
ufw allow 9099
ufw allow 51820/udp
ufw allow 51821/udp