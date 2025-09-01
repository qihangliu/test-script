#!/bin/bash
set -e
# 创建目录用于存放Docker镜像相关文件，如果目录已存在则不报错
mkdir -p /opt/dockerimages
# 进入到该目录
cd /opt/dockerimages
# 获取当前所有Docker镜像列表并保存到日志文件
/bin/docker images > docker-iamges.log
# 从镜像列表中筛选出大小为GB或MB的镜像并保存到日志文件
cat docker-iamges.log  |grep -E "(GB|MB)" > docker-iamges1.log
# 从这些镜像中进一步筛选出符合删除条件的镜像名称和标签
cat docker-iamges1.log  |grep "hub.selinux.cn" |grep -v -E "(none|test|hour|days ago)" |awk -F ' ' '{print $1 ":" $2}' >  docker-iamges2.log
# 读取需要删除的镜像名称列表
images=$(cat docker-iamges2.log )
# 检查是否有镜像需要删除
if [ -n "$images" ]; then
    # 遍历镜像名称列表，逐个删除镜像
    for imageName in ${images[@]} ; do
    /bin/docker rmi  $imageName
    echo "docker rmi  $imageName"
    done
else
    echo "没有找到需要删除的镜像"
fi
