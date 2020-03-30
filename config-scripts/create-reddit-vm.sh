#!/bin/sh

function function_create_instance {
	gcloud compute instances create app-reddit-exp --scopes storage-ro --boot-disk-size=10GB --image-family reddit-full --image-project=infra-271907 --machine-type=g1-small --tags app-reddit-exp --restart-on-failure
}

function function_create_rule {
	gcloud compute firewall-rules create app-reddit-exp --allow=tcp:9292 --direction=INGRESS --target-tags=app-reddit-exp
}

function_create_instance
function_create_rule
