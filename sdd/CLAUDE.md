# CLAUDE.md — 项目开发规范

## 项目概述

Flutter前端 + Spring Boot后端全栈项目。包含首页（Banner轮播、功能分类、推荐资讯）和个人中心（用户信息、数据统计、功能菜单）两大页面。

---

## 技术栈

- **前端**: Flutter 3.24+, Provider 6.x, Dio 5.x
- **后端**: Spring Boot 3.2+, Java 17, Maven 3.9+
- **数据库**: MySQL 8.0
- **部署**: systemd + nginx (Linux)

---

## 项目结构

```
├── doc/           # 原型标注文档
├── sdd/           # SDD文档套件
├── backend/       # Spring Boot后端
├── frontend/      # Flutter前端
├── sql/           # MySQL DDL + 测试数据
└── deploy/        # Linux部署脚本
```

详见 `sdd/plan.md` 完整目录结构。

---

## 开发规范

### 1. 代码风格

- **Java**: 遵循阿里巴巴Java开发手册，4空格缩进，Controller-Service-Repository三层架构
- **Dart**: 遵循Effective Dart，2空格缩进，Widget命名PascalCase，变量camelCase
- **命名**: 类名大驼峰、方法/变量小驼峰、常量全大写蛇形

### 2. Git规范

- 分支: `master` → `dev` → `feature/xxx`
- 提交: `<type>: <description>` (feat/fix/docs/style/refactor/test/chore)
- 禁止直接push master

### 3. API规范

- RESTful风格，统一返回 `{code, message, data}` 格式
- 分页参数 `pageNum`(从1开始), `pageSize`
- 所有时间字段格式 `yyyy-MM-dd HH:mm:ss`

### 4. Flutter规范

- 使用 `Provider` + `ChangeNotifier` 状态管理
- 网络请求统一经过 `ApiService`（Dio单例）
- 页面遵循 `Repository → Provider → Consumer/Selector` 数据流
- 所有硬编码字符串（颜色、字号、间距）提取为常量
- 页面视觉还原度要求 ≥ 90%

### 5. 后端规范

- Controller 只做参数校验和路由，业务逻辑在 Service
- JPA Repository 只定义查询方法，不写SQL（除非复杂查询）
- 跨域使用 CorsConfig 统一配置
- 异常统一由全局异常处理器捕获

---

## 行为准则

基自全局 CLAUDE.md：

1. **先思考再编码** — 不确定时先提问，明确假设
2. **简洁优先** — 不写不需要的抽象、配置、错误处理
3. **精准修改** — 不改不相关的代码
4. **目标驱动** — 每次改动前定义验证标准

---

## 验收标准速查

| 页面 | 模块数 | 接口 | 关键交互 |
|------|--------|------|----------|
| 首页 | 5 | /api/home/banner, /api/home/category, /api/home/list | 轮播、下拉刷新、上拉加载 |
| 个人中心 | 4 | /api/user/info | Tab切换、数据统计点击 |
