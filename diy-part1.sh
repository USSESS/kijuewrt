#!/bin/bash
set -e
# ==========关键！把本仓库全部package插件复制进openwrt编译环境 ==========
cp -r $GITHUB_WORKSPACE/package ./

# ==========本地仓库内定制Edge主题【路径修正：主题在仓库根目录】 ==========
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r $GITHUB_WORKSPACE/luci-theme-edge-master package/luci-theme-edge
    echo "✅本地Edge主题已导入"
else
    echo "❌错误：本地Edge主题文件缺失！终止编译"
    exit 1
fi

# 更新官方 feeds 并安装
./scripts/feeds update -a
./scripts/feeds install -a

# ========== 【验证】确认本地内置包都在 ==========
echo "====== 检查本地内置包 ======"
# iStore全部封装在luci-app-store内部，不再单独校验taskd等子依赖
pkg_list=(luci-app-store luci-lib-taskd luci-lib-xterm taskd luci-app-netwizard)
for pkg in "${pkg_list[@]}"; do
    if [ -d "package/$pkg" ]; then
        echo "OK  package/$pkg 存在"
    else
        echo "!!! package/$pkg 【缺失】！终止编译！"
        ls -la package/
        exit 1
    fi
done
