#!/bin/bash
set -e

# 写入feeds源 netwizard
echo "src-git netwizard https://github.com/sirpdboy/luci-app-netwizard.git;main" >> feeds.conf.default

# 在线拉取istore整套源码
git clone https://github.com/linkease/istore.git temp_istore
# ✅istore所有组件在仓库内部 package/ 文件夹！！
mv temp_istore/package/luci-app-store ./package/
mv temp_istore/package/luci-lib-taskd ./package/
mv temp_istore/package/luci-lib-xterm ./package/
mv temp_istore/package/taskd ./package/
rm -rf temp_istore

#复制edge主题
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
    echo "OK:Edge主题复制完成"
else
    echo "ERROR:缺失edge主题"
    exit 1
fi

./scripts/feeds update -a
./scripts/feeds install -a

echo "===开始校验istore核心包==="
PACK=(
luci-app-store
luci-lib-taskd
luci-lib-xterm
taskd
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
