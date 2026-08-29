#!/bin/bash

#在线拉取istore整套源码，直接进openwrt/package
git clone https://github.com/linkease/istore.git temp_istore
mv temp_istore/luci/* ./package/
rm -rf temp_istore

#复制edge主题
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
    echo "OK:Edge主题复制完成"
else
    echo "ERROR:缺失edge主题"
    exit 1
fi

#复制你仓库剩下的其他插件 netwizard fwx系列
cp -r "$GITHUB_WORKSPACE/package/"* ./package/

./scripts/feeds update -a
./scripts/feeds install -a

echo "===开始校验本地包==="
PACK=(
luci-app-store
luci-lib-taskd
luci-lib-xterm
taskd
luci-app-netwizard
)
for p in "${PACK[@]}";do
  if [ ! -d "package/$p" ];then
    echo "MISS: $p"
    ls -la package/
    exit 1
  fi
  echo "OK:$p"
done

echo "diy-part1.sh全部执行完成"
