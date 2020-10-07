#!/bin/bash
set -x

#It gives the output of nodes in array format eg: ip-192-168-35-218.ap-south-1.compute.internal ip-192-168-36-249.ap-south-1.compute.internal ip-192-168-59-253.ap-south-1#.compute.internal
IFS=" " read -r -a nodes <<< "$( kubectl get node -o jsonpath="{.items[*].metadata.name}" )"
#It gives the output of pv in array format eg: pvc-313919eb-4fbd-40a0-ac03-d2a06c0979dd pvc-55de549c-499f-4074-ba4f-99455e9a02df pvc-f62c9516-0711-402f-82c8-773d31dd3#07c
IFS=" " read -r -a pvs <<< "$( kubectl get pv -o jsonpath="{.items[*].metadata.name}" )"

for (( i=0; i<${#nodes[@]}; i++ )); do
    echo "${nodes[i]} and ${pvs[i]}"
    cp volumeattachment_template.yaml .tmp/volumeattachment/volumeattachment"${i}".yaml
    sed  "s/nodeName:.*$/nodeName: ${nodes[i]}/g" -i .tmp/volumeattachment/volumeattachment"${i}".yaml
    sed  "s/persistentVolumeName:.*$/persistentVolumeName: ${pvs[i]}/g" -i .tmp/volumeattachment/volumeattachment"${i}".yaml
    sed  "s/name:.*$/name: csi-vol${i}/g" -i .tmp/volumeattachment/volumeattachment"${i}".yaml
done


