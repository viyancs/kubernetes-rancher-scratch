#!/bin/bash
apt update
apt install ufw build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libgd-dev -y
ufw allow 80

# setup load balancer #
wget http://nginx.org/download/nginx-1.25.2.tar.gz
tar -zxvf nginx-1.25.2.tar.gz
cd nginx-1.25.2
./configure --with-stream
make
make install

# Create the Nginx service file
tee /lib/systemd/system/nginx.service > /dev/null <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Start and enable the Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# add user nginx
adduser --system --no-create-home --disabled-login --disabled-password --group nginx --home /var/www/html

# Define the file to be modified
nginx_conf_file="/usr/local/nginx/conf/nginx.conf"

# Comment out the HTTP block
sed -i '/http {/,/}/ s/^/#/' "$nginx_conf_file"

# Define the configuration line to be added
config_line="include /usr/local/nginx/stream.conf;"

# Check if the line already exists in the nginx.conf file
if ! grep -qF "$config_line" "$nginx_conf_file"; then
    # Add the line to the nginx.conf file at the beginning
    sed -i '11s|^|'"$config_line"'\n|' "$nginx_conf_file"
    echo "Added the streamconfig to nginx.conf."
else
    echo "streamconfig already exists in nginx.conf. Skipped."
fi

worker_processes_value="4"
# Check if the worker_processes directive exists and modify it if necessary
if grep -q '^ *worker_processes *' "$nginx_conf_file"; then
    # Worker processes directive exists, replace its value
    sudo sed -i 's/^\( *worker_processes\) .*/\1 '"$worker_processes_value"';/' "$nginx_conf_file"
    echo "Replaced worker_processes directive in nginx.conf."
else
    # Worker processes directive doesn't exist, add it
    sudo sed -i '/http {/a worker_processes '"$worker_processes_value"';' "$nginx_conf_file"
    echo "Added worker_processes directive to nginx.conf."
fi

# Define the configuration line to be added
config_line="include /usr/share/nginx/modules/*.conf;"

# Check if the line already exists in the nginx.conf file
if ! grep -qF "$config_line" "$nginx_conf_file"; then
    # Add the line to the nginx.conf file at the beginning
    sed -i '1s|^|'"$config_line"'\n|' "$nginx_conf_file"
    echo "Added the load_module directive to nginx.conf."
else
    echo "Directive already exists in nginx.conf. Skipped."
fi

# Define the configuration line to be added
config_line="user nginx;"
# Check if the line already exists in the nginx.conf file
if ! grep -qF "$config_line" "$nginx_conf_file"; then
    # Add the line to the nginx.conf file at the beginning
    sed -i '1s/^/'"$config_line"'\n/' "$nginx_conf_file"
    echo "Added the user directive to nginx.conf."
else
    echo "Directive already exists in nginx.conf. Skipped."
fi

mkdir -p /usr/local/nginx/conf.d/
# Define the configuration line to be added
config_line="include /usr/local/nginx/conf.d/*.conf;"

# Check if the line already exists in the nginx.conf file
if ! grep -qF "$config_line" "$nginx_conf_file"; then
    # Add the line to the nginx.conf file in the appropriate section (e.g., http block)
    sed -i '/http {/a '"$config_line"'' "$nginx_conf_file"
    echo "Added the include directive to nginx.conf."
else
    echo "Directive already exists in nginx.conf. Skipped."
fi

cat << 'EOF' > /usr/local/nginx/stream.conf

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