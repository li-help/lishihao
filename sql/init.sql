-- ============================================
-- MySQL 建表语句 + 测试数据
-- 数据库: demo_db
-- ============================================

CREATE DATABASE IF NOT EXISTS `demo_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `demo_db`;

-- ----------------------------
-- 1. Banner轮播图表
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
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

-- ----------------------------
-- 2. 功能分类表
-- ----------------------------
DROP TABLE IF EXISTS `category`;
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

-- ----------------------------
-- 3. 资讯文章表
-- ----------------------------
DROP TABLE IF EXISTS `article`;
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

-- ----------------------------
-- 4. 用户表
-- ----------------------------
DROP TABLE IF EXISTS `user`;
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

-- ============================================
-- 测试数据
-- ============================================

-- Banner测试数据（3条）
INSERT INTO `banner` (`image_url`, `link_url`, `sort_order`, `status`) VALUES
('https://picsum.photos/750/360?random=1', 'https://example.com/promo/1', 1, 1),
('https://picsum.photos/750/360?random=2', 'https://example.com/promo/2', 2, 1),
('https://picsum.photos/750/360?random=3', 'https://example.com/promo/3', 3, 1);

-- 分类测试数据（8条，2行4列）
INSERT INTO `category` (`name`, `icon_url`, `route`, `sort_order`, `status`) VALUES
('美食',    'https://img.icons8.com/color/96/restaurant.png',  '/food',     1, 1),
('酒店',    'https://img.icons8.com/color/96/hotel.png',        '/hotel',    2, 1),
('景点',    'https://img.icons8.com/color/96/landmark.png',     '/scenic',   3, 1),
('购物',    'https://img.icons8.com/color/96/shopping-cart.png','/shop',     4, 1),
('娱乐',    'https://img.icons8.com/color/96/clown-fish.png',   '/entertain',5, 1),
('出行',    'https://img.icons8.com/color/96/taxi.png',         '/travel',   6, 1),
('运动',    'https://img.icons8.com/color/96/exercise.png',     '/sport',    7, 1),
('教育',    'https://img.icons8.com/color/96/education.png',    '/edu',      8, 1);

-- 资讯测试数据（15条，用于测试分页）
INSERT INTO `article` (`title`, `summary`, `cover_url`, `status`, `create_time`) VALUES
('2026年夏季旅游热门目的地推荐', '盘点今年夏季最值得去的十大旅游目的地，带你领略不同风景', 'https://picsum.photos/200/160?random=10', 1, '2026-07-14 10:00:00'),
('城市美食地图：不可错过的地道小吃', '每座城市都有自己独特的美食文化，跟随我们一起探寻街头巷尾的美味', 'https://picsum.photos/200/160?random=11', 1, '2026-07-13 16:30:00'),
('智能家居新趋势：科技改变生活', '2026年智能家居市场迎来爆发式增长，AI技术深度融入日常生活', 'https://picsum.photos/200/160?random=12', 1, '2026-07-13 14:00:00'),
('户外运动爱好者必读：夏季徒步指南', '夏季是徒步的最佳季节，掌握这些技巧让你的户外之旅更加安全舒适', 'https://picsum.photos/200/160?random=13', 1, '2026-07-12 09:00:00'),
('新能源汽车销量再创新高', '数据显示2026年上半年新能源汽车市场渗透率突破60%，国产车企表现亮眼', 'https://picsum.photos/200/160?random=14', 1, '2026-07-11 18:00:00'),
('健康饮食：如何科学搭配一日三餐', '营养专家分享科学饮食搭配方案，助你轻松拥有健康体魄', 'https://picsum.photos/200/160?random=15', 1, '2026-07-11 10:00:00'),
('数字人民币应用场景持续扩展', '数字人民币试点城市增至50个，覆盖零售、交通、医疗等多个领域', 'https://picsum.photos/200/160?random=16', 1, '2026-07-10 15:00:00'),
('摄影技巧：手机也能拍出大片感', '无需昂贵器材，掌握这些手机摄影技巧让你随手拍出精美照片', 'https://picsum.photos/200/160?random=17', 1, '2026-07-10 08:00:00'),
('职场进阶：高效时间管理方法论', '顶尖职场人的时间管理秘诀，让你的工作效率翻倍提升', 'https://picsum.photos/200/160?random=18', 1, '2026-07-09 14:00:00'),
('宠物经济持续升温：年轻人热衷云吸宠', '宠物相关消费同比增长35%，短视频平台宠物内容播放量突破万亿', 'https://picsum.photos/200/160?random=19', 1, '2026-07-09 09:00:00'),
('航天新进展：商业航天开启新篇章', '多家民营航天企业完成新一轮融资，低成本发射成为可能', 'https://picsum.photos/200/160?random=20', 1, '2026-07-08 16:00:00'),
('传统文化焕新：国潮设计走向世界', '越来越多的中国设计师将传统元素融入现代设计，受到国际市场认可', 'https://picsum.photos/200/160?random=21', 1, '2026-07-08 11:00:00'),
('在线教育转型：AI个性化学习受关注', 'AI技术赋能在线教育，个性化学习方案成为行业新风口', 'https://picsum.photos/200/160?random=22', 1, '2026-07-07 15:00:00'),
('环保行动：绿色低碳生活新方式', '从垃圾分类到碳账户，绿色低碳正在成为每个人的生活日常', 'https://picsum.photos/200/160?random=23', 1, '2026-07-07 08:00:00'),
('电子竞技入亚：行业标准化加速', '电子竞技产业规范化发展，职业选手培养体系日趋成熟', 'https://picsum.photos/200/160?random=24', 1, '2026-07-06 14:00:00');

-- 用户测试数据（1条）
INSERT INTO `user` (`user_id`, `nick_name`, `avatar`, `points`, `collect_count`, `view_count`, `status`) VALUES
('U0001', '李世昊', 'https://picsum.photos/144/144?random=99', 1280, 36, 256, 1);
