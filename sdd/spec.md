# Spec.md — 技术规格说明书

## 1. 项目概述

**项目名称**：首页展示 + 个人中心（Flutter + Spring Boot 全栈项目）

**项目目标**：依据双页面原型标注文档，开发Flutter前端App和Java SpringBoot后端服务。首页动态渲染Banner轮播、功能分类网格、推荐资讯列表；个人中心展示用户信息、数据统计、功能菜单。视觉还原度≥90%。

**交付标准**：原型标注文档、全套SDD文档、Flutter完整分层代码、SpringBoot后端代码、MySQL建表语句、Linux部署脚本、自测验收文档。

---

## 2. 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 前端框架 | Flutter | 3.24+ |
| 状态管理 | Provider | 6.x |
| 网络库 | Dio | 5.x |
| 路由 | Flutter Navigator 2.0 | - |
| 后端框架 | Spring Boot | 3.2+ |
| ORM | Spring Data JPA | - |
| 数据库 | MySQL | 8.0 |
| 构建工具 | Maven | 3.9+ |
| JDK | Java 17 | - |
| 部署 | systemd + nginx | - |

---

## 3. API接口规格

### 3.1 通用响应格式

```json
{
  "code": 200,
  "message": "success",
  "data": {}
}
```

| code | 含义 |
|------|------|
| 200 | 成功 |
| 400 | 参数错误 |
| 500 | 服务器异常 |

### 3.2 首页Banner接口

```
GET /api/home/banner
```

**Response:**
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "imageUrl": "https://cdn.example.com/banner/1.jpg",
      "linkUrl": "https://example.com/promo/1",
      "sortOrder": 1
    }
  ]
}
```

### 3.3 功能分类接口

```
GET /api/home/category
```

**Response:**
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "美食",
      "iconUrl": "https://cdn.example.com/icon/food.png",
      "route": "/food"
    }
  ]
}
```

### 3.4 推荐资讯列表接口

```
GET /api/home/list?pageNum=1&pageSize=10
```

**Response:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total": 100,
    "pageNum": 1,
    "pageSize": 10,
    "pages": 10,
    "list": [
      {
        "id": 1,
        "title": "资讯标题",
        "summary": "资讯简介摘要内容",
        "coverUrl": "https://cdn.example.com/cover/1.jpg",
        "createTime": "2026-07-14 10:30:00"
      }
    ]
  }
}
```

### 3.5 用户信息接口

```
GET /api/user/info?userId=U0001
```

**Response:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "avatar": "https://cdn.example.com/avatar/u0001.jpg",
    "nickName": "用户昵称",
    "userId": "U0001",
    "points": 1280,
    "collectCount": 36,
    "viewCount": 256
  }
}
```

---

## 4. 数据库设计

### 4.1 banner表

```sql
CREATE TABLE `banner` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `image_url` VARCHAR(512) NOT NULL COMMENT 'Banner图片URL',
  `link_url` VARCHAR(512) DEFAULT NULL COMMENT '跳转链接',
  `sort_order` INT DEFAULT 0 COMMENT '排序序号',
  `status` TINYINT DEFAULT 1 COMMENT '状态 1启用 0禁用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页Banner表';
```

### 4.2 category表

```sql
CREATE TABLE `category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL COMMENT '分类名称',
  `icon_url` VARCHAR(512) DEFAULT NULL COMMENT '图标URL',
  `route` VARCHAR(128) DEFAULT NULL COMMENT '跳转路由',
  `sort_order` INT DEFAULT 0 COMMENT '排序序号',
  `status` TINYINT DEFAULT 1 COMMENT '状态 1启用 0禁用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='功能分类表';
```

### 4.3 article表

```sql
CREATE TABLE `article` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(256) NOT NULL COMMENT '资讯标题',
  `summary` VARCHAR(512) DEFAULT NULL COMMENT '资讯摘要',
  `cover_url` VARCHAR(512) DEFAULT NULL COMMENT '封面图URL',
  `content` TEXT COMMENT '资讯正文',
  `status` TINYINT DEFAULT 1 COMMENT '状态 1发布 0草稿',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资讯文章表';
```

### 4.4 user表

```sql
CREATE TABLE `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(32) NOT NULL COMMENT '用户编号Uxxxx',
  `nick_name` VARCHAR(64) NOT NULL COMMENT '昵称',
  `avatar` VARCHAR(512) DEFAULT NULL COMMENT '头像URL',
  `points` INT DEFAULT 0 COMMENT '积分',
  `collect_count` INT DEFAULT 0 COMMENT '收藏数',
  `view_count` INT DEFAULT 0 COMMENT '浏览数',
  `status` TINYINT DEFAULT 1 COMMENT '状态 1正常 0禁用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
```

---

## 5. Flutter组件架构

### 5.1 页面路由

| 路由 | 页面 | 说明 |
|------|------|------|
| / | MainPage | 底部Tab导航容器 |
| /home | HomePage | 首页（Tab1） |
| /category | CategoryPage | 分类页（Tab2） |
| /me | MePage | 个人中心（Tab3） |

### 5.2 状态管理（Provider）

```
MultiProvider
├── BannerProvider      → 首页Banner数据 + 加载/异常状态
├── CategoryProvider    → 功能分类数据
├── ArticleProvider     → 推荐资讯列表 + 分页
├── UserProvider        → 用户信息数据
└── TabProvider         → 底部Tab选中状态
```

### 5.3 组件树

```
MaterialApp
└── MainPage (IndexedStack + BottomNavigationBar)
    ├── HomePage (CustomScrollView)
    │   ├── HomeAppBar
    │   ├── BannerCarousel (PageView.builder + 圆点指示器)
    │   ├── CategoryGrid (GridView 4列)
    │   ├── ArticleListHeader ("推荐资讯" + "更多")
    │   └── ArticleListView (上拉加载 + 下拉刷新)
    ├── CategoryPage (占位)
    └── MePage (SingleChildScrollView)
        ├── UserHeaderCard (渐变背景 + 头像 + 昵称)
        ├── StatsBar (积分/收藏/浏览 三栏)
        └── MenuList (5项功能菜单)
```

### 5.4 公共组件

| 组件 | 用途 |
|------|------|
| `AppBottomNav` | 底部三Tab导航 |
| `LoadingWidget` | 页面初始化Loading |
| `EmptyWidget` | 无数据占位 |
| `ErrorWidget` | 网络异常重试 |
| `CachedImage` | 带占位图的网络图片 |
| `ToastUtil` | SnackBar提示工具 |

---

## 6. 数据流设计

```
[用户操作] → [Provider.notifyListeners()]
                  ↓
[Repository层] → [Dio HTTP请求] → [Spring Boot Controller]
                                       ↓
                                  [Service层]
                                       ↓
                                  [JPA Repository] → [MySQL]
                                       ↓
[Response DTO] ← [JSON Response] ← [Controller]
       ↓
[Provider更新数据] → [Consumer/Selector重建Widget]
```

### 6.1 网络层架构

```
lib/
├── main.dart
├── app.dart
├── config/
│   └── api_config.dart        # 后端接口基地址配置
├── models/                     # 数据模型
│   ├── banner_model.dart
│   ├── category_model.dart
│   ├── article_model.dart
│   ├── user_model.dart
│   └── api_response.dart
├── providers/                  # Provider状态管理
│   ├── banner_provider.dart
│   ├── category_provider.dart
│   ├── article_provider.dart
│   ├── user_provider.dart
│   └── tab_provider.dart
├── repositories/               # 数据仓库层
│   ├── home_repository.dart
│   └── user_repository.dart
├── services/                   # Dio网络服务
│   └── api_service.dart
├── pages/                      # 页面
│   ├── main_page.dart
│   ├── home_page.dart
│   ├── category_page.dart
│   └── me_page.dart
└── widgets/                    # 公共组件
    ├── app_bottom_nav.dart
    ├── loading_widget.dart
    ├── empty_widget.dart
    ├── error_widget.dart
    ├── cached_image.dart
    └── toast_util.dart
```

---

## 7. 错误处理规范

| 场景 | 处理方式 |
|------|----------|
| 网络超时（10s） | ErrorWidget + 点击重试按钮 |
| 服务端500 | Toast "服务器繁忙，请稍后再试" |
| 返回空列表 | EmptyWidget "暂无数据" |
| 图片加载失败 | 灰色占位图 |
| 首次加载 | 骨架屏/LoadingWidget |
| 上拉加载更多失败 | Toast + 保留已加载数据 |

---

## 8. 验收清单

- [ ] 首页5大模块完整，顺序匹配原型
- [ ] 个人中心4大模块完整，顺序匹配原型
- [ ] 尺寸/色值/间距误差 < 10%
- [ ] 轮播3s自动切换 + 手势滑动 + 圆点联动
- [ ] 下拉刷新 + 上拉分页加载
- [ ] Loading / Empty / Error 三态UI齐全
- [ ] 图片加载失败占位图
- [ ] 底部Tab三页切换 + 选中态高亮
- [ ] 所有数据从后端接口动态渲染
- [ ] 后端4接口全部可用，返回格式正确
- [ ] MySQL四表DDL可执行
- [ ] Linux部署脚本可运行
