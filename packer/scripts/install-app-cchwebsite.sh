#!/bin/bash

set -eux -o pipefail

sudo useradd --system cchwebsite
sudo mkdir -p /home/cchwebsite
sudo chown -R cchwebsite /home/cchwebsite

pushd /home/cchwebsite
sudo -u cchwebsite bash -c "git clone https://github.com/chooper/charleshooper.net.git www"
sudo chown -R cchwebsite .

pushd /home/cchwebsite/www
sudo -u cchwebsite bash -c "BUNDLE_PATH=.bundle BUNDLE_DISABLE_SHARED_GEMS=1 bundle install"
sudo -u cchwebsite bash -c "LANG=en_US.UTF-8 BUNDLE_PATH=.bundle BUNDLE_DISABLE_SHARED_GEMS=1 bundle exec rake generate"

cat > /tmp/cchwebsite-nginx.conf <<EOF
server {
    listen 80 backlog=2048;
    server_name www.charleshooper.net charleshooper.net localhost;

    root /home/cchwebsite/www/public;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

sudo mv /tmp/cchwebsite-nginx.conf /etc/nginx/sites-enabled/
sudo service nginx reload

## silly test
#curl -sSH 'Host: www.charleshooper.net' http://127.0.0.1/ | grep -c '<title>Charles Hooper</title>'
