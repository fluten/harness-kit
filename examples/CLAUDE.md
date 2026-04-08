# CLAUDE.md

<!-- 区块权限声明
| 区块 | 类型 | 说明 |
|------|------|------|
| 项目信息 | 🔓 生成区 | Claude Code 根据讨论内容填写 |
| 文件体系 | 🔒 锁定区 | 每个项目一致，不可更改 |
| 自动化行为 | 🔒 锁定区 | 每个项目一致，不可更改 |
| 代码规范 | 🔓 生成区 | Claude Code 根据技术栈生成 |
| 当前 Session 上下文 | 🔓 生成区 | 每次 session 更新 |
-->

<!-- 🔓 START 生成区：项目信息 -->
## 项目信息
- 项目名：ChatLens
- 一句话描述：面向香港市场的 B2B AI 对话分析平台，帮助企业从客服/销售对话中提取可执行洞察
- 技术栈：React 18 + TypeScript + Tailwind CSS（前端）/ Python 3.11 + FastAPI（后端）/ PostgreSQL（数据库）
- 仓库：github.com/fluten/ChatLens
<!-- 🔓 END 生成区：项目信息 -->

<!-- 🔒 START 锁定区：文件体系 -->
## 文件体系

本项目使用以下 .md 文件管理开发过程，你必须在开发中维护它们：

| 文件 | 何时读取 | 何时修改 | 权限 |
|------|----------|----------|------|
| SPEC.md | 开始任何功能开发前 | 需求变更时 | ⚠️ 需用户确认 |
| TODO.md | 每次 session 开始时 | 新增/完成/调整任务时 | ✅ 自主维护 |
| ISSUES.md | 修 bug 或遇到问题时 | 发现新问题、状态变更时 | ✅ 自主维护 |
| ARCHITECTURE.md | 涉及跨模块改动时 | 新增模块或架构调整时 | ⚠️ 需用户确认 |
| PROGRESS.md | 每次 session 开始时 | 每完成一个 TODO 项时 | ✅ 自主维护 |
| DECISIONS.md | 做技术选型或架构决策时 | 新决策产生或状态变更时 | ⚠️ 需用户确认 |
| SCHEMA.md | 涉及数据读写时 | 表结构或数据模型变更时 | ⚠️ 需用户确认 |
| DESIGN.md | 涉及界面开发时 | 视觉/交互规范变更时 | ⚠️ 需用户确认 |
| docs/spec/*.md | 对应模块开发时 | 对应模块需求变更时 | ⚠️ 需用户确认 |

### 权限说明
- ✅ **自主维护**：TODO.md、ISSUES.md、PROGRESS.md 为过程文件，可直接修改
- ⚠️ **需用户确认**：SPEC、ARCHITECTURE、DECISIONS、SCHEMA、DESIGN 为决策文件，修改前必须先说明改动内容并获得用户同意
<!-- 🔒 END 锁定区：文件体系 -->

<!-- 🔒 START 锁定区：自动化行为 -->
## 自动化行为（必须遵守）

### PROGRESS 更新
每完成一个 TODO.md 中的任务项：
- 将该项标记为 `[x]`
- 在 PROGRESS.md「最近完成」区追加：`- [{{日期}}] {{任务描述}} {{关联 issue 编号（如有）}}`

### ISSUES 联动
- 开始修复某 issue → 状态从 🔴待处理 改为 🟡处理中
- 代码修复完成 → 状态从 🟡处理中 改为 🟢已修复
- 用户确认验证通过 → 状态改为 ✅已验证
- TODO.md 中引用 issue 使用编号，如 `- [ ] 修复 BUG-AUTH-001`
- 开发中发现新问题，主动在 ISSUES.md 登记

### ISSUES 编号规则
- 格式：`类型-模块-序号`（如 BUG-AUTH-001、FEAT-DASH-003）
- 类型：BUG / DEBT / QUESTION / LIMIT / PERF / FEAT
- 模块名使用项目内约定的缩写，全局性问题用 GLOBAL
- 序号在同类型-同模块下递增

### SPEC 拆分提醒
当 SPEC.md 超过 300 行时：
- 主动提醒用户拆分
- 拆分后 SPEC.md 保留项目概述 + 模块导航链接
- 子文档路径：`docs/spec/{{模块名}}.md`

### 跨模块检查
当任务涉及多个模块时，必须先读取所有相关 spec 文件再动手写代码。

### DECISIONS 记录
做出技术选型或架构决策时，主动在 DECISIONS.md 对应模块下登记。

### 📊 快速状态 头块（自动维护）
TODO.md / ISSUES.md / PROGRESS.md 顶部含「📊 快速状态」头块。这些头块由 AI 自动维护，是 LLM 快速判断"要不要读这个文件"的入口。

**读取这些文件时**：
- 先扫顶部「📊 快速状态」（≤ 10 行）
- 根据当前任务上下文判断是否需要继续读 body
  - 例：当前任务不涉及 ISSUES 头块的「活跃模块」且非调试类 → 可不读 body
  - 例：当前任务正是 TODO 头块「下一步」字段 → body 也不必全读
- **不强制阅读顺序**——LLM 自主判断

**修改这些文件 body 后**：
- 必须按文件底部 🔒 锁定区中的「📊 快速状态 重建算法」**整体重写**头块
- 算法是纯机械的（count / scan / extract），禁止凭印象编写
- 禁止增量修改头块字段（避免漂移）

### 🔴 不可逆决策清单（DECISIONS 顶部禁区）
DECISIONS.md 顶部有「🔴 不可逆决策清单」区块，列出所有被标记为 🔴 不可逆的决策。

- 任何想修改或推翻 DECISIONS.md 已确定决策的动作前，**必须先核对此清单**
- 清单中的决策**禁止建议推翻**（即使用户提出，也要先反向求证）
- 修改 DECISIONS.md body 后，按文件底部「🔴 不可逆决策清单 重建算法」整体重写该清单
<!-- 🔒 END 锁定区：自动化行为 -->

<!-- 🔓 START 生成区：代码规范 -->
## 代码规范

### 通用
- 使用中文注释
- commit message 格式：`type(scope): description`（如 `feat(dashboard): add conversation list`）
- 禁止：硬编码密钥、忽略错误处理、跳过 TODO 中未标记的步骤

### 前端（React + TypeScript）
- 组件使用函数式组件 + Hooks
- 组件命名 PascalCase，文件名与组件名一致
- 样式使用 Tailwind CSS utility classes
- 状态管理使用 Zustand
- 类型定义放在 `src/types/` 下统一管理
- 每次修改后运行 `npm run lint`

### 后端（Python + FastAPI）
- 类型注解必须完整
- API 路由按模块分文件，放在 `app/routers/`
- 数据库操作使用 SQLAlchemy ORM
- 每个 endpoint 都有 Pydantic schema 做入参校验
- 每次修改后运行 `pytest tests/`

### 模块缩写约定
| 模块 | 缩写 |
|------|------|
| 认证登录 | AUTH |
| 数据看板 | DASH |
| 对话分析 | CONV |
| 报告生成 | RPT |
| 数据导入 | IMP |
| 全局/通用 | GLOBAL |
<!-- 🔓 END 生成区：代码规范 -->

<!-- 🔓 START 生成区：当前 Session 上下文 -->
## 当前 Session 上下文
- 上次做到：PRD 已完成，准备开始数据生成和前端搭建
- 当前目标：项目初始化，搭建基础框架
- 注意事项：这是秋招作品集项目，优先做出可演示的 Demo
<!-- 🔓 END 生成区：当前 Session 上下文 -->
