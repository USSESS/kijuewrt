#!/bin/bash
set -e
# ==========系统全局名称 KiJueWrt ==========
sed -i 's|ImmortalWrt|KiJueWrt|g' package/base-files/files/etc/openwrt_release
sed -i 's|OpenWrt|KiJueWrt|g' package/base-files/files/etc/openwrt_release
sed -i 's|DISTRIB_RELEASE=.*|DISTRIB_RELEASE='"'"'25.0.0.1'"'"'|g' package/base-files/files/etc/openwrt_release
sed -i 's|DISTRIB_CODENAME=.*|DISTRIB_CODENAME='"'"'KiJue'"'"'|g' package/base-files/files/etc/openwrt_release
sed -i 's|DISTRIB_DESCRIPTION=.*|DISTRIB_DESCRIPTION='"'"'KiJueWrt Built by GitHub Actions'"'"'|g' package/base-files/files/etc/openwrt_release
# 修改默认LAN IP为10.10.10.1
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
# 设置默认主机名 KiJueWrt
sed -i 's/set system.@system\[-1\].hostname=.*/set system.@system[0].hostname='\''KiJueWrt'\''/g' package/base-files/files/bin/config_generate

# ========== 【修复】files目录预写LuCI配置，固化默认中文 ==========
# 关键：新版LuCI语言设置走 luci.main.lang（config main 块），必须同时写 core 和 main。
# 默认主题用 edge（你仓库里的定制主题），和edge主题自带的30脚本保持一致。
mkdir -p files/etc/config
cat > files/etc/config/luci <<'LUCIEOF'
config core
	option lang 'auto'
	option mediaurlbase '/luci-static/edge'

config main
	option lang 'zh_cn'
LUCIEOF

# ========== uci-defaults 开机脚本：默认中文+时区+edge主题 ==========
# edge主题的 30_luci-theme-edge 会在本脚本之前执行，把 mediaurlbase 设成 edge。
# 本脚本(99_*)在后面执行，同样设成 edge，保持一致，不会被覆盖。
cat > package/base-files/files/etc/uci-defaults/99-kijuewrt <<"UCIEOF"
uci set luci.main.lang='zh_cn'
uci set luci.main.mediaurlbase='/luci-static/edge'
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'
uci commit luci
uci commit system
exit 0
UCIEOF

# ========== SSH Banner ==========
cat > package/base-files/files/etc/banner <<"BANNEREOF"
░██     ░██ ░██    ░█████                       ░██       ░██             ░██
░██    ░██           ░██                        ░██       ░██             ░██
░██   ░██   ░██      ░██  ░██    ░██  ░███████  ░██  ░██  ░██ ░██░████ ░████████
░███████    ░██      ░██  ░██    ░██ ░██    ░██ ░██ ░████ ░██ ░███        ░██
░██   ░██   ░██░██   ░██  ░██    ░██ ░█████████ ░██░██ ░██░██ ░██         ░██
░██    ░██  ░██░██   ░██  ░██   ░███ ░██        ░████   ░████ ░██         ░██
░██     ░██ ░██ ░██████    ░█████░██  ░███████  ░███     ░███ ░██          ░████
=========================================================
             KiJueWrt 25.0.0.1
=========================================================
BANNEREOF
echo "diy-part2 KiJueWrt全部设置完成"
