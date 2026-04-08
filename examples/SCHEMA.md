# SCHEMA.md

<!-- 区块权限声明
| 区块 | 类型 | 说明 |
|------|------|------|
| 全文 | 🔓 生成区 | Claude Code 根据讨论内容填写 |
| 全文权限 | ⚠️ 决策文件 | 修改前必须获得用户确认 |
| 条件生成 | ℹ️ | 仅在项目有数据库或复杂数据模型时创建 |
| 规则 | 🔒 锁定区 | 每个项目一致，不可更改 |
-->

<!-- 🔓 START 生成区：全文（⚠️ 决策文件：修改需用户确认） -->

## 数据概览

ChatLens 使用 PostgreSQL，共 6 张核心表，以 organization 为顶层、conversation 为核心关联。

## 表关系

- organizations 1:N users（通过 users.org_id）
- organizations 1:N datasets（通过 datasets.org_id）
- users 1:N datasets（通过 datasets.uploaded_by）
- datasets 1:N conversations（通过 conversations.dataset_id）
- conversations 1:N messages（通过 messages.conversation_id）
- conversations 1:1 analyses（通过 analyses.conversation_id, UNIQUE）

## 表结构

### organizations
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| name | VARCHAR(200) | NOT NULL | 企业名称 |
| plan | VARCHAR(20) | DEFAULT 'free' | 套餐：free / pro / enterprise |
| created_at | TIMESTAMP | DEFAULT NOW() | |
| updated_at | TIMESTAMP | DEFAULT NOW() | |

### users
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| org_id | UUID | FK → organizations.id, NOT NULL | 所属企业 |
| email | VARCHAR(255) | UNIQUE, NOT NULL | 登录邮箱 |
| password_hash | VARCHAR(255) | NOT NULL | bcrypt 哈希 |
| name | VARCHAR(100) | NOT NULL | 显示名 |
| role | VARCHAR(20) | DEFAULT 'member' | admin / member |
| created_at | TIMESTAMP | DEFAULT NOW() | |

### datasets
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| org_id | UUID | FK → organizations.id, NOT NULL | 所属企业 |
| uploaded_by | UUID | FK → users.id, NOT NULL | 上传者 |
| name | VARCHAR(200) | NOT NULL | 数据集名称 |
| source_type | VARCHAR(20) | DEFAULT 'csv' | csv / json / api |
| record_count | INTEGER | DEFAULT 0 | 对话条数 |
| status | VARCHAR(20) | DEFAULT 'pending' | pending / processing / ready / error |
| created_at | TIMESTAMP | DEFAULT NOW() | |

### conversations
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| dataset_id | UUID | FK → datasets.id, NOT NULL | 所属数据集 |
| external_id | VARCHAR(100) | | 原始系统中的对话 ID |
| customer_name | VARCHAR(100) | | 客户名（可匿名） |
| agent_name | VARCHAR(100) | | 客服名 |
| started_at | TIMESTAMP | | 对话开始时间 |
| ended_at | TIMESTAMP | | 对话结束时间 |
| message_count | INTEGER | DEFAULT 0 | 消息条数 |
| created_at | TIMESTAMP | DEFAULT NOW() | |

### messages
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| conversation_id | UUID | FK → conversations.id, NOT NULL | 所属对话 |
| role | VARCHAR(20) | NOT NULL | customer / agent / system |
| content | TEXT | NOT NULL | 消息正文 |
| sequence | INTEGER | NOT NULL | 消息在对话中的顺序（从 1 开始） |
| sent_at | TIMESTAMP | | 发送时间 |

### analyses
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| conversation_id | UUID | FK → conversations.id, UNIQUE, NOT NULL | 1:1 关联对话 |
| sentiment | VARCHAR(20) | | positive / neutral / negative |
| sentiment_score | FLOAT | | -1.0 ~ 1.0 |
| intent | VARCHAR(50) | | inquiry / complaint / return / purchase / other |
| quality_score | INTEGER | | 0-100 |
| keywords | JSONB | DEFAULT '[]' | 关键词列表 |
| summary | TEXT | | AI 生成的对话摘要 |
| raw_response | JSONB | | LLM 原始返回（调试用） |
| model_used | VARCHAR(50) | | 使用的模型名称 |
| analyzed_at | TIMESTAMP | DEFAULT NOW() | |

## 索引
| 表 | 索引名 | 字段 | 类型 | 用途 |
|----|--------|------|------|------|
| users | idx_users_email | email | UNIQUE | 登录查询 |
| users | idx_users_org | org_id | BTREE | 按企业查用户 |
| datasets | idx_datasets_org | org_id | BTREE | 按企业查数据集 |
| conversations | idx_conv_dataset | dataset_id | BTREE | 按数据集查对话 |
| messages | idx_msg_conv_seq | conversation_id, sequence | BTREE | 按对话查消息并排序 |
| analyses | idx_analyses_conv | conversation_id | UNIQUE | 查对话的分析结果 |
| analyses | idx_analyses_sentiment | sentiment | BTREE | 按情感筛选 |
| analyses | idx_analyses_intent | intent | BTREE | 按意图筛选 |

## 枚举/常量
| 名称 | 值 | 说明 |
|------|-----|------|
| role.ADMIN | 'admin' | 企业管理员 |
| role.MEMBER | 'member' | 普通成员 |
| sentiment.POSITIVE | 'positive' | 正面情绪 |
| sentiment.NEUTRAL | 'neutral' | 中性 |
| sentiment.NEGATIVE | 'negative' | 负面情绪 |
| intent.INQUIRY | 'inquiry' | 咨询 |
| intent.COMPLAINT | 'complaint' | 投诉 |
| intent.RETURN | 'return' | 退换 |
| intent.PURCHASE | 'purchase' | 购买 |
| intent.OTHER | 'other' | 其他 |
| dataset_status.PENDING | 'pending' | 等待处理 |
| dataset_status.PROCESSING | 'processing' | 处理中 |
| dataset_status.READY | 'ready' | 就绪 |
| dataset_status.ERROR | 'error' | 错误 |

## 数据约定
- 主键：统一使用 UUID（gen_random_uuid()）
- 时间字段：统一 UTC，字段名用 _at 后缀（created_at, updated_at, analyzed_at）
- 软删除：MVP 阶段不做软删除，直接物理删除
- 字符编码：UTF-8
- JSON 字段：使用 PostgreSQL JSONB 类型

## 迁移记录
| 版本 | 日期 | 变更内容 |
|------|------|----------|
| v1.0 | 2026-04-08 | 初始表结构（6 张表） |

<!-- 🔓 END 生成区：全文 -->

---

<!-- 🔒 START 锁定区：规则 -->
## 规则
1. 任何表结构变更必须先更新此文件，再写代码
2. 新增表时必须包含：字段定义、约束、说明
3. 字段命名遵循「数据约定」区的规范
4. 变更表结构时在「迁移记录」追加一条
5. 「表关系」区必须与表结构保持同步
6. 枚举/常量变更时需检查前后端是否同步使用
<!-- 🔒 END 锁定区：规则 -->
