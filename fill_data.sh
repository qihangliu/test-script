#########################################################################
# Copyright(c) 2020,UNIONMAN TECHNOLOGY CO.,LID
# All rights reserved
#
# File Name: fill_data.sh
# Author : jianfeng.lai
# History:
#	Date			Author         	Version		Descripion
#	2020.03.19		jianfeng.lai	1.0			实现初版功能				
#########################################################################
#!/bin/bash -e

version=1.0

out_file_name=$1
file_size=$2
size_unit=$3
tmp_out_file_name=$out_file_name.tmp
 
function check_input_param()
{
    if [[ "a" == "a"$out_file_name || "a" == "a"$file_size || "a" == "a"$size_unit ]]; then
        echo "参数错误!"
        echo "输入如下: $0 [out-file-name] [file-szie] [size-unit]"
		echo "例如: ./fill_data.sh fill_tmp1.bin 1024 M"
        echo "参数说明:"
        echo "[out-file-name]: 生成填充数据文件名,相对路径或绝对路径都可以."
        echo "[file-size]: 生成填充文件的文件大小，必须是整数."
        echo "[size-unit]: 目前只支持 K/M k/m. 表示 xxxKB/xxxMB."
        exit
    fi
}

function check_file()
{
    if [ -f "$out_file_name" ]; then
        echo "[out-file-name] error: $out_file_name 文件已经存在!"
        exit
    fi
}

function check_file_size_if_integer()
{
    if [ "$file_size" -gt 0 ] 2>/dev/null; then
        echo "file_size=$file_size"
    else
        echo "[file-size] error: 生成填充文件的文件大小，必须是整数.."
    exit
    fi
}
 
function check_size_unit()
{
    if [[ "K" != $size_unit && "k" != $size_unit && "M" != $size_unit &&  "m" != $size_unit ]]; then
        echo "[size-unit] error: 目前只支持 K/M k/m. 表示 xxxKB/xxxMB."
        exit
    fi
}
 
function create_random_file()
{
    #dd if=/dev/urandom of=$tmp_out_file_name bs=1$size_unit count=$file_size conv=notrunc
    if [[ "K" == $size_unit || "k" == $size_unit  ]]; then
        dd if=/dev/zero of=$tmp_out_file_name bs=1024 count=$file_size
    elif [[ "M" == $size_unit || "m" == $size_unit ]]; then
        dd if=/dev/zero of=$tmp_out_file_name bs=1048576‬ count=$file_size
    fi
    mv $tmp_out_file_name $out_file_name
}

echo "Tools Version:$version."
check_input_param
check_file
check_file_size_if_integer
check_size_unit
create_random_file

