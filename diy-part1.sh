#!/bin/bash
set -e

# iStore软件中心源 linkease官方 main分支
echo "src-git istore https://github.com/linkease/istore.git;main" >> feeds.conf.default
# 一键上网设置向导 netwizard 源（sirpdboy 官方适配 24.10/25.12）
echo "src-git netwizard https://github.com/sirpdboy/luci-app-netwizard.git;main" >> feeds.conf.default

# 本地导入仓库内定制Edge主题
if [ -d "$GITHUB_WORKSPACE/package/luci-theme-edge-master" ];then
    cp -r "$GITHUB_WORKSPACE/package/luci-theme-edge-master" package/luci-theme-edge
    echo "本地Edge主题已导入"
else
    echo "警告：本地Edge主题文件夹缺失，跳过复制"
fi

# 更新全部feeds
./scripts/feeds update -a
./scripts/feeds install -a

# ========== 【关键】验证istore源是否真的拉取成功 ==========
echo "====== 检查istore源拉取结果 ======"
ls -la feeds/istore/ 2>/dev/null || echo "❌ feeds/istore/ 目录不存在，源拉取失败！"
ls -la package/feeds/istore/ 2>/dev/null || echo "❌ package/feeds/istore/ 目录不存在，install失败！"

# ========== 【补全】强制安装所有关键包，防止漏打包 ==========
# 说明：set -e 下若某个包在 feeds 中不存在，install 返回非0会直接中断脚本，
# 所以这里全部加 || true 兜底；真正决定"是否编进固件"的是 .config 里的 =y 选项。
# iStore商店 + 强制依赖
./scripts/feeds install luci-app-store || true
./scripts/feeds install luci-compat || true

# 上网向导（js版自带中文，i18n 包若不存在不影响主功能）
./scripts/feeds install luci-app-netwizard || true
./scripts/feeds install luci-i18n-netwizard-zh-cn || true

# 中文语言包（让 LuCI 变中文的核心是 base-zh-cn，必装）
./scripts/feeds install luci-i18n-zh-cn || true
./scripts/feeds install luci-i18n-base-zh-cn || true

# 网络下载工具 + HTTPS证书
./scripts/feeds install curl wget ca-certificates unzip tar || true

# ========== 【最终验证】列出所有已安装的关键包 ==========
echo "====== 关键包安装验证 ======"
ls package/feeds/istore/ 2>/dev/null | grep -E "store|compat" || echo "❌ iStore相关包缺失"
ls package/feeds/luci/ 2>/dev/null | grep -E "i18n-zh-cn|i18n-base-zh-cn" || echo "❌ 中文包缺失"
echo "====== diy-part1.sh 执行完毕 ======"
