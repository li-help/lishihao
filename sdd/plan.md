# Plan.md — 实施计划

## 1. 架构总览

```
┌──────────────────────────────────────────────┐
│                  Nginx (80)                   │
│           静态资源 + API反向代理               │
├──────────────────┬───────────────────────────┤
│   Flutter App    │   Spring Boot (8080)       │
│   Provider+Dio   │   Controller→Service→Repo  │
│   公网API调用     │   JPA → MySQL 8.0          │
└──────────────────┴───────────────────────────┘
```

- **前端**：Flutter 3.24+，Provider状态管理，Dio网络库，调用公网接口
- **后端**：Spring Boot 3.2+，三层架构，JPA持久化，部署于Linux服务器
- **数据库**：MySQL 8.0，4张业务表
- **服务器**：systemd管理Spring Boot进程，nginx反向代理

---

## 2. 目录结构

```
李世昊/
├── doc/
│   └── prototype_all_doc.md          # 原型标注文档
├── sdd/
│   ├── spec.md                       # 技术规格说明书
│   ├── plan.md                       # 本文件 - 实施计划
│   ├── task.md                       # 任务拆解与分工
│   ├── CLAUDE.md                     # 项目开发规范
│   └── acceptance.md                 # 自测验收文档
├── backend/                          # Spring Boot 后端项目
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/example/demo/
│       │   ├── DemoApplication.java
│       │   ├── config/
│       │   │   └── CorsConfig.java
│       │   ├── controller/
│       │   │   ├── HomeController.java
│       │   │   └── UserController.java
│       │   ├── service/
│       │   │   ├── HomeService.java
│       │   │   └── UserService.java
│       │   ├── repository/
│       │   │   ├── BannerRepository.java
│       │   │   ├── CategoryRepository.java
│       │   │   ├── ArticleRepository.java
│       │   │   └── UserRepository.java
│       │   ├── entity/
│       │   │   ├── Banner.java
│       │   │   ├── Category.java
│       │   │   ├── Article.java
│       │   │   └── User.java
│       │   └── dto/
│       │       ├── ApiResponse.java
│       │       ├── ArticlePageDTO.java
│       │       └── UserInfoDTO.java
│       └── resources/
│           └── application.yml
├── frontend/                         # Flutter 前端项目
│   ├── pubspec.yaml
│   └── lib/
│       ├── main.dart
│       ├── app.dart
│       ├── config/
│       │   └── api_config.dart
│       ├── models/
│       │   ├── api_response.dart
│       │   ├── banner_model.dart
│       │   ├── category_model.dart
│       │   ├── article_model.dart
│       │   └── user_model.dart
│       ├── providers/
│       │   ├── banner_provider.dart
│       │   ├── category_provider.dart
│       │   ├── article_provider.dart
│       │   ├── user_provider.dart
│       │   └── tab_provider.dart
│       ├── repositories/
│       │   ├── home_repository.dart
│       │   └── user_repository.dart
│       ├── services/
│       │   └── api_service.dart
│       ├── pages/
│       │   ├── main_page.dart
│       │   ├── home_page.dart
│       │   ├── category_page.dart
│       │   └── me_page.dart
│       └── widgets/
│           ├── app_bottom_nav.dart
│           ├── loading_widget.dart
│           ├── empty_widget.dart
│           ├── error_widget.dart
│           ├── cached_image.dart
│           └── toast_util.dart
├── sql/
│   └── init.sql                     # MySQL建表 + 测试数据
├── deploy/
│   ├── deploy.sh                    # 一键部署脚本
│   └── nginx.conf                   # Nginx配置模板
├── .gitignore
└── git-init.sh                      # Git完整流程脚本
```

---

## 3. 开发阶段（2人团队）

### 角色分工

| 角色 | 开发者A（后端） | 开发者B（前端） |
|------|----------------|----------------|
| 技术栈 | Java Spring Boot + MySQL | Flutter + Provider + Dio |
| 核心产出 | 4个API接口 + 数据库 + 部署脚本 | 2个主页面 + 公共组件 + 状态管理 |

### 开发Sprint（4天）

```
Day 1 ─── SDD文档完成 ────────────→  Git初始化 + 初次提交
Day 2 ─── 并行开发 ────────────────→  A:后端接口 B:前端页面
Day 3 ─── 联调 + 验收 ────────────→  接口对接 + 视觉还原校验
Day 4 ─── 部署 + 文档 ────────────→  服务器部署 + 验收文档
```

---

## 4. 优先级矩阵

| 优先级 | 定义 | 示例任务 |
|--------|------|----------|
| **P0** | 阻塞性，必须率先完成 | 项目脚手架、数据库DDL、4个核心API、2个主页面骨架 |
| **P1** | 核心功能，紧接P0 | 轮播交互、上拉加载、下拉刷新、异常状态UI |
| **P2** | 增强体验 | 图片缓存、骨架屏、动画过渡、公共组件抽取 |
| **P3** | 验收收尾 | 部署脚本、自测验收文档、代码清理、Git完整流程 |

---

## 5. 并行/串行策略

```
串行（依赖关系）：
  spec.md → plan.md → task.md
  数据库DDL → 后端实体 → 后端Repository → 后端Service → 后端Controller
  pubspec.yaml → models → services → repositories → providers → pages

并行（无依赖）：
  ┌─ 后端API开发（开发者A）─┐
  │                          ├──→ 联调 → 部署
  └─ 前端UI开发（开发者B）─┘
  SQL建表  ∥  前端models定义
  后端接口 ∥  前端Provider+页面
  部署脚本 ∥  Flutter打包
```

---

## 6. Git分支策略

```
master ◄── merge ── dev ◄── feature/xxx
  ▲                    │
  └── Tag v1.0 ────────┘
```

| 步骤 | 命令 | 说明 |
|------|------|------|
| 1 | `git init` | 初始化仓库 |
| 2 | `git add .gitignore` | 添加忽略文件 |
| 3 | `git add -A && git commit -m "init: SDD文档"` | 初次提交 |
| 4 | `git checkout -b dev` | 创建开发分支 |
| 5 | `git checkout -b feature/backend` / `feature/frontend` | 功能分支 |
| 6 | `git checkout dev && git merge feature/xxx` | 合并到dev |
| 7 | `git checkout master && git merge dev` | 合并到master |
| 8 | `git tag v1.0 && git push origin master --tags` | 打标签推送 |

---

## 7. 风险与对策

| 风险 | 可能性 | 对策 |
|------|--------|------|
| 后端接口与前端数据格式不匹配 | 中 | 提前约定JSON Schema，mock数据先行 |
| 视觉还原度不达标 | 中 | 严格对标原型标注，逐像素对比 |
| 远程服务器部署失败 | 低 | deploy.sh脚本全自动化 |
| 公网接口跨域问题 | 低 | Spring Boot CorsConfig + nginx反向代理 |
