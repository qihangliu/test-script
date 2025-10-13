 #!/system/bin/sh

# 检查输入参数是否合法，至少需要一个目录参数
if [ $# -lt 1 ]; then
        echo Usage: $0 {dir} [loop count] > /dev/console
        #exit 0
fi

# 获取系统启动完成状态属性
COM=`getprop "sys.boot_completed"`
echo "rw completed_va 123 :${COM}  ....." > /dev/console
if [ $COM ='' ]; then
	COM=0
fi

echo "rw completed_va:${COM}  ....." > /dev/console

# 等待系统启动完成，直到sys.boot_completed属性值为1
while [ $COM -ne 1 ]; do
	sleep 1
	COM=`getprop "sys.boot_completed"`
	echo "rw completed_va:${COM}  ....." > /dev/console
	if [ $COM ='' ]; then
		COM=0
	fi
done


# 设置测试目录和循环次数
DIR=/data
if [ $# -eq 2 ]; then
        LOOP_COUNT=$2
else
        LOOP_COUNT=1
fi
echo "------------Loop count: ${LOOP_COUNT}--------------" > /dev/console

# 检查测试目录是否存在
if [ ! -d ${DIR} ]; then
        echo Directory \"${DIR}\" not exists. > /dev/console
        exit 1
fi

# 固定模式测试函数
# 参数:
#   $1 - 测试模式字符串，如"\x5A\x5A\x5A\x5A"
#   $2 - 当前循环索引
# 返回值: 无
fix_pattern_test()
{
        local ix=4
        local MAX_FILE_SIZE=16777216
        local sw=0
        local PATTERN=$1
        local loop=$2
        local BASE_FILE=_${PATTERN//\\x/}_$loop.bin
        #For Android, remove \ again
        local BASE_FILE=${BASE_FILE//\\/}
        echo Create pattern file $BASE_FILE ... > /dev/console
        echo -en "${PATTERN}" >${DIR}/tmp.bin
        if [ "$?" != "0" ]; then
                echo "ERROR: Create base tmp.bin" > /dev/console
                exit 1
        fi

        # 通过不断复制合并文件来创建指定大小的测试文件
        while [ true ]; do
                cp ${DIR}/tmp.bin ${DIR}/tmp1.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: COPY tmp1.bin" > /dev/console
                exit 1
        fi
        cp ${DIR}/tmp.bin ${DIR}/tmp2.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: COPY tmp2.bin" > /dev/console
                exit 1
        fi
                cat ${DIR}/tmp1.bin ${DIR}/tmp2.bin >${DIR}/tmp.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: MERGE tmp1.bin and tmp2.bin" > /dev/console
                exit 1
        fi
        ix=$(($ix * 2));
        echo -ne "." > /dev/console
        if [ $ix -ge $MAX_FILE_SIZE ]; then
                rm ${DIR}/tmp1.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: RM tmp1.bin" > /dev/console
                exit 1
        fi
                rm ${DIR}/tmp2.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: RM tmp2.bin" > /dev/console
                exit 1
        fi
        mv ${DIR}/tmp.bin ${DIR}/$BASE_FILE 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: MOVE tmp.bin" > /dev/console
                exit 1
        fi
                ix=0
                break
        fi
        done
        echo "" > /dev/console
        sync
        echo 1 >/proc/sys/vm/drop_caches

        # 复制测试文件并进行比较验证
        echo Copy pattern file $BASE_FILE ... > /dev/console
        cp ${DIR}/${BASE_FILE} ${DIR}/${BASE_FILE}_copy.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: COPY" > /dev/console
                exit 1
        fi
        echo " " > /dev/console
        sync
        echo 1 >/proc/sys/vm/drop_caches
        echo Compare pattern file $BASE_FILE ... > /dev/console
        cmp ${DIR}/${BASE_FILE} ${DIR}/${BASE_FILE}_copy.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ]; then
                echo "ERROR: CMP" > /dev/console
                exit 1
        fi
        echo " " > /dev/console
        echo Delete file ${BASE_FILE}_copy ... > /dev/console
        rm ${DIR}/${BASE_FILE}_copy.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ];then
                echo "ERROR: RM ${BASE_FILE}_copy.bin" > /dev/console
                exit 1
        fi
}

# 随机模式测试函数
# 参数: 无
# 返回值: 无
random_patten_test()
{
        local BLOCK_SIZE=1048676
        local BLOCK_COUNT=1024
        echo "Create urandom file urandom${ix}.bin ..." > /dev/console
        busybox dd if=/dev/zero of=${DIR}/urandom$ix.bin bs=$BLOCK_SIZE count=$BLOCK_COUNT 1> /dev/console 2>&1
        if [ "$?" != "0" ];then
                echo "ERROR: WRITE" > /dev/console
                exit 1
        fi
        echo " " > /dev/console
        sync
        echo 1 >/proc/sys/vm/drop_caches

        # 创建随机数据文件并进行复制比较测试
        echo "Copy urandom file urandom$ix.bin ..." > /dev/console
        cp ${DIR}/urandom$ix.bin ${DIR}/urandom_copy.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ];then
                echo "ERROR: COPY" > /dev/console
                exit 1
        fi

        echo " " > /dev/console
        sync
        echo 1 >/proc/sys/vm/drop_caches
        echo "Cmp urandom file urandom$ix.bin ..." > /dev/console
        cmp ${DIR}/urandom$ix.bin ${DIR}/urandom_copy.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ];then
                echo "ERROR: CMP" > /dev/console
                exit 1
        fi
        echo " " > /dev/console
        echo "Remove urandom_copy file ..." > /dev/console
        rm ${DIR}/urandom_copy.bin 1> /dev/console 2>&1
        if [ "$?" != "0" ];then
                echo "RM ERROR" > /dev/console
                exit 1
        fi
}

echo ******** start ******** > /dev/console

ix=0

# 主测试循环，根据设定的循环次数执行测试
while [ true ] ; do
        echo ============== loop: $ix ============== > /dev/console

        count=$(cat ${DIR}/count.txt)
        count=$(($count + 1)); >/dev/console
        echo $count >/dev/console
        echo -en "$count" >${DIR}/count.txt

        # 执行各种固定模式测试（当前被注释掉）
        # fix_pattern_test "\x5A\x5A\x5A\x5A" $ix
        # fix_pattern_test "\xA5\xA5\xA5\xA5" $ix
        # fix_pattern_test "\x00\xFF\x00\xFF" $ix
        # fix_pattern_test "\xFF\x00\xFF\x00" $ix
        # fix_pattern_test "\x01\x01\x01\x01" $ix
        # fix_pattern_test "\x02\x02\x02\x02" $ix
        # fix_pattern_test "\x04\x04\x04\x04" $ix
        # fix_pattern_test "\x08\x08\x08\x08" $ix
        # fix_pattern_test "\x10\x10\x10\x10" $ix
        # fix_pattern_test "\x20\x20\x20\x20" $ix
        # fix_pattern_test "\x40\x40\x40\x40" $ix
        # fix_pattern_test "\x80\x80\x80\x80" $ix

        # 执行随机模式测试
        random_patten_test

        ix=$(($ix + 1));

        # 达到设定循环次数后重置计数器并清理测试文件
        if [ $ix -ge $LOOP_COUNT ]; then
                ix=0
                echo "Remove all test files ..." > /dev/console
                rm -f ${DIR}/*.bin 1> /dev/console 2>&1
        fi

done
