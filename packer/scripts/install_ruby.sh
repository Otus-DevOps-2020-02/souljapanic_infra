#!/usr/bin/env bash

function installRuby {
	apt update
	apt install -y ruby-full ruby-bundler build-essential
	echo $(ruby -v)
	echo $(bundler -v)
}

installRuby
