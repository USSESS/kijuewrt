#!/bin/bash
cd openwrt

# ==========自定义固件信息==========
sed -i 's/DISTRIB_ID.*/DISTRIB_ID="KiJueWrt"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_RELEASE.*/DISTRIB_RELEASE="1.0.0.1"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION="KiJueWrt    1.0.0.1"/' package/base-files/files/etc/openwrt_release

# 路由器主机名（仅英文）
sed -i "s/uci set system.@system\[0\].hostname='OpenWrt'/uci set system.@system[0].hostname='KiJueWrt'/" package/base-files/files/bin/config_generate

# LAN后台IP 10.10.10.1
sed -i 's/uci set network.lan.ipaddr=.*/uci set network.lan.ipaddr='"'"'10.10.10.1'"'"'/' package/base-files/files/bin/config_generate

# 编译内置背景壁纸，不需要就删除本行
wget -O package/luci-theme-argon/htdocs/argon/img/bg1.jpg https://img.remit.ee/api/file/BQACAgUAAyEGAASHRsPbAAEZyo5qjPTUxnbyC7LbF5vmSOF9u3eSOAACFSgAAg-uaVRlN0GOJvxdPT0E.jpg
