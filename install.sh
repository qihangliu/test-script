#/bin/bash 

set -eu

echo "Choose the options you wanna install/upgrade [1|2|3|4|5|6]:"
echo "1. bashrc设置"
echo "2. apt安装常用软件"
echo "3. 安装vscode"
echo "4. 安装Oracle_JDK8"
echo "5. 安装oh-my-zsh"
echo "6. 安装Firefox浏览器"
read -rp "> " CHOICE

function bashrc () {

        # alias
        echo "alias ll='ls -lh --color=auto'" >> /root/.bashrc
        echo "alias mv='mv -i'" >> /root/.bashrc
        echo "alias rm='rm -i'" >> /root/.bashrc
        echo "alias c='clear'" >> /root/.bashrc
        echo "alias vi='vim'" >> /root/.bashrc

        #任何以空格开头的命令都不会保存到历史记录列表中
        echo "HISTCONTROL=ignorespace" >> /root/.bashrc

        #从历史记录文件中删除之前出现的所有相同命令，并且只将最后一次调用保存到历史记录列表中。
        echo "HISTCONTROL=ignorespace:erasedups" >> /root/.bashrc

        #在历史记录文件中在所有的条目前面添加上时间戳
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
        # 安装的软件有时候替代默认的文件方式，打开文件直接会用vscode打开，终端输入以下命令修复
        xdg-mime default dde-file-manager.desktop inode/directory
}



function oracle_java () {

        # install oracle jdk
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
        # 其中配置文件在 ~/.zshrc 可以配置主题和插件
        sudo apt -y  install zsh
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        sudo apt -y install fonts-powerline
        chsh -s /bin/zsh

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


# # bashrc
# # apt_install
# # oracle_java
# # oh-my-zsh
# # virtualbox
# # firefox

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
else
	exit
fi
