#!/bin/bash
set -e
mkdir /opt/dockerimages
cd /opt/dockerimages
/bin/docker images > docker-iamges.log 
cat docker-iamges.log  |grep "GB" > docker-iamges1.log 
cat docker-iamges.log  |grep "MB" >> docker-iamges1.log 
cat   docker-iamges1.log  |grep "hub.selinux.cn" |grep -v "none"|grep -v "test"  |grep -v "hour"  | grep -v "days ago" |awk -F ' ' '{print $1 ":" $2}' >  docker-iamges2.log 
images=$(cat docker-iamges2.log )
for imageName in ${images[@]} ; do
/bin/docker rmi  $imageName
echo "docker rmi  $imageName"
done