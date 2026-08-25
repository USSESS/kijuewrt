#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 修改默认IP为10.10.10.1
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate

# 修改主机名为 KiJueWrt
sed -i "s/set system.@system\[-1\].hostname=.*/set system.@system[-1].hostname='KiJueWrt'/g" package/base-files/files/bin/config_generate

# 设置SSH登录banner KiJueWrt
cat > package/base-files/files/etc/banner <<'EOF'

 K   K  iii  JJJJJJ   u   u  EEEEE  W   W  RRRR   TTTTT
 K  K    i      J     u   u  E      W   W  R   R    T
 KKK     i      J     u   u  EEEE   W W W  RRRR     T
 K  K    i      J     u   u  E      W W W  R  R     T
 K   K  iii   JJJJ    uuuuu  EEEEE   W W   R   R    T


              KiJueWrt  25.05.1  

EOF

#复制正常banner到救援模式banner
cp package/base-files/files/etc/banner package/base-files/files/etc/banner.failsafe
