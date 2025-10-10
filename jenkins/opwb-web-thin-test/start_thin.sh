#!/bin/sh

# ==============================================================================
#  瘦包部署 + 配置外部化 启动/停止脚本 (结合 Fat Jar 参数)
# ==============================================================================

# --- 可配置区域 ---

# 1. 基础配置
# 获取脚本所在目录的绝对路径 (部署根目录)
RUN_DIR=$(cd "$(dirname "$0")" && pwd)
LOG_FILE="${RUN_DIR}/opwb_thin.log"
PID_FILE="${RUN_DIR}/pid_thin"
APP_NAME="opwb-web"

# 2. Java & JVM 配置
# Java 可执行文件路径
JAVA_CMD="/data/server/java/jdk-21.0.3+9/bin/java"
# JVM 基础启动参数
JAVA_OPTS="--add-opens java.base/sun.reflect.annotation=ALL-UNNAMED"
# (可选) 远程调试参数 (默认关闭, 去掉 # 即可开启)
# JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5787"

# 3. Spring Boot 配置
# Spring Boot 主启动类
MAIN_CLASS="com.opwb.opwbweb.OpwbWebApplication"
# 指定运行环境 (参考自 opwb.sh)
SPRING_PROFILE="workbench"
# 指定端口号 (参考自 opwb.sh)
SERVER_PORT="8090"
# 其他需要覆盖的启动参数 (参考自 opwb.sh)
ADDITIONAL_ARGS="--spring.kafka.listener.auto-startup=true"


# --- 内部函数 ---

# 检查进程是否在运行
check_pid() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null; then
            return 0 # 正在运行
        else
            echo "[WARN] 发现无效的 PID 文件 (PID: $PID)，将自动删除。"
            rm -f "$PID_FILE"
            return 1 # 未运行
        fi
    fi
    return 1 # 未运行
}


# --- 主要逻辑 ---
case "$1" in
    start)
        if check_pid; then
            echo "[WARN] 应用 '${APP_NAME}' 已经在运行 (PID: $(cat "$PID_FILE"))."
            exit 1
        fi

        echo "[INFO] 正在启动应用 '${APP_NAME}'..."

        # --- 智能 Classpath 构建 ---
        CLASSPATH="${RUN_DIR}/config:$(find "${RUN_DIR}" -maxdepth 1 -name "opwb-*.jar" | paste -sd:):$(find "${RUN_DIR}/lib" -name "*.jar" | paste -sd:)"

        # --- 外部化配置路径 ---
        CONFIG_LOCATION="classpath:/,file:${RUN_DIR}/config/"

        # --- 最终执行启动命令 ---
        nohup ${JAVA_CMD} ${JAVA_OPTS} \
            -cp "${CLASSPATH}" \
            ${MAIN_CLASS} \
            --spring.config.location=${CONFIG_LOCATION} \
            --spring.profiles.active=${SPRING_PROFILE} \
            --server.port=${SERVER_PORT} \
            ${ADDITIONAL_ARGS} \
            >> ${LOG_FILE} 2>&1 &

        echo $! > ${PID_FILE}

        sleep 2
        if check_pid; then
              echo "[INFO] 应用启动成功! PID: $(cat ${PID_FILE}), 日志文件: ${LOG_FILE}"
        else
              echo "[ERROR] 应用启动失败! 请检查日志: ${LOG_FILE}"
              rm -f ${PID_FILE}
              exit 1
        fi
        ;;

    stop)
        if check_pid; then
            PID=$(cat "${PID_FILE}")
            echo "[INFO] 正在停止应用 '${APP_NAME}' (PID: $PID)..."
            kill -15 "$PID" # 尝试优雅关闭

            for i in $(seq 1 10); do
                if ! check_pid; then
                    rm -f "${PID_FILE}"
                    echo "[INFO] 应用已成功停止。"
                    exit 0
                fi
                sleep 1
            done

            if check_pid; then
                echo "[WARN] 优雅关闭超时，正在强制停止 (kill -9)..."
                kill -9 "$PID"
                rm -f "${PID_FILE}"
                echo "[INFO] 应用已被强制停止。"
            fi
        else
            echo "[INFO] 应用 '${APP_NAME}' 未在运行。"
        fi
        ;;

    restart)
        sh "$0" stop
        sh "$0" start
        ;;

    status)
        if check_pid; then
            echo "[INFO] 应用 '${APP_NAME}' 正在运行 (PID: $(cat "$PID_FILE"))"
        else
            echo "[INFO] 应用 '${APP_NAME}' 已停止。"
        fi
        ;;

    *)
        echo "用法: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
