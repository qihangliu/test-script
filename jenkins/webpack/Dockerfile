# ====================================================================
#  第一阶段：工具准备阶段 (tools_builder)
#  目标：只获取 zip 命令
# ====================================================================
FROM debian:bullseye-slim as tools_builder

# 优化：更换为国内镜像源加速 apt-get，并一次性完成安装和清理
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends zip && \
    rm -rf /var/lib/apt/lists/*

# ====================================================================
#  第二阶段：最终构建环境 (final_builder)
#  目标：提供一个包含 Node.js 和所需工具的纯净环境。
# ====================================================================
FROM node:14.15.0

# 从第一阶段复制 zip 和 time 工具到最终的 Node.js 镜像中
COPY --from=tools_builder /usr/bin/zip /usr/bin/zip

# 设置默认工作目录
WORKDIR /app