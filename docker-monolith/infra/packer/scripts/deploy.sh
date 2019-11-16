#!/bin/sh
set -e

cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
cd ..
sudo cp puma.service /etc/systemd/system
chmod +x puma.service
sudo systemctl daemon-reload
sudo systemctl start puma.service
sudo systemctl enable puma.service


