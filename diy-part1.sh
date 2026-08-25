#!/bin/bash
# 切换源码到官方OpenWrt 22.03稳定分支
cd openwrt
git checkout openwrt-22.03

# 添加第三方插件源
cat >> feeds.conf.default <<EOF
src-git argon https://github.com/jerrykuku/luci-theme-argon.git^2.4.6
src-git istore https://github.com/linkease/istore.git
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
EOF

./scripts/feeds update -a
./scripts/feeds install -a

# 将主题、应用商店复制进package锁定，防止更新覆盖
cp -r feeds/argon/luci-theme-argon package/
cp -r feeds/argon/luci-app-argon-config package/
cp -r feeds/istore/luci-app-store package/

# 注释第三方源，锁定版本不再拉新
sed -i '/argon\|istore\|kenzo\|small/s/^/#/' feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
