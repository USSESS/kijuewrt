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
# 本地导入仓库内定制Edge主题【路径修正：主题在仓库根目录，不在package】
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
    echo "✅本地Edge主题已导入"
else
    echo "❌错误：本地Edge主题文件夹缺失！终止编译"
    exit 1
fi

# 更新官方 feeds 并安装
./scripts/feeds update -a
./scripts/feeds install -a

# 中文语言包（让 LuCI 变中文的核心是 base-zh-cn，必装）
./scripts/feeds install luci-i18n-base-zh-cn

# ========== 【验证】确认本地内置包都在 ==========
echo "====== 检查本地内置包 ======"
# iStore全部封装在luci-app-store内部，不再单独校验taskd等子依赖
pkg_list=(luci-app-store luci-app-netwizard)
for pkg in "${pkg_list[@]}"; do
    if [ -d "package/$pkg" ]; then
        echo "OK  package/$pkg 存在"
    else
        echo "!!! package/$pkg 【缺失】！终止编译！"
        exit 1
    fi
done
echo "====== diy-part1.sh 执行完毕 ======"
