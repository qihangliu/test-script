#!/bin/bash
# 删除特定条件的Docker镜像
# 该脚本会查找并删除不包含"test"、"hour"和"days ago"的Docker镜像

set -e
# 获取需要删除的镜像ID列表（排除包含 test、hour、days ago 的行）
images=$(docker images | grep -v -E "(test|hour|days ago)" | awk -F ' ' '{print $3}')

# 检查是否有镜像需要删除
if [ -n "$images" ]; then
    # 遍历镜像ID列表，逐个删除镜像
    for imageName in $images; do
        docker rmi "$imageName"
        echo "docker rmi $imageName"
    done
else
    echo "没有找到需要删除的镜像"
fi
