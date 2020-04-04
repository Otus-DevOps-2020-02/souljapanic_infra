#!/bin/bash

set -e

sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

sudo systemctl restart mongod.service
