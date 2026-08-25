#!/bin/bash
# 切换源码分支为官方OpenWrt 22.03
cd openwrt
git checkout openwrt-22.03

# 添加第三方插件源
cat >> feeds.conf.default <<EOF
src-git argon https://github.com/jerrykuku/luci-theme-argon.git^2.4.6
src-git istore https://github.com/linkease/istore.git
src-git passwall https://github.com/xiaorouji/openwrt-passwall.git
src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git
src-git kenzo https://github.com/kenzok8/openwrt-packages.git
src-git small https://github.com/kenzok8/small.git
EOF

# 更新feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 复制主题、istore到package锁定版本
cp -r feeds/argon/luci-theme-argon package/
cp -r feeds/argon/luci-app-argon-config package/
cp -r feeds/istore/luci-app-store package/

# 注释第三方源，防止后续更新改动
sed -i '/argon\|istore\|passwall\|passwall_packages\|kenzo\|small/s/^/#/' feeds.conf.default

# ======================全部自定义配置挪到这里！======================
# 自定义固件信息 KiJueWrt
sed -i 's/DISTRIB_ID.*/DISTRIB_ID="KiJueWrt"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_RELEASE.*/DISTRIB_RELEASE="1.0.0.1"/' package/base-files/files/etc/openwrt_release
sed -i 's/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION="KiJueWrt    1.0.0.1"/' package/base-files/files/etc/openwrt_release

# 路由器主机名（仅英文）
sed -i "s/uci set system.@system\[0\].hostname='OpenWrt'/uci set system.@system[0].hostname='KiJueWrt'/" package/base-files/files/bin/config_generate

# LAN后台IP 10.10.10.1
sed -i 's/uci set network.lan.ipaddr=.*/uci set network.lan.ipaddr='"'"'10.10.10.1'"'"'/' package/base-files/files/bin/config_generate

# 壁纸不编译内置，注释掉，刷完后台上传
# wget -O package/luci-theme-argon/htdocs/argon/img/bg1.jpg "图片直链"
