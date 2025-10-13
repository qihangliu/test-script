 script
#!/bin/bash
# 该脚本用于监控系统资源使用情况，包括内存、磁盘、写入速度和CPU使用率
# 监控将持续1小时，每5秒采集一次数据
# 输出格式：Memory		Disk		WRITE		CPU

# 打印表头信息
printf "Memory\t\tDisk\t\tWRITE\t\tCPU\n"

# 设置监控结束时间（当前秒数+3600秒=1小时后）
end=$((SECONDS+3600))

# 循环监控系统资源，持续1小时
while [ $SECONDS -lt $end ]; do
    # 获取内存使用率，单位为MB，计算已使用内存占总内存的百分比
    MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')

    # 获取根分区磁盘使用率
    DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')

    # 获取mmcblk0设备的写入速度，单位转换为MB
    WRITE=$(grep -w mmcblk0 /proc/diskstats | busybox awk '{sum=$10/2048};END {print sum "MB"}')

    # 获取CPU使用率，基于/proc/stat中的cpu统计信息计算
    CPU=$(grep 'cpu ' /proc/stat | busybox awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "\t\t%.2f%\n", usage }')

    # 输出当前采集的系统资源使用情况
    echo "$MEMORY$DISK$WRITE$CPU"

    # 等待5秒后进行下一次数据采集
    sleep 5
done
