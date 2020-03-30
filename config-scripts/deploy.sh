#!/usr/bin/env bash

function deployApp {
	git clone -b monolith https://github.com/express42/reddit.git
	cd reddit && bundle install
	puma -d
}

deployApp
