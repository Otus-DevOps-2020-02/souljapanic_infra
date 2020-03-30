#!/usr/bin/env bash

function installMongo {
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
	sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
	sudo apt update && sudo apt install -y mongodb-org
	sudo systemctl enable mongod --now
}

installMongo