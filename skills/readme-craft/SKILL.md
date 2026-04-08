---
name: readme-craft
description: |
  生成视觉精致、结构清晰、对 LLM 与人类双友好的开源项目 README。遵循 harness-kit README 的设计模板：居中 hero + 徽章行、可选双语 details 折叠、Problem/Solution/Workflow/Principles/Reference 经典结构、Mermaid 流程图统一配色规范、反营销的克制语气、强 LLM 可读性。当用户说"帮我写 README"、"为这个项目生成 README"、"整理 README"、"重写 README"、"把项目介绍写成 README"时触发。
---

# readme-craft — 开源项目 README 设计 Skill

把一个项目的核心信息组织成一份**视觉精致 + 结构清晰 + LLM 友好**的 README，遵循经过验证的章节模板和视觉规范。不是给"任意 README"用的——是为**开源工具/框架/skill/模板类项目**优化的写作 skill。

---

## 触发条件

用户希望为一个项目生成、整理或重写 README，常见触发语：
- "帮我写 README" / "为这个项目生成 README"
- "整理一下 README" / "重写 README"
- "把项目介绍写成 README"
- "我新做了个项目，README 怎么写"

## 输入

生成 README 之前，必须收集以下信息（缺失就主动问）：

### 必填
1. **项目名 + GitHub 仓库地址**（如 `fluten/harness-kit`，决定徽章链接和 clone 命令）
2. **一句话定位**（≤ 20 字，会作为 hero 的 h3 tagline）
3. **解决的核心问题**（用户痛点，会变成 `## Problem` 章节）
4. **核心机制 / 解决方案**（项目怎么解决的，会变成 `## Solution`）
5. **项目类型**：`库 / 工具 / 框架 / Skill / 模板 / SaaS Demo / 其他`
6. **作者 GitHub username**（用于 author 徽章 + footer 署名）

### 可选（影响章节生成）
7. **是否双语**：是 / 否（若是，默认哪种语言可见）
8. **是否有可视化的工作流**：是 → 生成 Mermaid 工作流图；否 → 跳过 Workflow 章节
9. **是否有 example 可展示**：是 → 加 Example 章节 + 免责声明；否 → 跳过
10. **是否有多个文件需要 file reference**（框架/skill 类项目通常有）：是 → 加 File Reference；否 → 跳过
11. **核心技术栈**（决定徽章里要不要加 Python/Node/Markdown 之类）
12. **目标用户的运行环境**（决定 install 章节怎么写：CLI / npm / pip / git clone / Releases 下载）

---

## 输出

一个 `README.md` 文件，放在项目根目录。如果用户要双语，则中英两版合并在同一个 README.md 中（默认语言可见，另一种语言用 `<details open>` 折叠）。

---

## README 标准结构

按以下顺序组织章节。**带 ★ 的必选**，其余按项目特性按需取舍：

| 顺序 | 章节 | 必选 | 何时需要 |
|---|---|---|---|
| 1 | 居中 Hero（标题 + 徽章 + 标语 + 简介 + 引言） | ★ | 总是 |
| 2 | 跨语言跳转链接 | — | 双语项目 |
| 3 | `## The Problem` / `## 痛点` | ★ | 总是（除非纯工具类） |
| 4 | `## The Solution` / `## 解决方案` | ★ | 总是 |
| 5 | `## Workflow` / `## 工作流`（Mermaid 图） | — | 有可视化流程时 |
| 6 | `## What Gets Generated` / `## Features` | ★ | 总是（标题按项目类型换） |
| 7 | `## Quick Start` / `## 快速开始` | ★ | 总是 |
| 8 | `## Key Design Principles` / `## 核心设计原则` | — | 框架/工具类强烈推荐 |
| 9 | `## Example` / `## 示例` | — | 有真实 example 时 |
| 10 | `## File Reference` / `## 文件参考` | — | 多文件框架 |
| 11 | `## Philosophy` / `## 设计哲学` | — | 有强观点的项目 |
| 12 | `## Contributing` / `## 贡献` | ★ | 总是 |
| 13 | Footer（作者署名 + 跨语言链接） | ★ | 总是 |
| 14 | 双语折叠区（另一种语言的完整内容） | — | 双语项目 |

---

## 各章节写作规则

### 1. 居中 Hero 区 ★

**结构**（自上而下，每行用空行隔开以让 markdown 在 `<div>` 里正常渲染）：

````markdown
<a id="top"></a>

<div align="center">

# {{emoji}} {{Project Name}}

<a href="#chinese-version">🇨🇳 中文文档</a>

![Badge1](url) ![Badge2](url) ... [![Author](url)](https://github.com/{{user}})

### {{一句话标语}}

{{2-3 句的项目简介，描述项目是什么 + 为谁服务 + 凭什么不一样}}

<i>"{{一句精炼的金句，可以是项目核心洞察}}"</i><br>
<sub>— {{出处或归属}}</sub>

</div>
````

**关键规则**：
- 用 `<div align="center">` 包裹，**不要用 markdown 内置居中**（不存在）
- 标题前留一个 `<a id="top"></a>` 锚点，方便其他地方跳回
- 标语用 `### h3`，不要用 `**bold**`——h3 在居中布局里更有 hero 区的视觉重量
- 引言用 `<i>...</i><br><sub>—...</sub>` **而不是 markdown 的 `>` 块引用**——`>` 在 `<div align="center">` 里不会跟着居中
- 跨语言链接放在标题正下方，用 `<a>` 而非 `[]()`，因为 `<div>` 内 markdown 解析有时会失效

### 2. 跨语言跳转链接

英文版（默认可见）头部加：
```html
<a href="#chinese-version">🇨🇳 中文文档</a>
```
中文版（折叠区内）头部加：
```html
<a href="#top">🇬🇧 English</a>
```
两个锚点：
- `<a id="top"></a>` 在文件最顶（英文版之上）
- `<a id="chinese-version"></a>` 在中文版的 `<details>` 之上

### 3. `## The Problem` / `## 痛点` ★

**模式**：用一段 hook + **编号列表** 复现读者经历过的痛感，最后用 **加粗结论句** 点出根因。

````markdown
## The Problem

You've been here before:

1. {{第一步小痛}}
2. {{逐步升级}}
3. {{核心痛点}}
4. {{延伸代价}}
5. {{循环往复}}

**The root cause isn't X. It's Y.**
````

不用解释项目本身，**只描述痛**。读者要先认领这个痛，才会想知道解药。

### 4. `## The Solution` / `## 解决方案` ★

**模式**：一段总览 + 一张结构化表格展示核心机制。

````markdown
## The Solution

{{1-2 句话解释项目本质，用类比让人秒懂}}

**Two skills, one workflow:** ← 或者其他能压成一句话的核心结构

| {{机制} | What it does | When to use |
|---|---|---|
| ... | ... | ... |
````

表格胜过散文：让读者一眼看到"这个项目由几块组成 + 每块在做什么"。

### 5. `## Workflow` / `## 工作流`（Mermaid 图）

如果项目有可视化的工作流（数据流、调用链、生成链路等），用 Mermaid 流程图。**配色必须遵循下方"Mermaid 配色规范"**。

放在 `## The Solution` 之后、`## What Gets Generated` 之前。

如果项目本身没有"流程"概念（比如纯库），**跳过本章节**——不要硬画一个稀薄的流程图。

### 6. `## What Gets Generated` / `## Features` ★

**模式**：用**分级表格**展示项目"长什么样"。

如果是生成器/框架类项目，标题用 "What Gets Generated"，按"必选 / 按需 / 触发"分三张表：

````markdown
## What Gets Generated

### Always generated
| File | Purpose |
|---|---|
| ... | ... |

### Generated when needed
| File | Condition | Purpose |
|---|---|---|
| ... | ... | ... |

### Created during development
| File | Trigger | Purpose |
|---|---|---|
| ... | ... | ... |
````

如果是工具类项目，改用 `## Features`，单张表或 bullet 列表。

**末尾加一段反思**：解释"为什么不一开始全生成"或"为什么这么轻"——用反问语气展示设计取舍。

### 7. `## Quick Start` / `## 快速开始` ★

**子章节排序按用户优先级**（命令行 > 手动 > 集成）：

````markdown
## Quick Start

### Install via command line (recommended)
```bash
# {{说明这个命令做什么}}
mkdir -p ~/.somewhere
git clone ... /tmp/project
cp -r /tmp/project/payload ~/.somewhere/
rm -rf /tmp/project
```

> {{重要提示，比如"必须在 git 仓库根目录执行"}}

### Manual install (for {{some target audience}})
1. ...
2. ...

### For {{other AI tools / other env}}
1. ...
````

**铁律**：
- 命令行块要可以**直接复制运行**——别用 `{{占位符}}`，用具体路径
- 命令前用 `# ` 注释解释做什么
- `>` 引用块给重要提示（路径要求、前置条件）
- 不要写"虚拟环境激活、安装依赖、设置环境变量"这种通用废话——直接给可执行命令

### 8. `## Key Design Principles` / `## 核心设计原则`

强烈推荐框架/工具类项目加上。每条原则用 `### h3` + 1-3 段说明 + 可选代码块/示例。

每条原则的内部结构：
1. **是什么**：一句话定义
2. **为什么**：背后的取舍 / 解决了什么问题
3. **怎么用**：可选的代码示例 / Mermaid 图

参考 harness-kit README 的 5 条原则（LLM-readability / Locked vs Generated / Process vs Decision / Auto-split / Self-maintaining triage headers）作为示范。

### 9. `## Example` / `## 示例`

如果有真实 example 文件，列出来，并**必须加免责说明**（用 `>` 块引用 + ⚠️）：

````markdown
## Example: {{Example Name}}

The `examples/` directory contains a complete set of files for **{{name}}** — a {{description}}. See how each template looks when filled with real project data.

> ⚠️ **About this example**
> - **{{Caveat 1，比如示例的浅度}}**
> - **{{Caveat 2，比如什么是为了演示强制做的}}**
> - It's here to show what filled-in templates *look like structurally* — **not what your final output would be**
````

不要让 example 看起来像项目"上限"——读者会拿它和自己的需求对照，被吓退。

### 10. `## File Reference` / `## 文件参考`

多文件项目（比如 harness-kit 这种生成多个 .md 的框架）必加。每个文件用 `<details>` 折叠：

````markdown
<details>
<summary><b>FILE.md</b> — {{角色}}</summary>

{{1-2 段描述：包含什么字段 / 如何被使用 / 关键设计点}}

{{如果文件有特殊机制（如自动维护的头块），用一段加粗的说明}}
</details>
````

### 11. `## Philosophy` / `## 设计哲学`

可选。如果项目有强观点（比如反对某种主流做法），用一个**编号信念列表**展示。每条信念粗体开头 + 一句解释。

```markdown
## Philosophy

Harness Kit is built on three beliefs:

1. **{{信念 1}}** {{解释}}
2. **{{信念 2}}** {{解释}}
3. **{{信念 3}}** {{解释}}
```

### 12. `## Contributing` / `## 贡献` ★

简短一句邀请，**不要列贡献规范**（贡献规范应该在 CONTRIBUTING.md 里）。

````markdown
## Contributing

Found a better way? Have a feature you wish existed? PRs welcome.
````

### 13. Footer ★

````markdown
---

**Built by [{{Author}}](https://github.com/{{user}})** — {{一句作者背景，可以幽默}}.
````

不要写"Made with ❤️"或"Star this repo if you like it"——克制。

### 14. 双语折叠区

如果项目要双语，把另一种语言的**完整内容**放在文件末尾的 `<details open>` 里：

````markdown
---

<a id="chinese-version"></a>

<details open>
<summary><b>🇨🇳 中文文档 / Chinese Version</b></summary>

<br>

{{完整的另一种语言版本，包括居中 hero、所有章节、所有表格、所有 Mermaid 图}}

</details>
````

**关键**：
- 用 `<details open>` 让默认展开（避免读者点开才能看到）
- 但仍然把英文（默认语言）放在外层——这样英文是第一眼看到的内容
- 中文版**不重复徽章**（已经在英文头部出现过）
- 中文版的 Mermaid 图、表格内容**全部都要翻译**（不是只翻译 prose）

---

## 视觉规范

### 徽章 (shields.io)

**推荐顺序**（左到右）：
1. License (`License-MIT-yellow`)
2. 技术标识 (`Made%20with-Markdown-1f425f` / `Python-3.11-blue` / etc.)
3. 兼容性 (`Claude%20Code-Compatible-blue`)
4. 项目类型 (`Claude%20Code-Skill-D97757?logo=anthropic&logoColor=white`)
5. Author (`Author-{{user}}-181717?logo=github&logoColor=white`，**包成 link** `[![](url)](https://github.com/{{user}})`)

**禁止徽章**：
- ❌ Stars / Forks 计数（虚荣指标，且会因刷新延迟显得过期）
- ❌ Build status（除非真有 CI）
- ❌ Coverage（除非真测了）
- ❌ "Made with ❤️"
- ❌ "Awesome" badges 互相吹捧

**徽章 logo 颜色**：用品牌色，例如：
- Anthropic / Claude → `D97757`
- GitHub → `181717`
- Markdown → `1f425f`

### Mermaid 配色规范

**所有 Mermaid 图都用 `style 节点名 fill:#XXX,stroke:#YYY,stroke-width:Zpx,color:#000` 显式设色**，**永远加 `color:#000`**（避免暗色模式下文字看不清）。

#### 工作流图配色

| 节点类型 | fill | stroke | width | dash | 用途 |
|---|---|---|---|---|---|
| 🟡 起点 | `#FEF3C7` | `#F59E0B` | 2px | — | 人的输入 / session 起点 |
| 🔵 工具 | `#DBEAFE` | `#3B82F6` | 2px | — | Skill / 命令 / 动作 |
| 🟣 核心产物 | `#EDE9FE` | `#8B5CF6` | 2px | — | 文件、规格、SPEC |
| 🟪 派生产物 | `#F5F3FF` | `#A78BFA` | 1px | `4 4` | 拆分子文档等 |
| ⚪ 普通输出 | `#F1F5F9` | `#64748B` | 1px | — | 一般生成的文件 |
| ⚪ 可选输出 | `#F8FAFC` | `#94A3B8` | 1px | `4 4` | 按需生成 |
| 🟢 终点 | `#DCFCE7` | `#22C55E` | 2px | — | AI Agent / 最终成果 |
| 🔴 触发分支 | `#FEF2F2` | `#FCA5A5` | 1px | `4 4` | 错误/bug 类触发 |
| 🟨 决策分支 | `#FFFBEB` | `#FCD34D` | 1px | `4 4` | 决策类触发 |
| 🟩 续接分支 | `#F0FDF4` | `#86EFAC` | 1px | `4 4` | 状态/续接类触发 |

#### 决策流程图配色

| 节点类型 | fill | stroke | 用途 |
|---|---|---|---|
| 🟡 起点 | `#FEF3C7` | `#F59E0B` | "AI 接到任务"等入口 |
| 🟢 终点 | `#DCFCE7` | `#22C55E` | "完成"等出口 |
| 🟣 关键观察 | `#EDE9FE` | `#8B5CF6` | "扫顶部头块"等核心动作 |
| 🟨 判断节点 | `#FFFBEB` | `#D97706` | `{}` 形状的菱形决策 |
| 🔵 happy path | `#DBEAFE` | `#3B82F6` | "跳过 = 省 token" 等好结果 |
| 🔴 强制动作 | `#FEE2E2` | `#EF4444` | "必须重建头块"等强制路径 |
| ⚪ 普通动作 | `#F1F5F9` | `#64748B` | 中性动作 |

#### 节点形状语义
- `([Pill])` → 角色 / 起点终点（人、AI Agent、状态）
- `[/Slash/]` → Skill / 工具调用
- `[Square]` → 文件 / 文档 / 普通动作
- `{Diamond}` → 决策 / 判断节点

#### 边语义
- 实线 `-->` → 主流程、必经路径
- 虚线 `-..->` 带 label → 条件触发、可选路径、按需生成

### Emoji 使用

**作为结构化标记使用**（鼓励）：
- 📊 快速状态 / 状态总览
- 🔴🟡🟢✅ 状态色码
- ⚠️ 警告
- 🤖 给 AI 看的注释
- 🔒 锁定区
- 🔓 生成区
- 💬 待讨论
- 📄📘📋📂 文件类
- 🇨🇳🇬🇧 语言

**作为正文装饰**（**禁止**）：
- ❌ 🎉 ✨ 🚀 🔥 💯 等"庆祝/增强"emoji
- ❌ "Built with ❤️"
- ❌ 标题里随便加 emoji 当 prefix
- ❌ 一段话里多个无功能 emoji

**hero 区的项目标题**可以加一个图标 emoji（如 `🔧 Harness Kit`），但只能 1 个。

### 代码块

- **永远带语言提示** `​```bash` `​```python` `​```markdown`
- **bash 命令前加 `# ` 注释** 解释做什么
- **多行命令用具体路径**，不要 `{{placeholder}}`（这是 README，不是模板）
- **嵌套 markdown** 用 4-backtick 围栏：` ```` ``` ` 内层 ` ``` ` 外层

### 表格

- 第一列 bold 或 code 包裹，让读者扫描时能立刻定位行
- 表头不超过 4 列（移动端友好）
- 单元格内容**短**，长内容拆到下一段或 details

### 引用块 `>`

- 用于**警告、提示、免责声明**
- ⚠️ 开头表示警告，💡 表示提示
- 不要用 `>` 写大段散文（容易当成 quote 而不是 callout）

---

## 双语处理

### 决策点
1. **要不要双语**：问用户。如果项目预期面向中英双语社区，强烈推荐双语
2. **默认语言**：通常英文是默认（GitHub 国际可见），中文用 `<details open>` 折叠
3. **同步性**：每个章节都要两版完整对应，**禁止只翻译标题不翻译正文**

### 物理结构
- 同一份 README.md 文件
- 默认语言（如英文）在外层
- 另一种语言（如中文）在文件末尾的 `<details open>` 内
- 顶部双向跳转锚点

### 翻译原则
- **意译为主**，不要逐字翻译。中文要像中文，不要"翻译腔"
- **代码/命令保持原样**（README 是技术文档，命令不需要本地化）
- **Mermaid 图节点文本翻译**，但保留同样的结构和颜色
- **表格内容全部翻译**（包括状态码、字段名的中文释义）

---

## 写作语气

### 必须遵守
1. **直接，零绪论**：不要"在如今 AI 飞速发展的时代..."这种开场。第一句话就是项目本身
2. **反营销**：不写"革命性"、"颠覆"、"完美"、"无与伦比"。事实陈述，让读者自己得结论
3. **承认局限**：example 是简化的就说简化、9 个文件是强制生成的就说强制
4. **避免 hype 词汇**：avoid "amazing"、"powerful"、"seamless"、"effortless"、"intuitive" 这类形容词
5. **show, don't tell**：与其说"非常好用"，不如展示一个 3 行的命令例子
6. **第二人称对话感**：写"You've been here before:" 比 "Many developers face..." 更亲

### 反面典型（**禁止**）
- ❌ "Welcome to our amazing project!"
- ❌ "🚀 The future of X is here!"
- ❌ "Beautifully designed, lightning-fast, blazing-edge..."
- ❌ "We are excited to announce..."
- ❌ "Made with ❤️ by..."
- ❌ "Star us if you like the project! ⭐"

---

## 反 Pattern 清单

| 反 pattern | 为什么不要 |
|---|---|
| 在标题里塞 4-5 个 emoji | 视觉噪音，看不清重点 |
| 第一段写"项目简介"散文 | 信息密度低，读者会跳过 |
| Features 列 20 项 bullet | 过度承诺，读者疲劳 |
| 截图大段大段堆 | 加载慢、移动端体验差。Mermaid + 表格永远优先 |
| ASCII 流程图 | 不同字体下错位，且 LLM 解析不可靠。用 Mermaid |
| 居中对齐用 `<center>` 标签 | HTML5 已废弃，用 `<div align="center">` |
| 把 License 同时写在徽章和章节里 | 重复。徽章已经表明，删掉章节 |
| 双语用两个文件 (`README.md` + `README_CN.md`) | 链接管理麻烦、SEO 分散、星标分散。用单文件 + `<details>` |
| 在 commit / PR / README 自夸 | 显得功利。事实陈述足够 |
| 写"v1.0、v2.0 路线图" | 多数项目永远做不到。删 |
| 列依赖版本号 | 让 README 频繁过期。让 package.json / requirements.txt 说话 |

---

## 执行流程

1. **收集输入**（如果用户已经讨论过项目，直接从对话提取；否则主动询问"必填"6 项 + 看情况问"可选"6 项）
2. **判断章节范围**：
   - 项目类型决定要不要 What Gets Generated / Features
   - 有无流程决定要不要 Mermaid 工作流图
   - 有无 example 决定要不要 Example 章节
   - 多文件项目决定要不要 File Reference
   - 是否双语决定要不要复制一份到 `<details open>`
3. **写英文版（默认语言）**，按"README 标准结构"顺序生成所有适用章节
4. **生成 Mermaid 图**（如适用），严格按"Mermaid 配色规范"配色
5. **写中文版**（如双语），完整对应英文每个章节、每张表、每个 mermaid，放进 `<details open>`
6. **应用"写作语气"和"反 pattern"清单**做最后一遍审查
7. **输出 README.md** 到项目根目录
8. **告知用户**：建议接下来如何使用——`git add README.md && git commit && git push`，但**不要主动 commit**（除非用户明说）

---

## 与 harness-kit 内其他 skill 的关系

- **spec-gen**：负责生成 SPEC.md（产品需求），与 README 是两件事——SPEC 是给 AI 看的开发上下文，README 是给人/搜索引擎看的项目门面
- **project-init**：负责生成 CLAUDE.md / TODO.md 等 AI 协作文件，**不生成 README**
- **readme-craft**（本 skill）：负责生成 README.md，**独立于上述两个 skill 的链路**

也就是说：
- 用 spec-gen + project-init 来"让 AI 知道这个项目"
- 用 readme-craft 来"让人/GitHub 访客知道这个项目"
- 三个 skill 解决三个不同的对外/对内沟通问题，互不替代

---

## 参考

`README.md`（本仓库根目录）就是按本 skill 完整规范写的，可以作为**唯一权威 example**。任何疑问回去看那份 README 怎么处理的。
