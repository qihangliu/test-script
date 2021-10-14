#!/bin/env bash

set -eu

echo "choose the options you wanna install/upgrade [1|2|3|4|5|6|7]:"
echo "1. bashrc设置"
echo "2. apt安装常用软件"
echo "3. 安装VSCode"
echo "4. 安装Oracle_JDK8"
echo "5. 安装oh-my-zsh"
echo "6. 安装Firefox浏览器"
echo "7. 安装以上所有"
read -rp "> " CHOICE

function bashrc () {

        # alias
        echo "alias ll='ls -lh --color=auto'" >> /root/.bashrc
        echo "alias mv='mv -i'" >> /root/.bashrc
        echo "alias rm='rm -i'" >> /root/.bashrc
        echo "alias c='clear'" >> /root/.bashrc
        echo "alias vi='vim'" >> /root/.bashrc

        # 任何以空格开头的命令都不会保存到历史记录列表中
        echo "HISTCONTROL=ignorespace" >> /root/.bashrc

        # 从历史记录文件中删除之前出现的所有相同命令，并且只将最后一次调用保存到历史记录列表中。
        echo "HISTCONTROL=ignorespace:erasedups" >> /root/.bashrc

        # 在历史记录文件中在所有的条目前面添加上时间戳
        echo 'HISTTIMEFORMAT="%F %T"' >> /root/.bashrc

        source ~/.bashrc
}



function apt_install () {

        echo "update system"
        apt -y update

        # minicom 
        apt -y install minicom 

        # microcom
        apt -y install microcom

        # telnet
        apt -y install telnet 

        # tcodump
        apt -y install tcpdump

        # 端口扫描工具namp
        apt -y install nmap

        # wireshark
        apt -y install wireshark
        # add root 
        usermod -aG wireshark $USER

        # putty
        apt -y install putty

        # samba
        apt -y install samba

        # traceroute window为tracert 
        apt -y install traceroute 

        # ping
        apt -y install inetutils-ping

        # net-tools包含基本网络工具例如：ifconfig
        apt -y install net-tools

        # git
        apt -y install git

        # curl 
        apt -y install curl

        # wget
        apt -y install wget

        # svn
        apt -y install svn

        # deepin安装nvidia闭源驱动，所需环境，有风险！！！
        # apt -y install linux-headers-amd64
        # apt -y install linux-headers-deepin-amd64
        # apt -y inetutils dkms
        # apt -y install make 
        # apt -y install gcc
        # deepin显卡驱动管理器,用来切换核心显卡和开源显卡驱动
        # apt -y inetutils deepin-graphics-driver-manager

        # 查看显卡使用情况
        # apt -y install nvidia-smi

        # 查看显卡驱动信息
        # apt -y install mesa-utils

        # TimeShift
        apt -y install timeshift

        # 以下为snap安装应用
        # postman
        # 安装snpd
        sudo apt -y install snapd
        sudo snap install postman

        # vscode
        sudo snap install --classic code  # or code-insiders
        
}



function vscode () {
        # vscode 最新版有兼容问题，建议使用deepin商店安装
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        su $USER 
        sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt  install apt-transport-https
        sudo apt  update
        sudo apt  install code
        # 安装的软件有时候替代默认的文件打开方式，会直接用vscode打开，终端输入以下命令修复
        xdg-mime default dde-file-manager.desktop inode/directory
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


function oh-my-zsh () {
        # oh-my-zsh 
        # 配置文件在 ~/.zshrc 可以配置主题写到theme和插件下载后写到plugins里面
        # z 快速跳转目录 
        # zsh-syntax-highlighting 高亮可用的命令
        # zsh-autosuggestions 输入命令自动补全
        # instll_zsh
        sudo apt -y  install zsh
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        # 由于国内经常无法使用 sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        # 所以，索性将安装脚本下载下来直接使用
        curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
        # zsh/oh-my-zsh-install.sh
        # choose oh-my-zsh theme
        sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" ~/.zshrc
        # install oh-my-zsh plugins
        git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
        sed -i "s/^plugins=.*/plugins=(git sudo z wd extract zsh-autosuggestions zsh-syntax-highlighting)/g" ~/.zshrc
        sudo apt -y install fonts-powerline
        # 切换bash为zsh
        chsh -s /bin/zsh

        source ~/.zshrc

}



# function virtualbox () {
#         # virtualbox 
#         apt update
#         apt -y install  virtualbox-6.1
#         # USB3.0 devices Extenstion  Pack
#         wget -c https://download.virtualbox.org/virtualbox/6.1.12/Oracle_VM_VirtualBox_Extension_Pack-6.1.12.vbox-extpack

# }

function firefox () {

        # 安装firefox最新版
        # 卸载旧版本firefox
        apt -y remove firefox
        # 指定下载目录  
        cd /home/$USER/Downloads

        wget -c https://download-ssl.firefox.com.cn/releases/firefox/esr/78.2/zh-CN/Firefox-latest-x86_64.tar.bz2

        tar -xvf Firefox-latest-x86_64.tar.bz2

        chmod 755 firefox/ -R

        sudo mv firefox/ /opt 

        if [ ! -f "/usr/bin/firefox" ]
        then
                sudo ln -s /opt/firefox/firefox /usr/bin/firefox
        fi
        # 创建deepin桌面图标
        cd /usr/share/applications
        cat > firefox.deskptop<<-EOF
        [Desktop Entry]
        Version=last
        Name=Firefox 
        Comment=this is firefox
        Exec=/opt/firefox/firefox
        Icon=/opt/firefox/icons/firefox.png
        Terminal=false
        Type=Application
        Categories=Application;Network;
	EOF

}

function postman () {
        wget -O postman https://dl.pstmn.io/download/latest/linux64
        cd /home/$USER/Downloads
        tar -xzf linux64
        mv Postman /opt/
        ln -s /opt/Postman/Postman /usr/local/bin/postman
        postman


        # 创建postman桌面图标
        cd /usr/share/applications
        cat > postman.deskptop<<-EOF
        [Desktop Entry]
        Type=Application
        Name=Postman
        Icon=/opt/Postman/app/resources/app/assets/icon.png
        Exec="/opt/Postman/Postman"
        Comment=Postman Desktop App
        Categories=Development;Code;
	EOF


        ## postman卸载方法
        # 通过手动安装
        # sudo rm -rf /opt/apps/Postman && rm /usr/local/bin/postman
        # sudo rm /usr/share/applications/postman.desktop
        # 通过自动安装
        # sudo snap remove postman
}


# # bashrc
# # apt_install
# # oracle_java
# # oh-my-zsh
# # virtualbox
# # firefox
# # postman

if [ $CHOICE = 1 ]; then
        bashrc
elif [ $CHOICE = 2 ]; then
        apt_install
elif [ $CHOICE = 3 ]; then
        vscode
elif [ $CHOICE = 4 ]; then
        oracle_java
elif [ $CHOICE = 5 ]; then
        oh-my-zsh
elif [ $CHOICE = 6 ]; then
        firefox
elif [  $Choose = 7 ];then
        apt_install
        vscode
        oracle_java
        oh-my-zsh
        firefox
else
	exit
fi
