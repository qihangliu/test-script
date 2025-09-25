# =================================================================
# 基础镜像：官方长期支持版 LTS + JDK 21
# =================================================================
FROM jenkins/jenkins:lts-jdk21

# =================================================================
# 1. 环境准备与软件安装 (root 用户)
# =================================================================
USER root

# 设置时区
ENV TZ=Asia/Shanghai
# 设置默认的语言环境为 UTF-8
ENV LANG C.UTF-8
ENV JAVA_OPTS="-Duser.timezone=Asia/Shanghai"

# 切换到阿里云 Debian 源以加速软件包安装
RUN mv /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list.d/aliyun.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list.d/aliyun.list && \
    echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list.d/aliyun.list

# 安装 git、zip、docker-cli 等工具，并设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        git \
        zip \
        time && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# =================================================================
# 2. 安装 Jenkins 插件
# =================================================================
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# 如果你想用镜像源，可以解开下面的注释：
# ENV JENKINS_UC_DOWNLOAD=https://mirrors.huaweicloud.com/jenkins/plugins/
# ENV JENKINS_UC=https://mirrors.huaweicloud.com/jenkins/updates/update-center.json

RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# =================================================================
# 3. 切换回 jenkins 用户并暴露端口
# =================================================================
USER jenkins

EXPOSE 8080
EXPOSE 50000
