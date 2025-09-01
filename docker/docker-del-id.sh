#!/bin/bash
# 删除特定条件的Docker镜像
# 该脚本会查找并删除不包含"test"、"hour"和"days ago"的Docker镜像

set -e
# 创建目录用于存放Docker镜像相关文件，如果目录已存在则不报错
mkdir -p /opt/dockerimages
# 进入到该目录
cd /opt/dockerimages
# 获取当前所有Docker镜像列表并保存到日志文件
docker images >  docker-images.log
# 从镜像列表中筛选出符合删除条件的镜像ID并保存到另一个日志文件
# 过滤掉包含"test"、"hour"和"days ago"的行，提取第3列（镜像ID）
cat  docker-images.log  |grep -v -E "(test|hour|days ago)" |awk -F ' ' '{print $3}' > docker-images1.log
# 读取需要删除的镜像ID列表
 images=$(cat docker-images1.log )
# 检查是否有镜像需要删除
if [ -n "$images" ]; then
    # 遍历镜像ID列表，逐个删除镜像
    for imageName in ${images[@]} ; do
    /bin/docker rmi  $imageName
    echo "docker rmi  $imageName"
    done
else
    echo "没有找到需要删除的镜像"
fi
