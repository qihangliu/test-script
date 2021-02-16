#!/bin/env bash

set -eu

function apt_install () {

#  备份source.list
cp /etc/apt/sources.list /etc/apt/sources.list.bak
# 修改为阿里云的镜像源
cat > /etc/apt/sources.list << END
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
END

        echo "update software list"
        apt-get update 
        echo "install common tools "
        # ping
        apt-get install -y inetutils-ping 

        # net-tools包含基本网络工具例如：ifconfig
        apt-get install -y net-tools

        apt-get install -y unzip

        # 安装docker

        # # 先卸载旧版本docker
        # sudo apt-get remove docker docker-engine docker.io containerd runc
        
        # 获取安装脚本执行安装
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
}



function oracle_java () {

        # install oracle jdk8
        echo "ready configure oracle java jdk"
        jdkContainer="jdk.tar.gz"
        mkdir -p ~/Downloads
        cd ~/Downloads
        wget -O ${jdkContainer}  -c  https://repo.huaweicloud.com/java/jdk/8u201-b09/jdk-8u201-linux-x64.tar.gz
        tar -xvzf ${jdkContainer} 
        echo "解压JDK成功"

	echo "配置环境变量"
        sudo mv  ~/Downloads/jdk1.8.0_201  /usr/local/jdk

        sudo echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile
        sudo echo "export JRE_HOME=\$JAVA_HOME/jre" >> /etc/profile
        sudo echo "export CLASSPATH=\$JAVA_HOME/lib:\$JRE_HOME/lib" >> /etc/profile
        sudo echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

        echo "测试是否安装成功"
	java -version

        source /etc/profile

        echo "finish configure oracle java jdk"
        
}



function android_sdk () {
        apt-get install -y android-tools-adb

        wget  -c https://dl.google.com/android/repository/platform-tools_r30.0.5-linux.zip -P ~/Downloads

        unzip -o ~/Downloads/platform-tools_r30.0.5-linux.zip -d ~/Downloads

        cp -rf ~/Downloads/platform-tools /usr/lib/android-sdk/

        echo "测试是否安装成功"
        adb version 

}



function oh-my-zsh () {
        # oh-my-zsh 
        # 配置文件在 ~/.zshrc 可以配置主题写到theme和插件下载后写到plugins里面
        # z 快速跳转目录 
        # zsh-syntax-highlighting 高亮可用的命令
        # zsh-autosuggestions 输入命令自动补全
        # instll_zsh
        sudo apt-get install -y zsh
        # 由于国内经常无法使用 
        # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        # 将安装脚本下载下来直接使用
        curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

        # choose oh-my-zsh theme
        sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"random\"/g" ~/.zshrc

        # install oh-my-zsh plugins
        git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
        sed -i "s/^plugins=.*/plugins=(git sudo z wd extract zsh-autosuggestions zsh-syntax-highlighting)/g" ~/.zshrc

        # 安装fonts-powerline
        sudo apt-get install -y  fonts-powerline

        # 切换bash为zsh
        chsh -s /bin/zsh

        source ~/.zshrc

}

apt_install
oracle_java
android_sdk
oh-my-zsh


