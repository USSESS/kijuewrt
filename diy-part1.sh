#!/bin/bash
# 删除 set‑e !!!

cp -r "$GITHUB_WORKSPACE/package" ./

if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
    echo "OK:Edge主题复制完成"
else
    echo "ERROR:缺失edge主题"
    exit 1
fi

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
