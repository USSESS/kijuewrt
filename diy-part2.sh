#!/bin/bash
cd openwrt

# 修改固件版本信息
sed -i 's/DISTRIB_ID.*/DISTRIB_ID="My2203"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_RELEASE.*/DISTRIB_RELEASE="22.03定制版"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION="GitHub Actions编译官方22.03"/' package/base-files/files/etc/openwrt_release

# 修改路由器主机名
sed -i "s/uci set system.@system\[0\].hostname='OpenWrt'/uci set system.@system[0].hostname='MyRouter'/" package/base-files/files/bin/config_generate

# 修改LAN网关IP为10.10.10.1
sed -i 's/uci set network.lan.ipaddr=.*/uci set network.lan.ipaddr='"'"'10.10.10.1'"'"'/' package/base-files/files/bin/config_generate

# Argon登录页壁纸（网络图片，不用上传图片）
wget -O package/luci-theme-argon/htdocs/argon/img/bg1.jpg https://p3terx.com/images/avatar.jpg
