#!/usr/bin/env bash
# showcase 发布前闸门。任何一条不过 → 退出码非 0，不许推。
#
#   bash scripts/check-publish.sh            检查全部 demo
#   bash scripts/check-publish.sh <目录名>    只检查一个
#
# 为什么是脚本不是 skill 里的一段话：
# 署名会漏、密钥会混进来、charset 会忘——这些都是「不报错、只是错了」的失效。
# 靠人或模型记住无效，必须机械判死。（2026-08-09 实测：charset 漏了导致整页乱码，
# 是渲染截图才发现的；决策记录被 .gitignore 静默吃掉，是 git show 才发现的。）

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

FAIL=0
ok()  { printf '    \033[32m✓\033[0m %s\n' "$1"; }
bad() { printf '    \033[31m✗\033[0m %s\n' "$1"; FAIL=1; }

BYLINE='作者：<b>辛海洋</b>'

check_page() {
  local f="$1" label="$2"
  echo "  [$label] $f"
  [ -f "$f" ] || { bad "文件不存在"; return; }

  # 1. 署名 —— 对外作品的固定要求
  grep -qF "$BYLINE" "$f" && ok "署名存在" || bad "页脚缺少署名：$BYLINE"

  # 2. 发布日期 —— 与署名同为固定要求，格式 YYYY-MM-DD，用 <time datetime>
  if grep -qE '<time datetime="[0-9]{4}-[0-9]{2}-[0-9]{2}">[0-9]{4}-[0-9]{2}-[0-9]{2}</time>' "$f"; then
    ok "发布日期存在（$(grep -oE '<time datetime="[0-9-]{10}"' "$f" | head -1 | grep -oE '[0-9-]{10}')）"
  else
    bad '页脚缺少发布日期，需形如 <time datetime="YYYY-MM-DD">YYYY-MM-DD</time>'
  fi

  # 2b. 页脚不许有免责声明式说明文字 —— 只要作者和日期
  if grep -qE '演示数据说明|不含任何真实学生数据|不携带任何密钥' "$f"; then
    bad "页脚含说明/免责文字，按要求只保留作者与日期"
  else ok "页脚无多余说明文字"; fi

  # 2. charset —— 漏了整页中文变乱码，且构建期零报错
  grep -qiE '<meta[^>]+charset' "$f" && ok "有 charset 声明" \
    || bad "缺 <meta charset=\"utf-8\">，中文会变乱码"

  # 3. 密钥
  if grep -qiE 'sk-[A-Za-z0-9]{16,}|api[_-]?key[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{8,}|password[[:space:]]*[:=]' "$f"; then
    bad "疑似密钥/凭据"
  else ok "无密钥命中"; fi

  # 4. 对内标记与内部文件引用
  if grep -qE '【对内】|TEAM-EVALUATION|IMPROVEMENTS\.md|REVIEW\.md' "$f"; then
    bad "含【对内】标记或内部文件引用"
  else ok "无对内材料"; fi

  # 4b. 源码树路径引用 —— 每个 demo 的源码都在**私有**仓库，公开页里出现这类路径
  #     既是死引用，也等于把私有仓库的结构说出去。2026-08-09 实际漏过一次：
  #     内联 JS 的注释里写了 test/physics-check.js，前面几道闸全过。
  local srcref
  srcref=$(grep -oE '(^|[^A-Za-z0-9/._-])(src|test|tests|vendor|scripts|workspace|dist|node_modules)/[A-Za-z0-9._/-]+' "$f" | head -3)
  if [ -n "$srcref" ]; then
    printf '      %s\n' "$srcref"
    bad "引用了源码仓库里的路径（源码仓库是 private，公开页里是死引用）"
  else ok "无源码树路径引用"; fi

  # 5. 外部请求 —— 公开页面不许连出去（data: 与相对路径放行）
  local ext
  ext=$(grep -oE '(src|href)="https?://[^"]+"' "$f" \
        | grep -vE 'https?://(www\.)?(manim\.community|github\.com)' | head -3)
  if [ -n "$ext" ]; then
    printf '      %s\n' "$ext"
    bad "有指向外部的 src/href（页面应自包含）"
  else ok "无外部资源请求"; fi

  # 6. 体积（GitHub 单文件硬上限 100MB，>25MB 会告警）
  local sz; sz=$(stat -c%s "$f")
  if   [ "$sz" -gt 26214400 ]; then bad "文件 $((sz/1024/1024)) MB，超过 25MB 告警线"
  else ok "体积 $((sz/1024)) KB"; fi
}

echo "== 索引页 =="
check_page "index.html" "索引"

echo
echo "== 各 demo =="
shopt -s nullglob
targets=()
if [ $# -ge 1 ]; then targets=("$1"); else
  for d in */; do
    d="${d%/}"
    [ "$d" = "scripts" ] && continue
    [ -f "$d/index.html" ] && targets+=("$d")
  done
fi

[ ${#targets[@]} -eq 0 ] && echo "  （没有 demo 目录）"

for d in "${targets[@]}"; do
  check_page "$d/index.html" "$d"
  # 7. 索引页必须有指向它的卡片 —— 加了目录忘了挂链接，是同一类静默失效
  if grep -qF "href=\"$d/\"" index.html; then ok "索引页已挂链接"
  else bad "索引页没有指向 $d/ 的卡片"; fi
  echo
done

echo
if [ "$FAIL" = 0 ]; then printf '\033[32m全部通过，可以发布\033[0m\n'; exit 0; fi
printf '\033[31m有检查未通过，不要推送\033[0m\n'; exit 1
