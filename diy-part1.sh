#!/bin/bash
set -e

# ============================================================
# 【本地内置包方案】
# iStore(luci-app-store + 依赖) 和 netwizard(luci-app-netwizard)
# 的源码已直接放在本仓库 package/ 目录下，编译用本地源码，
# 不再添加第三方 feeds 源，避免外部源拉取失败/不兼容导致漏包。
# 本脚本只更新官方 feeds（packages/luci/routing/telephony 等），
# luci-compat、中文语言包等都来自这些官方源。
# ============================================================

# 本地导入仓库内定制Edge主题
if [ -d "$GITHUB_WORKSPACE/package/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/package/luci-theme-edge-master" package/luci-theme-edge
    echo "本地Edge主题已导入"
else
    echo "警告：本地Edge主题文件夹缺失，跳过复制"
fi

# 更新官方 feeds 并安装
./scripts/feeds update -a
./scripts/feeds install -a

# 中文语言包（让 LuCI 变中文的核心是 base-zh-cn，必装）
./scripts/feeds install luci-i18n-base-zh-cn || true

# ========== 【验证】确认本地内置包都在 ==========
echo "====== 检查本地内置包 ======"
for pkg in luci-app-store luci-lib-taskd luci-lib-xterm taskd luci-app-netwizard; do
    if [ -d "package/$pkg" ]; then
        echo "OK  package/$pkg 存在"
    else
        echo "!!! package/$pkg 缺失！"
    fi
done
echo "====== diy-part1.sh 执行完毕 ======"
