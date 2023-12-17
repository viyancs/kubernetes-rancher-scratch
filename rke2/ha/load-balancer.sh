#!/bin/bash
# setup load balancer #
apt install nginx -y
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

cat << 'EOF' > /etc/nginx/nginx.conf
user nginx;
worker_processes 4;
worker_rlimit_nofile 40000;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 8192;
}

stream {
    upstream backend {
        least_conn;
        server <IP_NODE_1>:9345 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:9345 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:9345 max_fails=3 fail_timeout=5s;
    }

    server {
        listen 9345;
        proxy_pass backend;
    }

    upstream rancher_api {
        least_conn;
        server <IP_NODE_1>:6443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:6443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:6443 max_fails=3 fail_timeout=5s;
    }

    server {
        listen 6443;
        proxy_pass rancher_api;
    }

    upstream rancher_http {
        least_conn;
        server <IP_NODE_1>:80 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:80 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:80 max_fails=3 fail_timeout=5s;
    }

    server {
        listen 80;
        proxy_pass rancher_http;
    }

    upstream rancher_https {
        least_conn;
        server <IP_NODE_1>:443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:443 max_fails=3 fail_timeout=5s;
    }

    server {
        listen 443;
        proxy_pass rancher_https;
    }
}
EOF

echo "Nginx configuration file created at /etc/nginx/nginx.conf"

# Check SELinux status
sestatus

# Disable SELinux by modifying the config file
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo "SELinux has been disabled in the configuration file."

systemctl restart nginx