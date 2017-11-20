#!/bin/bash

set -eux -o pipefail

# update cchwebsite
pushd /home/cchwebsite/www
sudo -u cchwebsite bash -c "git pull"
sudo -u cchwebsite bash -c "BUNDLE_PATH=.bundle BUNDLE_DISABLE_SHARED_GEMS=1 bundle install"
sudo -u cchwebsite bash -c "LANG=en_US.UTF-8 BUNDLE_PATH=.bundle BUNDLE_DISABLE_SHARED_GEMS=1 bundle exec rake generate"
sudo service nginx reload
