#!/usr/bin/env bash

function installRuby {
	sudo apt update && sudo apt install -y ruby-full ruby-bundler build-essential
	echo $(ruby -v)
	echo $(bundler -v)
}

installRuby
