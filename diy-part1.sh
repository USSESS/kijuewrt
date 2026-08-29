#!/bin/bash
set -e

#复制仓库全部package插件到openwrt编译目录
cp -r "$GITHUB_WORKSPACE/package" ./

#复制edge主题
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
    echo "✅本地Edge主题已导入"
else
    echo "❌错误：本地Edge主题文件缺失！终止编译"
    exit 1
fi

#更新feeds
./scripts/feeds update -a
./scripts/feeds install -a

echo "====== 检查本地内置包 ======"
PACKAGES=(
luci-app-store
luci-lib-taskd
luci-lib-xterm
taskd
luci-app-netwizard
)

for p in "${PACKAGES[@]}"; do
    if [ ! -d "package/$p" ];then
        echo "!!! package/$p 【缺失】！终止编译！"
        ls -la package/
        exit 1
    fi
    echo "OK package/$p 存在"
done

echo "====== diy‑part1.sh 执行完毕 ======"
