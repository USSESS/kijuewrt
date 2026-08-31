#!/bin/bash
set -e
# ============================================================
#  KiJueWrt 云编译 diy-part1.sh（Edge 主题版）
#  修复点：
#   1) feeds update 移到 feeds install 之前（原脚本顺序是反的，会中断）
#   2) Edge 主题从仓库根目录 luci-theme-edge-master 复制进 package/
#  仓库根目录结构要求：
#    <repo>/
#    ├── .github/workflows/openwrt-builder.yml
#    ├── config.txt / diy-part1.sh / diy-part2.sh
#    └── luci-theme-edge-master/   ← Edge 主题（GitHub 下载 master 解压即得）
# ============================================================

# ---------- 添加第三方 feeds 源 ----------
echo "src-git istore https://github.com/linkease/istore.git;main" >> feeds.conf.default
echo "src-git netwizard https://github.com/sirpdboy/luci-app-netwizard.git;main" >> feeds.conf.default
echo "src-git ddnsgo https://github.com/sirpdboy/luci-app-ddns-go.git;main" >> feeds.conf.default

# ---------- 先更新、再安装全部 feeds（顺序不能反） ----------
./scripts/feeds update -a
./scripts/feeds install -a

# ---------- 复制 Edge 主题到本地 package ----------
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ]; then
  rm -rf package/luci-theme-edge
  cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
  echo "OK:Edge 主题复制完成"
else
  echo "ERROR:缺失 luci-theme-edge-master 文件夹（请把 Edge 主题放到仓库根目录）"
  exit 1
fi

# ---------- 强制安装关键包（防漏打包） ----------
./scripts/feeds install luci-app-store luci-compat
./scripts/feeds install luci-app-netwizard luci-i18n-netwizard-zh-cn
./scripts/feeds install ddns-go luci-app-ddns-go luci-i18n-ddns-go-zh-cn
./scripts/feeds install luci-i18n-zh-cn luci-i18n-base-zh-cn
./scripts/feeds install mwan3 luci-app-mwan3 luci-i18n-mwan3-zh-cn
./scripts/feeds install opkg opkg-update opkg-conf curl wget ca-certificates unzip tar

# ---------- 最终验证 ----------
echo "====== 关键包验证 ======"
[ -f package/luci-theme-edge/Makefile ] && echo "OK:Edge 主题已就位" || { echo "FAIL:Edge 主题缺失"; exit 1; }
ls package/feeds/istore/ 2>/dev/null | grep -qE "store|compat" && echo "OK:iStore 源已拉取" || echo "WARN:iStore 源未确认"
ls package/feeds/ddnsgo/ 2>/dev/null | grep -qE "ddns" && echo "OK:ddns-go 源已拉取" || echo "WARN:ddns-go 源未确认"
ls package/feeds/luci/ 2>/dev/null | grep -qE "i18n-zh-cn|i18n-base-zh-cn" && echo "OK:中文包已安装" || echo "WARN:中文包未确认"
echo "====== diy-part1.sh 执行完毕 ======"
