#!/bin/bash
set -e
# ========== 添加第三方 feeds 源 ==========
# iStore 软件商店（linkease 官方 main 分支）
echo "src-git istore https://github.com/linkease/istore.git;main" >> feeds.conf.default
# 一键上网向导 netwizard（sirpdboy 官方 main 分支）
echo "src-git netwizard https://github.com/sirpdboy/luci-app-netwizard.git;main" >> feeds.conf.default
# DDNS-Go 动态域名（sirpdboy 官方 main 分支）
echo "src-git ddnsgo https://github.com/sirpdboy/luci-app-ddns-go.git;main" >> feeds.conf.default

# 复制edge主题
if [ -d "$GITHUB_WORKSPACE/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/luci-theme-edge-master" package/luci-theme-edge
    echo "OK:Edge主题复制完成"
else
    echo "ERROR:缺失edge主题文件夹"
    exit 1
fi
# ========== 强制安装关键包，防止漏打包 ==========
# iStore 商店 + 依赖
./scripts/feeds install luci-app-store luci-compat
# 上网向导 + 中文
./scripts/feeds install luci-app-netwizard luci-i18n-netwizard-zh-cn
# DDNS-Go + 中文
./scripts/feeds install ddns-go luci-app-ddns-go luci-i18n-ddns-go-zh-cn
# 中文语言包（两个都必须装）
./scripts/feeds install luci-i18n-zh-cn luci-i18n-base-zh-cn
# mwan3 负载均衡 + 中文
./scripts/feeds install mwan3 luci-app-mwan3 luci-i18n-mwan3-zh-cn
# 包管理器 + 网络工具
./scripts/feeds install opkg opkg-update opkg-conf curl wget ca-certificates unzip tar

# ========== 最终验证 ==========
echo "====== 关键包验证 ======"
ls package/luci-theme-kijue/Makefile 2>/dev/null && echo "OK:kijue 主题已就位" || echo "FAIL:kijue 主题缺失"
ls package/feeds/istore/ 2>/dev/null | grep -E "store|compat" && echo "OK:iStore 源已拉取" || echo "FAIL:iStore 源缺失"
ls package/feeds/ddnsgo/ 2>/dev/null | grep -E "ddns" && echo "OK:ddns-go 源已拉取" || echo "FAIL:ddns-go 源缺失"
ls package/feeds/luci/ 2>/dev/null | grep -E "i18n-zh-cn|i18n-base-zh-cn" && echo "OK:中文包已安装" || echo "FAIL:中文包缺失"
echo "====== diy-part1.sh 执行完毕 ======"

# 更新安装feeds
./scripts/feeds update -a
./scripts/feeds install -a

echo "diy-part1.sh执行完毕"
