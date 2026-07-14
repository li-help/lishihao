# Task.md — 任务拆解与分工

## 团队：2人（开发者A-后端 / 开发者B-前端）

---

## P0 — 基础设施（阻塞性，必须最先完成）

| ID | 任务 | 负责人 | 类型 | 预估 | 依赖 | 验证标准 |
|----|------|--------|------|------|------|----------|
| P0-1 | 项目目录结构初始化 | A+B | 串行 | 0.5h | - | 目录结构与plan.md一致 |
| P0-2 | .gitignore + git-init.sh | A | 串行 | 0.5h | P0-1 | git status无多余文件 |
| P0-3 | Git仓库初始化 + 首次提交SDD文档 | A | 串行 | 0.5h | P0-2 | git log有提交记录 |
| P0-4 | MySQL建表DDL + 测试数据 | A | 并行 | 1h | P0-1 | 4张表可成功创建并插入数据 |
| P0-5 | Spring Boot项目脚手架(pom.xml + Application + application.yml) | A | 并行 | 0.5h | P0-1 | mvn spring-boot:run启动成功 |
| P0-6 | Flutter项目脚手架(pubspec.yaml + main.dart + 基础目录) | B | 并行 | 0.5h | P0-1 | flutter run启动成功 |

---

## P1 — 核心功能（并行开发）

### P1-A：后端核心（开发者A）

| ID | 任务 | 类型 | 预估 | 依赖 | 验证标准 |
|----|------|------|------|------|----------|
| P1-A1 | Entity层：Banner/Category/Article/User | 串行 | 0.5h | P0-5 | JPA映射正确 |
| P1-A2 | Repository层：4个JPA接口 | 串行 | 0.5h | P1-A1 | 基础CRUD可用 |
| P1-A3 | DTO层：ApiResponse/ArticlePageDTO/UserInfoDTO | 并行 | 0.5h | P0-5 | JSON序列化正确 |
| P1-A4 | Service层：HomeService/UserService | 串行 | 1h | P1-A2,P1-A3 | 业务逻辑正确 |
| P1-A5 | Controller层：4个REST接口 | 串行 | 1h | P1-A4 | curl测试返回正确JSON |
| P1-A6 | CorsConfig跨域配置 | 并行 | 0.5h | P0-5 | OPTIONS预检通过 |
| P1-A7 | 接口自测 + Postman集合 | 串行 | 0.5h | P1-A5 | 4个接口全部200 |

### P1-B：前端核心（开发者B）

| ID | 任务 | 类型 | 预估 | 依赖 | 验证标准 |
|----|------|------|------|------|----------|
| P1-B1 | Models层：5个数据模型 + JSON序列化 | 串行 | 0.5h | P0-6 | fromJson/toJson正确 |
| P1-B2 | ApiService(Dio) + ApiConfig | 串行 | 0.5h | P0-6 | 网络请求可达 |
| P1-B3 | Repository层：HomeRepository/UserRepository | 串行 | 0.5h | P1-B1,P1-B2 | 数据获取封装正确 |
| P1-B4 | Provider层：5个Provider | 串行 | 1h | P1-B3 | notifyListeners触发UI更新 |
| P1-B5 | HomePage骨架：5大模块布局 | 串行 | 2h | P1-B4 | 页面结构顺序匹配原型 |
| P1-B6 | MePage骨架：4大模块布局 | 并行 | 1.5h | P1-B4 | 页面结构顺序匹配原型 |
| P1-B7 | MainPage + BottomNav（IndexedStack） | 串行 | 1h | P1-B5,P1-B6 | 三Tab切换正常 |

---

## P2 — 体验增强（可并行）

| ID | 任务 | 负责人 | 类型 | 预估 | 依赖 | 验证标准 |
|----|------|--------|------|------|------|----------|
| P2-1 | Banner轮播：自动播放 + 手势 + 圆点 | B | 并行 | 1h | P1-B5 | 3s自动切换，滑动流畅 |
| P2-2 | 推荐列表：下拉刷新 + 上拉加载更多 | B | 串行 | 1h | P1-B5 | RefreshIndicator + 分页 |
| P2-3 | 图片缓存 + 占位图组件 | B | 并行 | 0.5h | P1-B5 | 离线/弱网占位图展示 |
| P2-4 | Loading/Empty/Error三态组件 | B | 并行 | 0.5h | P1-B5 | 三态切换正常 |
| P2-5 | 首页+个人中心水波纹点击效果 | B | 并行 | 0.5h | P1-B5,P1-B6 | InkWell包裹可点击区域 |
| P2-6 | Toast工具类 | B | 并行 | 0.5h | P1-B2 | 网络异常弹出SnackBar |

---

## P3 — 部署与验收（收尾）

| ID | 任务 | 负责人 | 类型 | 预估 | 依赖 | 验证标准 |
|----|------|--------|------|------|------|----------|
| P3-1 | Linux部署脚本 deploy.sh | A | 串行 | 1h | P1-A7 | 一键部署成功 |
| P3-2 | Nginx配置模板 | A | 并行 | 0.5h | P3-1 | 反向代理+静态资源正常 |
| P3-3 | Flutter打包APK/IPA | B | 并行 | 0.5h | P2全部 | 安装包可运行 |
| P3-4 | 前后端联调（对接公网接口） | A+B | 串行 | 1h | P3-1,P3-3 | 页面数据来自后端 |
| P3-5 | 视觉还原度自测 | B | 串行 | 0.5h | P3-4 | 还原度≥90% |
| P3-6 | 自测验收文档 acceptance.md | A+B | 串行 | 0.5h | P3-5 | 所有验收项打勾 |
| P3-7 | Git完整流程：dev→master→tag→push | A | 串行 | 0.5h | P3-6 | 远程仓库可见 |

---

## 甘特图概要

```
时间轴 →    │ D1上午  │ D1下午  │ D2上午   │ D2下午   │ D3上午  │ D3下午   │ D4
───────────┼─────────┼─────────┼──────────┼──────────┼─────────┼──────────┼─────
开发者A    │ P0-1~P0-5│ P1-A1~A4│ P1-A5~A7 │ P3-1~P3-2│ 联调     │ 修bug    │ P3-7
开发者B    │ P0-1,P0-6│ P1-B1~B3│ P1-B4~B5 │ P1-B6~B7 │ P2全部   │ 联调     │ P3-3~P3-6
───────────┼─────────┼─────────┼──────────┼──────────┼─────────┼──────────┼─────
里程碑     │ 脚手架   │ 核心层   │ 接口/页面 │ 页面完成  │ 体验增强 │ 联调通过  │ 发布
```

---

## 关键约定

1. **接口先行**：P1-A完成后即刻产出接口文档，B据此mock数据开发
2. **每日站会**：D1-D4每日同步进度、阻塞点
3. **dev分支保护**：不允许直接push到master
4. **commit规范**：`<type>: <description>`（feat/fix/docs/style/refactor/test/chore）
