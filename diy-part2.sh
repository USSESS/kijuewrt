#!/bin/bash
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
# This is free software, licensed under the MIT License.

# ==========自定义固件信息 KiJueWrt ==========
cat > package/base-files/files/etc/openwrt_release <<EOF
DISTRIB_ID="KiJueWrt"
DISTRIB_RELEASE="1.0.0.1"
DISTRIB_DESCRIPTION="KiJueWrt    1.0.0.1"
DISTRIB_TARGET="x86/64"
DISTRIB_ARCH="x86_64"
EOF

# 修改主机名
sed -i 's/OpenWrt/KiJueWrt/g' package/base-files/files/bin/config_generate

# 修改默认后台IP为10.10.10.1
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate

# 设置开机默认argon主题（22.03有效）
sed -i '/uci set luci.main.mediaurlbase/a\uci set luci.main.theme=luci-theme-argon' package/base-files/files/bin/config_generate

# 壁纸：刷完固件网页后台上传JPG，不要脚本下载
