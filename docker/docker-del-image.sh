#!/bin/bash
# 删除特定条件的Docker镜像
# 该脚本会查找并删除 hub.selinux.cn 上大小为GB或MB的镜像（排除 test、hour、days ago）

set -e
# 获取需要删除的镜像名称列表
images=$(docker images | grep -E "(GB|MB)" | grep "hub.selinux.cn" | grep -v -E "(none|test|hour|days ago)" | awk -F ' ' '{print $1 ":" $2}')

# 检查是否有镜像需要删除
if [ -n "$images" ]; then
    # 遍历镜像名称列表，逐个删除镜像
    for imageName in $images; do
        docker rmi "$imageName"
        echo "docker rmi $imageName"
    done
else
    echo "没有找到需要删除的镜像"
fi
