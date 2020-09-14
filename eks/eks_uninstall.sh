#!/bin/bash
 
CLEAN=${CLEAN:-true}

if [[ $CLEAN == true ]]; then

    echo -e "\nCleaning up eks cluster."
    echo -e "\nSet CLEAN=false if you wish for this not to occur."
    eksctl delete cluster -f cluster.yaml

    echo -e "\nList of clusters to verify cleanup process"
    eksctl get cluster --region=ap-south-1
fi
