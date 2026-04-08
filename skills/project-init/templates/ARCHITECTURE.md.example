# ARCHITECTURE.md

<!-- 区块权限声明
| 区块 | 类型 | 说明 |
|------|------|------|
| 全文 | 🔓 生成区 | Claude Code 根据讨论内容填写 |
| 全文权限 | ⚠️ 决策文件 | 修改前必须获得用户确认 |
-->

<!-- 🔓 START 生成区：全文（⚠️ 决策文件：修改需用户确认） -->

## 系统概述

ChatLens 采用前后端分离架构。前端 React SPA 通过 REST API 与后端 FastAPI 通信，后端连接 PostgreSQL 数据库，NLP 分析通过调用外部 LLM API 实现。

## 系统架构关系

- Frontend(React 18 + TypeScript + Tailwind) --REST API(JSON)--> Backend(FastAPI + SQLAlchemy)
- Backend --SQLAlchemy ORM--> Database(PostgreSQL 15)
- Backend --HTTP API Call--> LLM_Provider(DeepSeek 或 Claude)
- Frontend 不直接访问 Database
- Frontend 不直接访问 LLM_Provider
- 所有前端请求经过 JWT 鉴权中间件

## 模块划分

### AUTH（认证登录）
- **职责**：用户注册、登录、JWT 签发与验证
- **对外接口**：POST /api/auth/register, POST /api/auth/login, GET /api/auth/me
- **依赖**：无
- **被依赖**：所有需要鉴权的模块（IMP, CONV, DASH, RPT）
- **关键文件**：frontend/src/pages/Login/, backend/app/routers/auth.py, backend/app/services/auth.py

### IMP（数据导入）
- **职责**：CSV/JSON 文件上传、字段映射、数据入库
- **对外接口**：POST /api/import/upload, GET /api/import/datasets
- **依赖**：AUTH（鉴权）
- **被依赖**：CONV（分析需要数据）
- **关键文件**：frontend/src/pages/Import/, backend/app/routers/import_.py, backend/app/services/importer.py

### CONV（对话分析）
- **职责**：调用 LLM API 对对话进行情感分析、意图分类、关键词提取、质量评分
- **对外接口**：POST /api/analysis/run, GET /api/conversations/{id}
- **依赖**：AUTH（鉴权）, IMP（数据来源）
- **被依赖**：DASH（看板展示分析结果）, RPT（报告引用分析结果）
- **关键文件**：frontend/src/pages/Conversations/, backend/app/routers/analysis.py, backend/app/services/analyzer.py

### DASH（数据看板）
- **职责**：汇总分析结果，可视化展示趋势、分布、排名
- **对外接口**：GET /api/dashboard/overview, GET /api/dashboard/trends
- **依赖**：AUTH（鉴权）, CONV（分析结果）
- **被依赖**：无
- **关键文件**：frontend/src/pages/Dashboard/, backend/app/routers/dashboard.py

### RPT（报告生成）
- **职责**：生成周报/月报 PDF（MVP 不包含，后续版本）
- **对外接口**：POST /api/reports/generate
- **依赖**：AUTH, CONV, DASH
- **被依赖**：无
- **关键文件**：待创建

## 模块依赖关系

- AUTH 被依赖于：IMP, CONV, DASH, RPT
- IMP 被依赖于：CONV
- CONV 被依赖于：DASH, RPT
- DASH 被依赖于：无（叶子节点）
- RPT 被依赖于：无（叶子节点）
- 依赖方向：AUTH → IMP → CONV → DASH/RPT（单向，无循环依赖）

## 数据流

### 流程一：数据导入到分析
用户上传 CSV → IMP 解析并写入 conversations + messages 表 → 用户触发分析 → CONV 逐条读取对话 → 调用 LLM API → 分析结果写入 analyses 表 → DASH 读取 analyses 表展示

### 流程二：看板浏览
用户打开看板 → 前端请求 /api/dashboard/overview → Backend 对 analyses 表做聚合查询（GROUP BY sentiment, intent, 时间） → 返回统计 JSON → 前端 Recharts 渲染图表

## 目录结构

- ChatLens/frontend/src/components/ — 通用 UI 组件
- ChatLens/frontend/src/pages/Login/ — 登录页
- ChatLens/frontend/src/pages/Dashboard/ — 看板页
- ChatLens/frontend/src/pages/Import/ — 导入页
- ChatLens/frontend/src/pages/Conversations/ — 对话列表/详情
- ChatLens/frontend/src/hooks/ — 自定义 Hooks
- ChatLens/frontend/src/stores/ — Zustand stores
- ChatLens/frontend/src/types/ — TypeScript 类型定义
- ChatLens/frontend/src/api/ — API 调用封装
- ChatLens/backend/app/routers/ — API 路由（按模块分文件）
- ChatLens/backend/app/services/ — 业务逻辑
- ChatLens/backend/app/models/ — SQLAlchemy ORM 模型
- ChatLens/backend/app/schemas/ — Pydantic 请求/响应模型
- ChatLens/backend/app/core/ — 配置、安全、依赖注入
- ChatLens/backend/app/main.py — FastAPI 应用入口
- ChatLens/backend/alembic/ — 数据库迁移
- ChatLens/backend/tests/ — 测试
- ChatLens/data/ — 模拟数据
- ChatLens/docs/spec/ — SPEC 拆分子文档

## 技术选型摘要

| 领域 | 选型 | 理由（简） | 详见 |
|------|------|------------|------|
| 前端框架 | React 18 + TypeScript | 生态成熟，类型安全，秋招展示有说服力 | DECISIONS.md ADR-GLOBAL-001 |
| 后端框架 | FastAPI | 异步、自带 OpenAPI 文档、Python 生态 | DECISIONS.md ADR-GLOBAL-001 |
| 数据库 | PostgreSQL | 关系型数据 + JSONB 灵活性 | DECISIONS.md ADR-GLOBAL-002 |
| 状态管理 | Zustand | 轻量、API 简洁 | DECISIONS.md ADR-DASH-001 |
| 图表库 | Recharts | React 生态、声明式 | DECISIONS.md ADR-DASH-001 |
| NLP | 外部 LLM API | 不自建模型，降低复杂度 | DECISIONS.md ADR-GLOBAL-004 |

## 模块间约定
- 模块间通信方式：前后端通过 REST API（JSON），后端模块间通过 Service 层函数调用
- 错误处理约定：后端统一返回 {"detail": "错误描述"} + HTTP 状态码，前端统一 Toast 提示
- 命名约定：API 路径 kebab-case，Python 变量 snake_case，TypeScript 变量 camelCase，组件 PascalCase

## 扩展规划
- WebSocket 实时推送分析进度
- 多租户隔离（组织级数据隔离）
- 插件化 LLM Provider（可切换不同模型）
- 粤语语音转文字接入

<!-- 🔓 END 生成区：全文 -->
