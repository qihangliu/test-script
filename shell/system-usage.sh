#!/bin/bash
printf "Memory\t\tDisk\t\tWRITE\t\tCPU\n"
end=$((SECONDS+3600))
while [ $SECONDS -lt $end ]; do
    MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
    DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')  
    WRITE=$(grep -w mmcblk0 /proc/diskstats | busybox awk '{sum=$10/2048};END {print sum "MB"}')
    CPU=$(grep 'cpu ' /proc/stat | busybox awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "\t\t%.2f%\n", usage }') 
    echo "$MEMORY$DISK$WRITE$CPU"
    sleep 5
done

