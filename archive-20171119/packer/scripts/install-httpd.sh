#!/bin/bash

set -eux -o pipefail

sudo apt-get -y install nginx
sudo service nginx status

cat > /tmp/nginx-status.conf <<EOF
server {
  listen 127.0.0.1;
  server_name localhost;
  location /nginx_status {
    stub_status on;
    access_log   off;
    allow 127.0.0.1;
    deny all;
  }
}
EOF

sudo mv /tmp/nginx-status.conf /etc/nginx/conf.d/
sudo service nginx reload

sudo bash -c 'ln -s /usr/share/munin/plugins/nginx_request /etc/munin/plugins/nginx_request'
sudo bash -c 'ln -s /usr/share/munin/plugins/nginx_request /etc/munin/plugins/nginx_status'
sudo service munin-node restart
