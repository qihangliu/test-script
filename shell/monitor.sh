#!/bin/env bash
# 获取要监控的本地服务器IP地址
IP=$(ifconfig | grep inet | grep -vE 'inet6|127.0.0.1' | awk '{print $2}')
echo "IP地址："$IP
 
# 获取cpu总核数
cpu_num=$(grep -c "model name" /proc/cpuinfo)
echo "cpu总核数："$cpu_num
 
# 1、获取CPU利用率
################################################
#us 用户空间占用CPU百分比
#sy 内核空间占用CPU百分比
#ni 用户进程空间内改变过优先级的进程占用CPU百分比
#id 空闲CPU百分比
#wa 等待输入输出的CPU时间百分比
#hi 硬件中断
#si 软件中断
#################################################
# 获取用户空间占用CPU百分比
top_output=$(top -b -n 1)
cpu_user=`echo "$top_output" | grep Cpu | awk '{print $2}' | cut -f 1 -d "%"`
echo "用户空间占用CPU百分比："$cpu_user
 
# 获取内核空间占用CPU百分比
cpu_system=`echo "$top_output" | grep Cpu | awk '{print $4}' | cut -f 1 -d "%"`
echo "内核空间占用CPU百分比："$cpu_system
 
# 获取空闲CPU百分比
cpu_idle=`echo "$top_output" | grep Cpu | awk '{print $8}' | cut -f 1 -d "%"`
echo "空闲CPU百分比："$cpu_idle
 
# 获取等待输入输出占CPU百分比
cpu_iowait=`echo "$top_output" | grep Cpu | awk '{print $10}' | cut -f 1 -d "%"`
echo "等待输入输出占CPU百分比："$cpu_iowait
 
#2、获取CPU上下文切换和中断次数
# 获取CPU中断次数
vmstat_output=$(vmstat -n 1 1)
cpu_interrupt=`echo "$vmstat_output" | sed -n 3p | awk '{print $11}'`
echo "CPU中断次数："$cpu_interrupt
 
# 获取CPU上下文切换次数
cpu_context_switch=`echo "$vmstat_output" | sed -n 3p | awk '{print $12}'`
echo "CPU上下文切换次数："$cpu_context_switch
 
#3、获取CPU负载信息
# 获取CPU15分钟前到现在的负载平均值
cpu_load_15min=`uptime | awk '{print $11}' | cut -f 1 -d ','`
echo "CPU 15分钟前到现在的负载平均值："$cpu_load_15min
 
# 获取CPU5分钟前到现在的负载平均值
cpu_load_5min=`uptime | awk '{print $10}' | cut -f 1 -d ','`
echo "CPU 5分钟前到现在的负载平均值："$cpu_load_5min
 
# 获取CPU1分钟前到现在的负载平均值
cpu_load_1min=`uptime | awk '{print $9}' | cut -f 1 -d ','`
echo "CPU 1分钟前到现在的负载平均值："$cpu_load_1min
 
# 获取任务队列(就绪状态等待的进程数)
cpu_task_length=`echo "$vmstat_output" | sed -n 3p | awk '{print $1}'`
echo "CPU任务队列长度："$cpu_task_length
 
#4、获取内存信息
# 获取物理内存总量
free_output=$(free)
mem_total=`echo "$free_output" | grep Mem | awk '{print $2}'`
echo "物理内存总量："$mem_total
 
# 获取操作系统已使用内存总量
mem_sys_used=`echo "$free_output" | grep Mem | awk '{print $3}'`
echo "已使用内存总量(操作系统)："$mem_sys_used
 
# 获取操作系统未使用内存总量
mem_sys_free=`echo "$free_output" | grep Mem | awk '{print $4}'`
echo "剩余内存总量(操作系统)："$mem_sys_free
 
# 获取应用程序已使用的内存总量
mem_user_used=`echo "$free_output" | sed -n 3p | awk '{print $3}'`
echo "已使用内存总量(应用程序)："$mem_user_used
 
# 获取应用程序未使用内存总量
mem_user_free=`echo "$free_output" | sed -n 3p | awk '{print $4}'`
echo "剩余内存总量(应用程序)："$mem_user_free
 
 
# 获取交换分区总大小
mem_swap_total=`echo "$free_output" | grep Swap | awk '{print $2}'`
echo "交换分区总大小："$mem_swap_total
 
# 获取已使用交换分区大小
mem_swap_used=`echo "$free_output" | grep Swap | awk '{print $3}'`
echo "已使用交换分区大小："$mem_swap_used
 
# 获取剩余交换分区大小
mem_swap_free=`echo "$free_output" | grep Swap | awk '{print $4}'`
echo "剩余交换分区大小："$mem_swap_free
 

#5、获取磁盘I/O统计信息
iostat_output=`iostat -kx`
disk_device=`echo "$iostat_output" | awk '$1 ~ /^(sd[a-z]+|vd[a-z]+|xvd[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+)$/ {print $1; exit}'`
disk_stats=`echo "$iostat_output" | awk -v device="$disk_device" '$1 == device {print; exit}'`
echo "指定设备(/dev/"$disk_device")的统计信息"
# 每秒向设备发起的读请求次数
disk_sda_rs=`echo "$disk_stats" | awk '{print $4}'`
echo "每秒向设备发起的读请求次数："$disk_sda_rs
 
# 每秒向设备发起的写请求次数
disk_sda_ws=`echo "$disk_stats" | awk '{print $5}'`
echo "每秒向设备发起的写请求次数："$disk_sda_ws
 
# 向设备发起的I/O请求队列长度平均值
disk_sda_avgqu_sz=`echo "$disk_stats" | awk '{print $9}'`
echo "向设备发起的I/O请求队列长度平均值"$disk_sda_avgqu_sz
 
# 每次向设备发起的I/O请求平均时间
disk_sda_await=`echo "$disk_stats" | awk '{print $10}'`
echo "每次向设备发起的I/O请求平均时间："$disk_sda_await
 
# 向设备发起的I/O服务时间均值
disk_sda_svctm=`echo "$disk_stats" | awk '{print $11}'`
echo "向设备发起的I/O服务时间均值："$disk_sda_svctm
 
# 向设备发起I/O请求的CPU时间百分占比
disk_sda_util=`echo "$disk_stats" | awk '{print $12}'`
echo "向设备发起I/O请求的CPU时间百分占比："$disk_sda_util
