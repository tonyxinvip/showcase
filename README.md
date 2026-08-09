# showcase

CocoRobo 教育产品原型的**公开演示**。

**在线访问**：https://tonyxinvip.github.io/showcase/

---

## 当前内容

| 演示 | 说明 | 地址 |
|---|---|---|
| 价层电子对互斥 · 化学 bench | 学生在三维模型上增删配体与孤对，构型按 VSEPR 规则实时重排。判分走规则引擎，不经过大模型 | [`/chemistry-bench/`](https://tonyxinvip.github.io/showcase/chemistry-bench/) |
| 抛体打靶 · 物理 bench | 三个滑块把球打进 42 米外的圈里。物理由方程固定，诊断由确定性规则跑出 | [`/stem-bench/`](https://tonyxinvip.github.io/showcase/stem-bench/) |
| 系谱分析 · 生物 bench | 给一张家系图判断遗传方式。六种方式逐一排除，答错指出矛盾在哪两个人身上；概率用精确有理数算，同一份作答任何时候同一个分 | [`/bio-lab/`](https://tonyxinvip.github.io/showcase/bio-lab/) |
| 数学动画内容库 | 输入教学主题 → 输出可在课堂播放的数学动画，由 [Manim](https://www.manim.community/) 离线预生成 | [`/math-animation/`](https://tonyxinvip.github.io/showcase/math-animation/) |
| 物理实验台 | 老师搭力学实验并出题 → 学生先预测再作答 → 回执码交回老师。基于 [Matter.js](https://github.com/liabru/matter-js)，出题时显示引擎与解析解的偏差 | [`/physics-lab/`](https://tonyxinvip.github.io/showcase/physics-lab/) |

---

## 这个仓库的唯一规矩

**这是一个公开仓库。放进来的任何文件都会被公网访问到。**

加东西之前逐条过：

- [ ] 不含 API key、token、密码、证书
- [ ] 不含真实学生 / 教师 / 客户的个人信息
- [ ] 不含标记为【对内】的材料
- [ ] 不含成本数字、内部分析、人员评价、未公开的商业条款
- [ ] 假数据要像真的，但**必须是假的**

不确定的一律**不要放**，先问。

## 每个演示的形态要求

- **页脚只放两样东西：作者 + 发布日期。必须，且不许加别的。**
  页脚是署名位，不是免责声明位——加说明文字会削弱作品的分量。
  「还没做到什么」应该标在页面**顶部的徽标**里（那是诚实标注），不是堆在页脚。
- **自包含单文件优先**：HTML 里内联 CSS/JS/媒体，不依赖外部 CDN，断网可打开
- **不发出任何外部请求**：没有后端、没有埋点、没有第三方脚本
- **诚实标注**：还没做到的功能要在界面上写明「未接入」，不要用转圈动画假装在工作

页脚的标准写法（现有两个页面已按此实现，照抄即可）：

```html
<footer>
  <div class="byline">作者：<b>辛海洋</b></div>
  <div class="pubdate"><time datetime="2026-08-09">2026-08-09</time></div>
</footer>
```

```css
.byline{font-size:15px;color:var(--ink)}
.byline b{font-weight:650}
.pubdate{margin-top:3px;font-size:13px;color:var(--ink-3)}
```

日期写**该 demo 的发布日**，格式 `YYYY-MM-DD`，用 `<time datetime>` 包起来（可被机器读取）。
内容有实质更新时才改，小修不动。

---

## 加一个新演示

```
showcase/
  index.html            ← 索引页，加卡片指向新目录
  <新演示名>/
    index.html          ← 自包含单页，页脚带署名
```

然后在 `index.html` 里补一张 `.card`，在上面的表格里补一行。

**收尾必须跑闸门**：

```bash
bash scripts/check-publish.sh
```

九项机械判定：署名 / 发布日期 / 页脚无多余文字 / charset / 密钥 / 【对内】标记 / 外部请求 / 体积 / 索引页有没有挂链接。
**不过就不要推。** 每一项都做过注入测试，确认真的会判死——没响过的闸是假闸。
