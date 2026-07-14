#!/bin/bash
# ============================================
# Linux 一键部署脚本
# 用途: Spring Boot JAR 部署 + Nginx 反向代理
# 适用: Ubuntu 20.04+ / CentOS 7+
# ============================================

set -e

# ---- 配置变量（按需修改） ----
APP_NAME="demo-app"
APP_VERSION="1.0.0"
JAR_FILE="demo-0.0.1-SNAPSHOT.jar"
DEPLOY_DIR="/opt/app/${APP_NAME}"
JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"
SERVER_PORT=8080
NGINX_CONF_DIR="/etc/nginx"
LOG_DIR="/var/log/${APP_NAME}"

echo "========================================"
echo "  首页+个人中心 后端服务部署脚本 v1.0"
echo "========================================"

# ---- 1. 环境检查 ----
echo "[1/7] 检查运行环境..."

if ! command -v java &> /dev/null; then
    echo "❌ Java 未安装，请先安装 JDK 17+"
    echo "   Ubuntu: sudo apt install openjdk-17-jdk"
    echo "   CentOS: sudo yum install java-17-openjdk-devel"
    exit 1
fi

JAVA_VER=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)
echo "   Java 版本: $(java -version 2>&1 | head -1)"

if ! command -v nginx &> /dev/null; then
    echo "⚠️  Nginx 未安装，仅启动 Spring Boot 服务"
    echo "   安装: sudo apt install nginx  (或 yum install nginx)"
    HAS_NGINX=false
else
    echo "   Nginx 已安装: $(nginx -v 2>&1)"
    HAS_NGINX=true
fi

# ---- 2. 创建目录 ----
echo "[2/7] 创建部署目录..."
mkdir -p "${DEPLOY_DIR}"
mkdir -p "${LOG_DIR}"

# ---- 3. 复制JAR包 ----
echo "[3/7] 复制 JAR 包..."
if [ -f "${JAR_FILE}" ]; then
    cp "${JAR_FILE}" "${DEPLOY_DIR}/"
    echo "   JAR 已复制到 ${DEPLOY_DIR}/${JAR_FILE}"
else
    echo "❌ 未找到 JAR 文件: ${JAR_FILE}"
    echo "   请先执行: cd backend && mvn clean package -DskipTests"
    exit 1
fi

# ---- 4. 停止旧进程 ----
echo "[4/7] 停止旧服务..."
OLD_PID=$(pgrep -f "${JAR_FILE}" || true)
if [ -n "${OLD_PID}" ]; then
    echo "   停止进程 PID=${OLD_PID}"
    kill "${OLD_PID}" 2>/dev/null || true
    sleep 3
    # 强制杀
    kill -9 "${OLD_PID}" 2>/dev/null || true
    echo "   旧服务已停止"
else
    echo "   无运行中的旧服务"
fi

# ---- 5. 启动服务 ----
echo "[5/7] 启动 Spring Boot 服务..."
nohup java -jar \
    -Xms256m -Xmx512m \
    -Dserver.port=${SERVER_PORT} \
    -Dspring.profiles.active=prod \
    "${DEPLOY_DIR}/${JAR_FILE}" \
    > "${LOG_DIR}/app.log" 2>&1 &

NEW_PID=$!
echo "   服务已启动 PID=${NEW_PID}"

# 等待启动
echo "   等待服务就绪..."
for i in $(seq 1 30); do
    if curl -s "http://localhost:${SERVER_PORT}/api/home/banner" > /dev/null 2>&1; then
        echo "   ✅ 服务启动成功 (${i}s)"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "   ⚠️  服务启动超时，请检查日志: tail -f ${LOG_DIR}/app.log"
    fi
    sleep 1
done

# ---- 6. 创建 systemd 服务 ----
echo "[6/7] 配置 systemd 自启动..."
SYSTEMD_FILE="/etc/systemd/system/${APP_NAME}.service"

sudo tee "${SYSTEMD_FILE}" > /dev/null << EOF
[Unit]
Description=${APP_NAME} Spring Boot Application
After=network.target mysql.service

[Service]
Type=simple
User=root
WorkingDirectory=${DEPLOY_DIR}
ExecStart=/usr/bin/java -jar -Xms256m -Xmx512m -Dserver.port=${SERVER_PORT} ${DEPLOY_DIR}/${JAR_FILE}
Restart=on-failure
RestartSec=10
StandardOutput=append:${LOG_DIR}/app.log
StandardError=append:${LOG_DIR}/app.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable "${APP_NAME}" 2>/dev/null || echo "   ⚠️  无法启用自启动（可能缺少权限）"
echo "   systemd 服务已配置: ${APP_NAME}"

# ---- 7. Nginx 配置（可选） ----
if [ "${HAS_NGINX}" = true ] && [ -f "nginx.conf" ]; then
    echo "[7/7] 配置 Nginx 反向代理..."
    sudo cp nginx.conf "${NGINX_CONF_DIR}/sites-available/${APP_NAME}" 2>/dev/null || \
    sudo cp nginx.conf "${NGINX_CONF_DIR}/conf.d/${APP_NAME}.conf" 2>/dev/null || \
    echo "   ⚠️  无法自动配置 Nginx，请手动配置"

    sudo nginx -t 2>/dev/null && sudo systemctl reload nginx 2>/dev/null && \
    echo "   ✅ Nginx 配置已生效" || echo "   ⚠️  Nginx 配置测试失败"
else
    echo "[7/7] 跳过 Nginx 配置"
fi

# ---- 完成 ----
echo ""
echo "========================================"
echo "  ✅ 部署完成！"
echo "========================================"
echo ""
echo "  服务端口: ${SERVER_PORT}"
echo "  日志文件: ${LOG_DIR}/app.log"
echo "  健康检查: curl http://localhost:${SERVER_PORT}/api/home/banner"
echo ""
echo "  常用命令:"
echo "    查看日志: tail -f ${LOG_DIR}/app.log"
echo "    停止服务: sudo systemctl stop ${APP_NAME}"
echo "    重启服务: sudo systemctl restart ${APP_NAME}"
echo "    查看状态: sudo systemctl status ${APP_NAME}"
echo ""
