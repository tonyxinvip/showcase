# showcase

CocoRobo 教育产品原型的**公开演示**。

**在线访问**：https://tonyxinvip.github.io/showcase/

---

## 当前内容

| 演示 | 说明 | 地址 |
|---|---|---|
| 数学动画内容库 | 输入教学主题 → 输出可在课堂播放的数学动画，由 [Manim](https://www.manim.community/) 离线预生成 | [`/math-animation/`](https://tonyxinvip.github.io/showcase/math-animation/) |

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

- **署名（必须）**：页脚要有 `作者：辛海洋`，放在免责声明**之上**、视觉上重一档。
  **这条对所有 demo 生效，不是可选项。**
- **自包含单文件优先**：HTML 里内联 CSS/JS/媒体，不依赖外部 CDN，断网可打开
- **不发出任何外部请求**：没有后端、没有埋点、没有第三方脚本
- **诚实标注**：还没做到的功能要在界面上写明「未接入」，不要用转圈动画假装在工作

署名的标准写法（现有两个页面已按此实现，照抄即可）：

```html
<footer>
  <div class="byline">作者：<b>辛海洋</b></div>
  …免责声明…
</footer>
```

```css
.byline{margin-bottom:10px;font-size:14.5px;color:var(--ink)}
.byline b{font-weight:650}
```

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

七项机械判定：署名 / charset / 密钥 / 【对内】标记 / 外部请求 / 体积 / 索引页有没有挂链接。
**不过就不要推。** 每一项都做过注入测试，确认真的会判死——没响过的闸是假闸。
