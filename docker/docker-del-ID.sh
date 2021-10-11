#!/bin/bash
set -e
mkdir /opt/dockerimages
cd /opt/dockerimages
docker images >  docker-images.log
cat  docker-images.log  |grep -v "test"  |grep -v "hour"  | grep -v "days ago" |awk -F ' ' '{print $3}' > docker-images1.log 
 images=$(cat docker-images1.log )
for imageName in ${images[@]} ; do
/bin/docker rmi  $imageName
echo "docker rmi  $imageName"
done