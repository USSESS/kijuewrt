#!/bin/bash
cd openwrt

# =====自定义固件显示信息=====
sed -i 's/DISTRIB_ID.*/DISTRIB_ID="FanOpenWrt"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_RELEASE.*/DISTRIB_RELEASE="22.03官方版"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION="Github Actions Build Official 22.03"/' package/base-files/files/etc/openwrt_release

# 修改主机名
sed -i "s/uci set system.@system\[0\].hostname='OpenWrt'/uci set system.@system[0].hostname='FanRouter'/" package/base-files/files/bin/config_generate

# 修改LAN IP为10.10.10.1
sed -i 's/uci set network.lan.ipaddr=.*/uci set network.lan.ipaddr='"'"'10.10.10.1'"'"'/' package/base-files/files/bin/config_generate

# Argon自定义壁纸（网络图片，可替换为你自己图片直链）
wget -O package/luci-theme-argon/htdocs/argon/img/bg1.jpg https://p3terx.com/images/avatar.jpg
