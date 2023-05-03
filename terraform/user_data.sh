#!/bin/bash
sleep 10
bash /home/ubuntu/aws_sync_s3.sh
sleep 5
docker start html80 
docker start html8080