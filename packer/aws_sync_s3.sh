#!/bin/bash -e
docker stop html80 
docker stop html8080 
aws s3 cp s3://terraform-aws-leason-safon686/dev/content/index.html /var/lib/docker/volumes/nginx-index80/_data/index.html 
aws s3 cp s3://terraform-aws-leason-safon686/dev/content2/index.html /var/lib/docker/volumes/nginx-index8080/_data/index.html 
docker start html80 
docker start html8080
