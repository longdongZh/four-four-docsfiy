#!/bin/sh

echo "Starting Docsify with auto-reload..."

# 默认值
DOCSIFY_NAME="${DOCSIFY_NAME:-FourFour}"
DOCSIFY_VERSION="${DOCSIFY_VERSION:-2.20.1}"
DOCSIFY_BASE_PATH="${DOCSIFY_BASE_PATH:-docs}"
DOCSIFY_REPO="${DOCSIFY_REPO:-}"
DOCSIFY_ROUTER_MODE="${DOCSIFY_ROUTER_MODE:-hash}"
DOCSIFY_SUB_MAX_LEVEL="${DOCSIFY_SUB_MAX_LEVEL:-5}"
DOCSIFY_SIDEBAR_DISPLAY_LEVEL="${DOCSIFY_SIDEBAR_DISPLAY_LEVEL:-5}"
BAIDU_TJ_ID="${BAIDU_TJ_ID:-}"
VALINE_APP_ID="${VALINE_APP_ID:-}"
VALINE_APP_KEY="${VALINE_APP_KEY:-}"
AUTH_ENABLE="${AUTH_ENABLE:-true}"
AUTH_PASSWORD="${AUTH_PASSWORD:-}"

# 确保 basePath 有尾部斜杠
if [[ "$DOCSIFY_BASE_PATH" != */ ]]; then
    DOCSIFY_BASE_PATH_WITH_SLASH="${DOCSIFY_BASE_PATH}/"
else
    DOCSIFY_BASE_PATH_WITH_SLASH="$DOCSIFY_BASE_PATH"
fi

echo "Docsify configuration:"
echo "  - Name: ${DOCSIFY_NAME}"
echo "  - Version: ${DOCSIFY_VERSION}"
echo "  - Base Path: ${DOCSIFY_BASE_PATH_WITH_SLASH}"
echo "  - Router Mode: ${DOCSIFY_ROUTER_MODE}"

# 替换 index.html 中的配置
sed -i "s|name: 'FourFour<span class=\"mg-badge\">2.20.1</span>'|name: '${DOCSIFY_NAME}<span class=\"mg-badge\">${DOCSIFY_VERSION}</span>'|" /usr/share/nginx/html/index.html
sed -i "s|basePath: 'docs/'|basePath: '${DOCSIFY_BASE_PATH_WITH_SLASH}'|" /usr/share/nginx/html/index.html
sed -i "s|routerMode: 'hash'|routerMode: '${DOCSIFY_ROUTER_MODE}'|" /usr/share/nginx/html/index.html
sed -i "s|subMaxLevel: 5|subMaxLevel: ${DOCSIFY_SUB_MAX_LEVEL}|" /usr/share/nginx/html/index.html
sed -i "s|sidebarDisplayLevel: 5|sidebarDisplayLevel: ${DOCSIFY_SIDEBAR_DISPLAY_LEVEL}|" /usr/share/nginx/html/index.html
sed -i "s|baiduTjId: \"\"|baiduTjId: \"${BAIDU_TJ_ID}\"|" /usr/share/nginx/html/index.html
sed -i "s|appId: \"\"|appId: \"${VALINE_APP_ID}\"|" /usr/share/nginx/html/index.html
sed -i "s|appKey: \"\"|appKey: \"${VALINE_APP_KEY}\"|" /usr/share/nginx/html/index.html
sed -i "s|enable: true|enable: ${AUTH_ENABLE}|" /usr/share/nginx/html/index.html
sed -i "s|password: \"\"|password: \"${AUTH_PASSWORD}\"|" /usr/share/nginx/html/index.html

# 如果有 repo 配置，也进行替换
if [ -n "$DOCSIFY_REPO" ]; then
    sed -i "s|// repo: 'https://github.com/mg0324/docsify-template.git'|repo: '${DOCSIFY_REPO}'|" /usr/share/nginx/html/index.html
fi

echo "Configuration applied successfully!"
echo ""

# 启动 Nginx
nginx -g "daemon off;" &
NGINX_PID=$!

echo "Nginx started with PID: $NGINX_PID"

# 如果启用了自动刷新，启动文件监听
if [ "${AUTO_RELOAD:-false}" = "true" ]; then
    echo "Auto-reload is enabled. Watching for file changes..."
    
    # 创建一个标记文件用于跟踪变化
    MARKER_FILE="/tmp/last_check_time"
    date +%s > "$MARKER_FILE"
    
    # 监听文档目录变化
    while true; do
        # 查找最近修改的 markdown 文件
        CHANGED_FILES=$(find /usr/share/nginx/html/${DOCSIFY_BASE_PATH} -name "*.md" -newer "$MARKER_FILE" 2>/dev/null)
        
        if [ -n "$CHANGED_FILES" ]; then
            echo "Detected changes in markdown files, triggering reload..."
            # 更新标记文件时间
            date +%s > "$MARKER_FILE"
            # 通过 touch index.html 触发浏览器检测到变化
            touch /usr/share/nginx/html/index.html
        fi
        
        sleep 1
    done &
    WATCHER_PID=$!
    
    echo "File watcher started with PID: $WATCHER_PID"
    
    # 等待任一进程结束
    wait $NGINX_PID
    kill $WATCHER_PID 2>/dev/null
else
    echo "Auto-reload is disabled."
    wait $NGINX_PID
fi
