#!/bin/bash

SG_ID="sg-09e04001ff20131f1"
AMI_ID="ami-0220d79f3f480ecf5"

    for instance in $@
    do
    INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --security-group-ids sg-09e04001ff20131f1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=mongodb}]" \
    --query 'Instances[0].InstanceId' \
    --output text 
    )
    if [ $instance == "frontend" ]; then
        IP=$(
        aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[].Instances[].PublicIpAddress' \
        --output text 
        ) 
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $InstanceId \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        
    )
    fi
done 
