/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : blog

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 10/06/2026 13:52:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文章标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文章内容(Markdown格式)',
  `html_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文章内容(HTML格式)',
  `summary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文章摘要',
  `cover_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片',
  `category_id` bigint NULL DEFAULT NULL COMMENT '分类ID',
  `user_id` bigint NOT NULL COMMENT '作者ID',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int NULL DEFAULT 0 COMMENT '评论数',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(0:草稿,1:已发布,2:已删除)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_top` tinyint NULL DEFAULT 0 COMMENT '是否置顶(0:否,1:是)',
  `is_recommend` tinyint NULL DEFAULT 0 COMMENT '是否推荐(0:否,1:是)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, '个人博客系统开发文档', '\n1. 项目概述\n本项目是一个基于SpringBoot+Vue3的个人博客系统，采用前后端分离架构，实现博客内容的发布、管理、展示等功能。系统分为前台展示和后台管理两大部分，为用户提供良好的阅读体验和博主提供便捷的内容管理能力。\n1.1 技术栈\n前端：Vue3 + Element Plus + Axios + Vue Router + Pinia\n后端：Spring Boot + MyBatis-Plus + JWT\n数据库：MySQL\n开发工具：IDEA、VS Code\n版本控制：Git\n1.2 系统角色\n游客：未登录用户，可浏览博客内容、搜索文章、查看评论\n注册用户：可进行评论、点赞、收藏等操作\n博主/管理员：拥有内容发布、编辑、删除等管理权限\n2. 功能模块划分\n2.1 前台展示模块\n2.1.1 首页模块\n博客基本信息展示\n最新文章列表\n热门文章推荐\n文章分类导航\n标签云展示\n2.1.2 文章模块\n文章详情页\n文章评论区\n文章点赞功能\n文章收藏功能\n相关文章推荐\n2.1.3 分类与标签模块\n分类文章列表\n标签文章列表\n文章归档\n2.1.4 搜索模块\n全文搜索功能\n搜索结果展示\n2.1.5 用户中心\n用户资料查看与修改\n用户评论管理\n收藏文章管理\n2.2 后台管理模块\n2.2.1 用户管理\n用户信息管理\n用户权限控制\n2.2.2 文章管理\n文章发布（支持Markdown编辑器）\n文章编辑\n文章删除\n文章状态管理（草稿、已发布、已删除）\n2.2.3 分类管理\n分类新增\n分类编辑\n分类删除\n2.2.4 标签管理\n标签新增\n标签编辑\n标签删除\n2.2.5 评论管理\n评论审核\n评论回复\n评论删除\n2.2.6 系统设置\n博客基本信息设置\n首页轮播图设置\n友情链接管理\n关于我页面管理\n3. 数据库设计\n3.1 数据库表结构\n3.1.1 用户表(user)\n字段名类型约束说明idbigint主键、自增用户IDusernamevarchar(50)非空、唯一用户名passwordvarchar(100)非空密码(加密存储)emailvarchar(100)非空、唯一邮箱phonevarchar(20)手机号role_codevarchar(50)角色code(ADMIN/USER)namevarchar(50)姓名sexvarchar(255)性别avatarvarchar(200)头像statustinyint默认值1状态(0:禁用,1:正常)create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间\n3.1.2 文章表(article)\n字段名类型约束说明idbigint主键、自增文章IDtitlevarchar(100)非空文章标题contentlongtext非空文章内容(Markdown格式)html_contentlongtext非空文章内容(HTML格式)summaryvarchar(255)文章摘要cover_imagevarchar(200)封面图片category_idbigint分类IDuser_idbigint非空作者IDview_countint默认值0浏览量like_countint默认值0点赞数comment_countint默认值0评论数statustinyint默认值1状态(0:草稿,1:已发布,2:已删除)create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间is_toptinyint默认值0是否置顶(0:否,1:是)is_recommendtinyint默认值0是否推荐(0:否,1:是)\n3.1.3 文章分类表(category)\n字段名类型约束说明idbigint主键、自增分类IDnamevarchar(50)非空分类名称descriptionvarchar(200)分类描述parent_idbigint默认值0父分类ID(0表示顶级分类)order_numint默认值0排序号create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间\n3.1.4 标签表(tag)\n字段名类型约束说明idbigint主键、自增标签IDnamevarchar(50)非空标签名称colorvarchar(20)标签颜色create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间\n3.1.5 文章标签关联表(article_tag)\n字段名类型约束说明idbigint主键、自增关联IDarticle_idbigint非空文章IDtag_idbigint非空标签ID\n3.1.6 评论表(comment)\n字段名类型约束说明idbigint主键、自增评论IDcontentvarchar(500)非空评论内容article_idbigint非空文章IDuser_idbigint非空评论用户IDparent_idbigint默认值0父评论ID(0表示顶级评论)to_user_idbigint默认值0回复用户ID(0表示不是回复)statustinyint默认值1状态(0:待审核,1:已通过,2:已拒绝)create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间\n3.1.7 用户收藏表(user_collect)\n字段名类型约束说明idbigint主键、自增收藏IDuser_idbigint非空用户IDarticle_idbigint非空文章IDcreate_timedatetime默认当前时间创建时间\n3.1.8 用户点赞表(user_like)\n字段名类型约束说明idbigint主键、自增点赞IDuser_idbigint非空用户IDarticle_idbigint非空文章IDcreate_timedatetime默认当前时间创建时间\n3.1.9 博客设置表(blog_config)\n字段名类型约束说明idbigint主键、自增设置IDconfig_keyvarchar(50)非空配置键config_valuetext非空配置值create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间\n3.1.10 友情链接表(friend_link)\n字段名类型约束说明idbigint主键、自增链接IDnamevarchar(50)非空链接名称urlvarchar(200)非空链接地址logovarchar(200)链接logodescriptionvarchar(200)链接描述order_numint默认值0排序号statustinyint默认值1状态(0:隐藏,1:显示)create_timedatetime默认当前时间创建时间update_timedatetime默认当前时间更新时间\n3.2 表关系说明\n用户与文章：一对多关系，一个用户可以发布多篇文章\n文章与分类：多对一关系，多篇文章可以属于同一分类\n文章与标签：多对多关系，通过article_tag表关联\n用户与评论：一对多关系，一个用户可以发表多条评论\n文章与评论：一对多关系，一篇文章可以有多条评论\n评论与评论：自关联，实现评论回复功能\n4. 接口设计\n4.1 前台接口\n4.1.1 文章相关接口\n获取首页文章列表：GET /api/articles\n获取文章详情：GET /api/articles/{id}\n获取推荐文章：GET /api/articles/recommend\n获取最热文章：GET /api/articles/hot\n文章搜索：GET /api/articles/search?keyword={keyword}\n获取分类文章：GET /api/categories/{id}/articles\n获取标签文章：GET /api/tags/{id}/articles\n文章点赞：POST /api/articles/{id}/like\n文章收藏：POST /api/articles/{id}/collect\n4.1.2 分类标签接口\n获取所有分类：GET /api/categories\n获取所有标签：GET /api/tags\n4.1.3 评论相关接口\n获取文章评论：GET /api/articles/{id}/comments\n发表评论：POST /api/comments\n回复评论：POST /api/comments/{id}/reply\n4.1.4 用户相关接口\n用户注册：POST /api/register\n用户登录：POST /api/login\n获取用户信息：GET /api/users/{id}\n修改用户信息：PUT /api/users/{id}\n获取用户收藏列表：GET /api/users/{id}/collections\n获取用户评论列表：GET /api/users/{id}/comments\n4.2 后台接口\n4.2.1 文章管理接口\n创建文章：POST /api/admin/articles\n更新文章：PUT /api/admin/articles/{id}\n删除文章：DELETE /api/admin/articles/{id}\n获取文章列表：GET /api/admin/articles\n修改文章状态：PUT /api/admin/articles/{id}/status\n4.2.2 分类管理接口\n创建分类：POST /api/admin/categories\n更新分类：PUT /api/admin/categories/{id}\n删除分类：DELETE /api/admin/categories/{id}\n获取分类列表：GET /api/admin/categories\n4.2.3 标签管理接口\n创建标签：POST /api/admin/tags\n更新标签：PUT /api/admin/tags/{id}\n删除标签：DELETE /api/admin/tags/{id}\n获取标签列表：GET /api/admin/tags\n4.2.4 评论管理接口\n获取评论列表：GET /api/admin/comments\n审核评论：PUT /api/admin/comments/{id}/status\n删除评论：DELETE /api/admin/comments/{id}\n4.2.5 用户管理接口\n获取用户列表：GET /api/admin/users\n更新用户状态：PUT /api/admin/users/{id}/status\n重置用户密码：PUT /api/admin/users/{id}/password\n4.2.6 系统设置接口\n获取博客配置：GET /api/admin/config\n更新博客配置：PUT /api/admin/config\n获取友链列表：GET /api/admin/friendLinks\n创建友链：POST /api/admin/friendLinks\n更新友链：PUT /api/admin/friendLinks/{id}\n删除友链：DELETE /api/admin/friendLinks/{id}\n上传图片：POST /api/admin/upload/image\n5. 开发计划\n5.1 第一阶段 - 基础功能开发\n搭建项目框架，完成基础配置\n完成用户模块开发（注册、登录、信息管理）\n完成文章基础功能（CRUD操作）\n完成分类和标签基础功能\n5.2 第二阶段 - 核心功能开发\n完成文章详情页展示\n实现评论功能\n实现文章点赞、收藏功能\n开发文章搜索功能\n5.3 第三阶段 - 扩展功能开发\n完善首页展示和推荐算法\n实现文章统计和数据分析\n开发博客设置和个性化功能\n实现友情链接管理\n5.4 第四阶段 - 优化和测试\n性能优化（缓存、索引等）\nUI/UX优化\n安全性测试与加固\n全面功能测试与bug修复\n6. 项目部署\n6.1 开发环境\nJDK 17+\nNode.js 18+\nMySQL 8.0+\nMaven 3.8+\n6.2 生产环境\n服务器：Linux (Ubuntu/CentOS)\nWeb服务器：Nginx\n应用服务器：SpringBoot内置Tomcat\n数据库：MySQL 8.0+\n缓存：Redis (可选)\n6.3 部署步骤\n前端项目打包：npm run build\n后端项目打包：mvn clean package\n配置Nginx反向代理\n配置MySQL数据库\n启动后端服务\n配置域名和HTTPS (可选)\n7. 项目维护与更新计划\n7.1 定期维护\n安全漏洞修复\n依赖库更新\n性能监控与优化\n7.2 功能更新计划\n增加社交媒体分享功能\n集成第三方登录\n开发移动端适配\n增加数据统计和分析功能\n集成富文本编辑器选项\n', '<p><br></p><h2 style=\"text-align: start;\">1. 项目概述</h2><p style=\"text-align: start;\">本项目是一个基于SpringBoot+Vue3的个人博客系统，采用前后端分离架构，实现博客内容的发布、管理、展示等功能。系统分为前台展示和后台管理两大部分，为用户提供良好的阅读体验和博主提供便捷的内容管理能力。</p><h3 style=\"text-align: start;\">1.1 技术栈</h3><ul><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>前端</strong></span>：Vue3 + Element Plus + Axios + Vue Router + Pinia</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>后端</strong></span>：Spring Boot + MyBatis-Plus + JWT</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>数据库</strong></span>：MySQL</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>开发工具</strong></span>：IDEA、VS Code</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>版本控制</strong></span>：Git</li></ul><h3 style=\"text-align: start;\">1.2 系统角色</h3><ul><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>游客</strong></span>：未登录用户，可浏览博客内容、搜索文章、查看评论</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>注册用户</strong></span>：可进行评论、点赞、收藏等操作</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>博主/管理员</strong></span>：拥有内容发布、编辑、删除等管理权限</li></ul><h2 style=\"text-align: start;\">2. 功能模块划分</h2><h3 style=\"text-align: start;\">2.1 前台展示模块</h3><h4 style=\"text-align: start;\">2.1.1 首页模块</h4><ul><li style=\"text-align: start;\">博客基本信息展示</li><li style=\"text-align: start;\">最新文章列表</li><li style=\"text-align: start;\">热门文章推荐</li><li style=\"text-align: start;\">文章分类导航</li><li style=\"text-align: start;\">标签云展示</li></ul><h4 style=\"text-align: start;\">2.1.2 文章模块</h4><ul><li style=\"text-align: start;\">文章详情页</li><li style=\"text-align: start;\">文章评论区</li><li style=\"text-align: start;\">文章点赞功能</li><li style=\"text-align: start;\">文章收藏功能</li><li style=\"text-align: start;\">相关文章推荐</li></ul><h4 style=\"text-align: start;\">2.1.3 分类与标签模块</h4><ul><li style=\"text-align: start;\">分类文章列表</li><li style=\"text-align: start;\">标签文章列表</li><li style=\"text-align: start;\">文章归档</li></ul><h4 style=\"text-align: start;\">2.1.4 搜索模块</h4><ul><li style=\"text-align: start;\">全文搜索功能</li><li style=\"text-align: start;\">搜索结果展示</li></ul><h4 style=\"text-align: start;\">2.1.5 用户中心</h4><ul><li style=\"text-align: start;\">用户资料查看与修改</li><li style=\"text-align: start;\">用户评论管理</li><li style=\"text-align: start;\">收藏文章管理</li></ul><h3 style=\"text-align: start;\">2.2 后台管理模块</h3><h4 style=\"text-align: start;\">2.2.1 用户管理</h4><ul><li style=\"text-align: start;\">用户信息管理</li><li style=\"text-align: start;\">用户权限控制</li></ul><h4 style=\"text-align: start;\">2.2.2 文章管理</h4><ul><li style=\"text-align: start;\">文章发布（支持Markdown编辑器）</li><li style=\"text-align: start;\">文章编辑</li><li style=\"text-align: start;\">文章删除</li><li style=\"text-align: start;\">文章状态管理（草稿、已发布、已删除）</li></ul><h4 style=\"text-align: start;\">2.2.3 分类管理</h4><ul><li style=\"text-align: start;\">分类新增</li><li style=\"text-align: start;\">分类编辑</li><li style=\"text-align: start;\">分类删除</li></ul><h4 style=\"text-align: start;\">2.2.4 标签管理</h4><ul><li style=\"text-align: start;\">标签新增</li><li style=\"text-align: start;\">标签编辑</li><li style=\"text-align: start;\">标签删除</li></ul><h4 style=\"text-align: start;\">2.2.5 评论管理</h4><ul><li style=\"text-align: start;\">评论审核</li><li style=\"text-align: start;\">评论回复</li><li style=\"text-align: start;\">评论删除</li></ul><h4 style=\"text-align: start;\">2.2.6 系统设置</h4><ul><li style=\"text-align: start;\">博客基本信息设置</li><li style=\"text-align: start;\">首页轮播图设置</li><li style=\"text-align: start;\">友情链接管理</li><li style=\"text-align: start;\">关于我页面管理</li></ul><h2 style=\"text-align: start;\">3. 数据库设计</h2><h3 style=\"text-align: start;\">3.1 数据库表结构</h3><h4 style=\"text-align: start;\">3.1.1 用户表(user)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">用户ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">username</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空、唯一</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">用户名</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">password</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(100)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">密码(加密存储)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">email</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(100)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空、唯一</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">邮箱</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">phone</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(20)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">手机号</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">role_code</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">角色code(ADMIN/USER)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">name</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">姓名</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">sex</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(255)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">性别</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">avatar</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(200)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">头像</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">status</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tinyint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值1</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">状态(0:禁用,1:正常)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.2 文章表(article)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">title</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(100)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章标题</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">content</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">longtext</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章内容(Markdown格式)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">html_content</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">longtext</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章内容(HTML格式)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">summary</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(255)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章摘要</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">cover_image</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(200)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">封面图片</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">category_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">分类ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">user_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">作者ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">view_count</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">int</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">浏览量</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">like_count</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">int</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">点赞数</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">comment_count</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">int</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">评论数</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">status</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tinyint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值1</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">状态(0:草稿,1:已发布,2:已删除)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">is_top</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tinyint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">是否置顶(0:否,1:是)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">is_recommend</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tinyint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">是否推荐(0:否,1:是)</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.3 文章分类表(category)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">分类ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">name</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">分类名称</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">description</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(200)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">分类描述</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">parent_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">父分类ID(0表示顶级分类)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">order_num</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">int</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">排序号</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.4 标签表(tag)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">标签ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">name</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">标签名称</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">color</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(20)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">标签颜色</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.5 文章标签关联表(article_tag)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">关联ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">article_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tag_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">标签ID</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.6 评论表(comment)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">评论ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">content</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(500)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">评论内容</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">article_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">user_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">评论用户ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">parent_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">父评论ID(0表示顶级评论)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">to_user_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">回复用户ID(0表示不是回复)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">status</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tinyint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值1</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">状态(0:待审核,1:已通过,2:已拒绝)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.7 用户收藏表(user_collect)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">收藏ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">user_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">用户ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">article_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.8 用户点赞表(user_like)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">点赞ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">user_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">用户ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">article_id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">文章ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.9 博客设置表(blog_config)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">设置ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">config_key</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">配置键</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">config_value</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">text</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">配置值</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr></tbody></table><h4 style=\"text-align: start;\">3.1.10 友情链接表(friend_link)</h4><table style=\"width: auto; text-align: start;\"><tbody><tr><th colspan=\"1\" rowspan=\"1\" width=\"auto\">字段名</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">类型</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">约束</th><th colspan=\"1\" rowspan=\"1\" width=\"auto\">说明</th></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">id</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">bigint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">主键、自增</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">链接ID</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">name</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(50)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">链接名称</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">url</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(200)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">非空</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">链接地址</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">logo</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(200)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">链接logo</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">description</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">varchar(200)</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\"></td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">链接描述</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">order_num</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">int</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值0</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">排序号</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">status</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">tinyint</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认值1</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">状态(0:隐藏,1:显示)</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">create_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">创建时间</td></tr><tr><td colspan=\"1\" rowspan=\"1\" width=\"auto\">update_time</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">datetime</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">默认当前时间</td><td colspan=\"1\" rowspan=\"1\" width=\"auto\">更新时间</td></tr></tbody></table><h3 style=\"text-align: start;\">3.2 表关系说明</h3><ol><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>用户与文章</strong></span>：一对多关系，一个用户可以发布多篇文章</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>文章与分类</strong></span>：多对一关系，多篇文章可以属于同一分类</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>文章与标签</strong></span>：多对多关系，通过article_tag表关联</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>用户与评论</strong></span>：一对多关系，一个用户可以发表多条评论</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>文章与评论</strong></span>：一对多关系，一篇文章可以有多条评论</li><li style=\"text-align: start;\"><span style=\"color: rgb(0, 0, 0);\"><strong>评论与评论</strong></span>：自关联，实现评论回复功能</li></ol><h2 style=\"text-align: start;\">4. 接口设计</h2><h3 style=\"text-align: start;\">4.1 前台接口</h3><h4 style=\"text-align: start;\">4.1.1 文章相关接口</h4><ul><li style=\"text-align: start;\">获取首页文章列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/articles</code></span></li><li style=\"text-align: start;\">获取文章详情：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/articles/{id}</code></span></li><li style=\"text-align: start;\">获取推荐文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/articles/recommend</code></span></li><li style=\"text-align: start;\">获取最热文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/articles/hot</code></span></li><li style=\"text-align: start;\">文章搜索：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/articles/search?keyword={keyword}</code></span></li><li style=\"text-align: start;\">获取分类文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/categories/{id}/articles</code></span></li><li style=\"text-align: start;\">获取标签文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/tags/{id}/articles</code></span></li><li style=\"text-align: start;\">文章点赞：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/articles/{id}/like</code></span></li><li style=\"text-align: start;\">文章收藏：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/articles/{id}/collect</code></span></li></ul><h4 style=\"text-align: start;\">4.1.2 分类标签接口</h4><ul><li style=\"text-align: start;\">获取所有分类：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/categories</code></span></li><li style=\"text-align: start;\">获取所有标签：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/tags</code></span></li></ul><h4 style=\"text-align: start;\">4.1.3 评论相关接口</h4><ul><li style=\"text-align: start;\">获取文章评论：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/articles/{id}/comments</code></span></li><li style=\"text-align: start;\">发表评论：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/comments</code></span></li><li style=\"text-align: start;\">回复评论：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/comments/{id}/reply</code></span></li></ul><h4 style=\"text-align: start;\">4.1.4 用户相关接口</h4><ul><li style=\"text-align: start;\">用户注册：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/register</code></span></li><li style=\"text-align: start;\">用户登录：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/login</code></span></li><li style=\"text-align: start;\">获取用户信息：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/users/{id}</code></span></li><li style=\"text-align: start;\">修改用户信息：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/users/{id}</code></span></li><li style=\"text-align: start;\">获取用户收藏列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/users/{id}/collections</code></span></li><li style=\"text-align: start;\">获取用户评论列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/users/{id}/comments</code></span></li></ul><h3 style=\"text-align: start;\">4.2 后台接口</h3><h4 style=\"text-align: start;\">4.2.1 文章管理接口</h4><ul><li style=\"text-align: start;\">创建文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/admin/articles</code></span></li><li style=\"text-align: start;\">更新文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/articles/{id}</code></span></li><li style=\"text-align: start;\">删除文章：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>DELETE /api/admin/articles/{id}</code></span></li><li style=\"text-align: start;\">获取文章列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/articles</code></span></li><li style=\"text-align: start;\">修改文章状态：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/articles/{id}/status</code></span></li></ul><h4 style=\"text-align: start;\">4.2.2 分类管理接口</h4><ul><li style=\"text-align: start;\">创建分类：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/admin/categories</code></span></li><li style=\"text-align: start;\">更新分类：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/categories/{id}</code></span></li><li style=\"text-align: start;\">删除分类：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>DELETE /api/admin/categories/{id}</code></span></li><li style=\"text-align: start;\">获取分类列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/categories</code></span></li></ul><h4 style=\"text-align: start;\">4.2.3 标签管理接口</h4><ul><li style=\"text-align: start;\">创建标签：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/admin/tags</code></span></li><li style=\"text-align: start;\">更新标签：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/tags/{id}</code></span></li><li style=\"text-align: start;\">删除标签：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>DELETE /api/admin/tags/{id}</code></span></li><li style=\"text-align: start;\">获取标签列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/tags</code></span></li></ul><h4 style=\"text-align: start;\">4.2.4 评论管理接口</h4><ul><li style=\"text-align: start;\">获取评论列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/comments</code></span></li><li style=\"text-align: start;\">审核评论：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/comments/{id}/status</code></span></li><li style=\"text-align: start;\">删除评论：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>DELETE /api/admin/comments/{id}</code></span></li></ul><h4 style=\"text-align: start;\">4.2.5 用户管理接口</h4><ul><li style=\"text-align: start;\">获取用户列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/users</code></span></li><li style=\"text-align: start;\">更新用户状态：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/users/{id}/status</code></span></li><li style=\"text-align: start;\">重置用户密码：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/users/{id}/password</code></span></li></ul><h4 style=\"text-align: start;\">4.2.6 系统设置接口</h4><ul><li style=\"text-align: start;\">获取博客配置：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/config</code></span></li><li style=\"text-align: start;\">更新博客配置：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/config</code></span></li><li style=\"text-align: start;\">获取友链列表：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>GET /api/admin/friendLinks</code></span></li><li style=\"text-align: start;\">创建友链：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/admin/friendLinks</code></span></li><li style=\"text-align: start;\">更新友链：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>PUT /api/admin/friendLinks/{id}</code></span></li><li style=\"text-align: start;\">删除友链：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>DELETE /api/admin/friendLinks/{id}</code></span></li><li style=\"text-align: start;\">上传图片：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>POST /api/admin/upload/image</code></span></li></ul><h2 style=\"text-align: start;\">5. 开发计划</h2><h3 style=\"text-align: start;\">5.1 第一阶段 - 基础功能开发</h3><ol><li style=\"text-align: start;\">搭建项目框架，完成基础配置</li><li style=\"text-align: start;\">完成用户模块开发（注册、登录、信息管理）</li><li style=\"text-align: start;\">完成文章基础功能（CRUD操作）</li><li style=\"text-align: start;\">完成分类和标签基础功能</li></ol><h3 style=\"text-align: start;\">5.2 第二阶段 - 核心功能开发</h3><ol><li style=\"text-align: start;\">完成文章详情页展示</li><li style=\"text-align: start;\">实现评论功能</li><li style=\"text-align: start;\">实现文章点赞、收藏功能</li><li style=\"text-align: start;\">开发文章搜索功能</li></ol><h3 style=\"text-align: start;\">5.3 第三阶段 - 扩展功能开发</h3><ol><li style=\"text-align: start;\">完善首页展示和推荐算法</li><li style=\"text-align: start;\">实现文章统计和数据分析</li><li style=\"text-align: start;\">开发博客设置和个性化功能</li><li style=\"text-align: start;\">实现友情链接管理</li></ol><h3 style=\"text-align: start;\">5.4 第四阶段 - 优化和测试</h3><ol><li style=\"text-align: start;\">性能优化（缓存、索引等）</li><li style=\"text-align: start;\">UI/UX优化</li><li style=\"text-align: start;\">安全性测试与加固</li><li style=\"text-align: start;\">全面功能测试与bug修复</li></ol><h2 style=\"text-align: start;\">6. 项目部署</h2><h3 style=\"text-align: start;\">6.1 开发环境</h3><ul><li style=\"text-align: start;\">JDK 17+</li><li style=\"text-align: start;\">Node.js 18+</li><li style=\"text-align: start;\">MySQL 8.0+</li><li style=\"text-align: start;\">Maven 3.8+</li></ul><h3 style=\"text-align: start;\">6.2 生产环境</h3><ul><li style=\"text-align: start;\">服务器：Linux (Ubuntu/CentOS)</li><li style=\"text-align: start;\">Web服务器：Nginx</li><li style=\"text-align: start;\">应用服务器：SpringBoot内置Tomcat</li><li style=\"text-align: start;\">数据库：MySQL 8.0+</li><li style=\"text-align: start;\">缓存：Redis (可选)</li></ul><h3 style=\"text-align: start;\">6.3 部署步骤</h3><ol><li style=\"text-align: start;\">前端项目打包：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>npm run build</code></span></li><li style=\"text-align: start;\">后端项目打包：<span style=\"color: rgb(0, 0, 0); background-color: rgb(240, 240, 240);\"><code>mvn clean package</code></span></li><li style=\"text-align: start;\">配置Nginx反向代理</li><li style=\"text-align: start;\">配置MySQL数据库</li><li style=\"text-align: start;\">启动后端服务</li><li style=\"text-align: start;\">配置域名和HTTPS (可选)</li></ol><h2 style=\"text-align: start;\">7. 项目维护与更新计划</h2><h3 style=\"text-align: start;\">7.1 定期维护</h3><ul><li style=\"text-align: start;\">安全漏洞修复</li><li style=\"text-align: start;\">依赖库更新</li><li style=\"text-align: start;\">性能监控与优化</li></ul><h3 style=\"text-align: start;\">7.2 功能更新计划</h3><ul><li style=\"text-align: start;\">增加社交媒体分享功能</li><li style=\"text-align: start;\">集成第三方登录</li><li style=\"text-align: start;\">开发移动端适配</li><li style=\"text-align: start;\">增加数据统计和分析功能</li><li style=\"text-align: start;\">集成富文本编辑器选项</li></ul><p><br></p>', '本项目是一个基于SpringBoot+Vue3的个人博客系统，采用前后端分离架构，实现博客内容的发布、管理、展示等功能', '/img/1.jpg', 1, 1, 1145, 3, 3, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 1, 0);

INSERT INTO `article` VALUES (2, '第1章 Vue 3 简介', '', '<h2>一、Web前端框架发展历程</h2><h3>1.1 前端框架的诞生背景</h3><p>在第一次浏览器战争中，Netscape被微软击败后创办了Mozilla技术社区。该社区推出了符合W3C标准的Firefox浏览器，它和Opera浏览器一起代表了W3C阵营，并与IE浏览器开始了第二次浏览器战争。不同的浏览器技术标准之间存在较大的差异，这给开发带来了严重的兼容性问题。</p><p>为了解决这个问题，出现了一些前端兼容框架，如Dojo、Mooltools、YUI、ExtJS和jQuery等，其中<strong>jQuery</strong>的应用范围最为广泛。</p><h3>1.2 从Web Site到Web App的进化</h3><p>近年来各大浏览器开始支持HTML 5，前端实现的交互功能随之增加，相应的代码复杂度显著提高。用于后端的MVC模式开始应用于Web前端开发。从2010年10月出现的Backbone开始，Knockout、Angular、Ember、React、Vue等框架相继出现。这些框架的应用使Web Site从Web Site进化成Web App，并开启了Web App的<strong>SPA（Single Page Application，单页面应用）</strong>时代。</p><h3>1.3 MVC模式详解</h3><p>典型的MVC模式将程序分为以下3个部分：</p><ul><li><strong>Model（模型）</strong>：用于表示应用程序的核心数据部分</li><li><strong>View（视图）</strong>：用于展示效果、生成HTML页面等</li><li><strong>Controller（控制器）</strong>：用于处理输入，如业务逻辑等</li></ul><p>MVC模式的优点主要有以下三个：</p><ol><li><strong>松耦合性</strong>：各部分职责分离，降低依赖</li><li><strong>高重用性</strong>：组件可在不同场景复用</li><li><strong>低生命周期成本</strong>：便于维护和扩展</li></ol><h3>1.4 从MVC到MVVM</h3><p>MVP模式是从MVC模式演变而来的，其基本思想与MVC模式相似。MVVM模式将MVP模式的View的状态和行为抽象化，并将视图UI和业务逻辑分离，这是Vue框架所采用的核心设计模式。</p><h2>二、认识Vue 3</h2><h3>2.1 什么是Vue 3</h3><p>Vue 3是一个基于MVVM模式的用于构建用户界面的<strong>渐进式JavaScript框架</strong>，可以根据项目的复杂度和需求灵活地选择不同的层次和功能：</p><ul><li>对于简单的系统，可以采用Vue 3的<strong>声明式渲染机制</strong></li><li>对于复杂的系统，可以方便地接入Vue 3组件系统、Vue-router前端路由和Vuex状态管理等功能，实现前后端分离项目或者多组件状态共享的需求</li><li>Vue 3提供的构建系统可以帮助开发者快速地构建一个脚手架项目，并提供了运行环境和打包工具等功能，方便开发、调试和构建发布版本</li></ul><h3>2.2 Vue 3的8大改进</h3><ol><li><strong>全面提高了性能</strong>：渲染速度和内存使用都有显著提升</li><li><strong>编译体积更小</strong>：Tree-shaking支持，按需引入</li><li><strong>Composition API</strong>：更灵活的代码组织方式，替代Options API</li><li><strong>组件多节点支持</strong>：Fragment片段，组件可以有多个根节点</li><li><strong>更灵活的组件渲染</strong>：Teleport传送门、Suspense异步依赖</li><li><strong>更先进的组件</strong>：更好的逻辑复用机制</li><li><strong>更好地支持TypeScript</strong>：源码使用TS重写，类型推断更完善</li><li><strong>支持自定义渲染API</strong>：可以创建自定义渲染器</li></ol><h3>2.3 Vue 3的5大优势</h3><ol><li><strong>体积较小</strong>：压缩后只有33KB</li><li><strong>基于虚拟DOM技术</strong>：通过预先进行各种计算来优化DOM对象的操作，避免直接操作DOM对象，具有更高的运行效率</li><li><strong>支持双向数据绑定</strong>：使开发人员无须直接操作DOM对象，可以将更多精力投入到业务逻辑上</li><li><strong>生态丰富，具有较低学习成本</strong>：市场上存在许多成熟稳定的基于Vue 3的UI框架和组件，可快速实现开发</li><li><strong>对于初学者友好</strong>：易于入门，并提供大量学习资料</li></ol><h2>三、开发环境搭建</h2><h3>3.1 选择IDE</h3><p>对于开发者而言，优秀的IDE（Integrated Development Environment，集成开发环境）可以极大地提高开发效率。<strong>VSCode（Visual Studio Code）</strong>是微软推出的一款轻量级代码编辑器，它免费、开源而且功能强大。主要特性包括：</p><ul><li>支持几乎所有主流的程序语言的<strong>语法高亮</strong></li><li><strong>智能代码补全</strong></li><li><strong>自定义热键</strong></li><li><strong>括号匹配</strong></li><li><strong>代码片段</strong></li><li><strong>代码对比Diff</strong></li><li><strong>GIT版本控制</strong></li><li>丰富的<strong>插件扩展</strong></li></ul><p>软件跨平台支持Windows、macOS及Linux，并针对网页开发和云端应用开发做了优化。</p><h3>3.2 配置Node.js环境</h3><p>Node.js是运行JavaScript代码的服务器端环境，Vue 3的开发依赖Node.js。配置步骤如下：</p><ol><li>打开Node.js官网http://nodejs.cn/，找到Node.js下载页面</li><li>根据系统版本下载相应的Node.js安装包，双击下载文件按照提示选项完成Node.js的安装</li><li>macOS用户也可以使用Homebrew进行Node.js的安装。安装Homebrew后，在控制台执行<code>brew install node@14</code>就可以方便地安装Node.js 14</li><li>执行 <code>node -v</code> 指令和 <code>npm -v</code> 指令可以查看node版本和npm版本</li></ol><h3>3.3 安装Vue 3的四种方式</h3><h4>方式一：独立安装版本</h4><p>独立版本安装需要以下两个步骤，本质是将编译好的Vue 3的JavaScript脚本下载到本地，和现有项目一起部署在服务器上，并在页面中引用。</p><ol><li>下载Vue 3。可以在Vue 3的官网上下载最新版本：https://unpkg.com/vue@3.2.31/dist/vue.global.js</li><li>引入Vue 3。在HTML文件中用标签&lt;script&gt;引入Vue 3文件</li></ol><h4>方式二：CDN方式安装</h4><p>Vue 3给出了一个推荐的CDN链接，在页面中使用&lt;script&gt;标签引入：</p><pre>&lt;script src="https://unpkg.com/vue@next"&gt;&lt;/script&gt;</pre><p>对于生产环境，推荐连接一个明确的版本号和构建文件，以避免新版本造成的不可预期的破坏：</p><pre>&lt;script src="https://unpkg.com/vue@3.2.31/dist/vue.global.js"&gt;&lt;/script&gt;</pre><p>如果使用原生ES Module，可以导入一个兼容ES Module的构建文件：</p><pre>&lt;script type="module"&gt;
  import Vue from ''https://cdn.jsdelivr.net/npm/vue@3.2.31/dist/vue.esm-browser.prod.js''
&lt;/script&gt;</pre><h4>方式三：npm方式安装</h4><pre># 安装Vue 3最新稳定版
$ npm install vue@next

# 更新Vue 3
$ npm update vue@next

# 卸载Vue 3
$ npm uninstall vue@next</pre><p>有时访问npm源速度会很慢，建议使用淘宝npm镜像：</p><pre>$ npm install -g cnpm --registry=https://registry.npm.taobao.org
$ cnpm install vue@next</pre><h4>方式四：使用前端脚手架安装</h4><p>前端脚手架指通过选择几个选项快速搭建项目基础代码的工具。常见的Vue 3脚手架有<strong>Vue CLI</strong>和<strong>Vite</strong>，第9章会详细讲解。前端脚手架会在初始化的时候自动地帮助开发者安装好Vue 3。</p><h3>3.4 熟悉vue-devtools调试工具</h3><p>vue-devtools是一款基于Chrome浏览器的插件，它用于调试Vue 3应用，可以极大地提高调试效率。安装方式有以下两种：</p><ol><li><strong>从Chrome商店中安装</strong>：vue-devtools可以从Chrome商店中直接下载安装</li><li><strong>手动安装</strong>：
    <ol type="a">
      <li>在命令行中执行<code>git clone https://github.com/vuejs/vue-devtools.git</code>命令，将Github项目克隆到本地</li>
      <li>在命令行中执行<code>npm install</code>命令，安装项目所需的npm包</li>
      <li>在命令行中执行<code>npm run build</code>命令，编译项目文件</li>
      <li>在浏览器中输入地址<code>chrome://extensions/</code>进入扩展程序页面，单击"加载已解压的扩展程序..."按钮，选择vue-devtools > shells下的Chrome文件夹，将vue-devtools添加至Chrome浏览器</li>
    </ol>
  </li></ol>', '介绍Web前端框架发展历程、Vue 3框架的MVVM模式特性、8大改进与5大优势，以及VSCode IDE选择、Node.js环境配置、Vue 3四种安装方式和vue-devtools调试工具的使用', '/img/2.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (3, '第2章 Hello World 与 Vue 3 基础特性', '', '<h2>一、Hello World示例</h2><h3>1.1 基本数据绑定演示</h3><p>Vue 3的最基本使用方法是通过createApp创建应用实例，并在data()函数中返回数据对象。以下代码演示了多种数据绑定方式：</p><pre>&lt;div id=''app''&gt;
    &lt;!-- 简单文本插值 --&gt;
    &lt;p&gt;{{message}}&lt;/p&gt;
    &lt;!-- JavaScript表达式 --&gt;
    &lt;p&gt;{{message.toUpperCase()}}&lt;/p&gt;
    &lt;!-- 简单文本插值 --&gt;
    &lt;p&gt;{{spanHTML}}&lt;/p&gt;
    &lt;!-- 输出HTML --&gt;
    &lt;p v-html="spanHTML"&gt;&lt;/p&gt;
    &lt;!-- 绑定数据 --&gt;
    &lt;a v-bind:href="url"&gt;Vue.js&lt;/a&gt;
&lt;/div&gt;</pre><pre>const RootComponent = {
    data() {
        return {
            message: ''Hello Vue.js'',
            url: ''https://v3.cn.vuejs.org/'',
            spanHTML: ''&lt;span style="color: red"&gt;这是一段红色的文字&lt;/span&gt;''
        };
    }
};
const vm = Vue.createApp(RootComponent).mount(''#app'');</pre><p>这段代码演示了Vue 3的最基本的使用方法，实现了数据的绑定。在data()函数中返回的值将在页面中显示。</p><h3>1.2 组件树结构</h3><p>典型的项目的组件树可能如下所示，体现了Vue组件化的开发思想：</p><pre>RootComponent
└─ TodoList
   ├─ TodoItem
   │  ├─ TodoButtonDelete
   │  └─ TodoButtonEdit
   └─ TodoListFooter
      ├─ TodosButtonClear
      └─ TodoListStatistics</pre><h2>二、Vue 3组件的生命周期</h2><h3>2.1 认识生命周期</h3><p>Vue 3组件的生命周期涵盖了从创建到销毁的完整过程：</p><ol><li>创建实例</li><li>初始化数据</li><li>编译模板</li><li>挂载DOM</li><li>渲染</li><li>更新</li><li>最终卸载实例</li></ol><h3>2.2 8个钩子函数</h3><p>Vue 3提供了以下8个钩子函数，开发者可以在不同阶段执行自定义逻辑：</p><ul><li><strong>beforeCreate（创建前）</strong>：实例初始化之后，数据观测和事件配置之前调用</li><li><strong>created（创建后）</strong>：实例创建完成，数据观测、属性和方法运算已完成，但DOM未生成</li><li><strong>beforeMount（载入前）</strong>：在挂载开始之前被调用，相关的render函数首次被调用</li><li><strong>mounted（载入后）</strong>：实例被挂载到DOM后调用，此时可以访问DOM元素</li><li><strong>beforeUpdate（更新前）</strong>：数据更新时调用，发生在虚拟DOM打补丁之前</li><li><strong>updated（更新后）</strong>：由于数据更改导致的虚拟DOM重新渲染和打补丁后调用</li><li><strong>beforeUnmount（卸载前）</strong>：实例销毁之前调用，实例仍然完全可用</li><li><strong>unmounted（销毁后）</strong>：实例销毁后调用，所有绑定被解除，所有子实例被销毁</li></ul><h2>三、数据绑定详解</h2><h3>3.1 文本插值</h3><p>数据绑定最常见的形式是使用<strong>Mustache语法（双大括号）</strong>的文本插值。Mustache语法标签会被替换为相应数据对象中属性的值，如果绑定的数据对象上的属性值发生更改，插值处的内容会自动更新。</p><pre>&lt;span&gt;Message: {{ msg }}&lt;/span&gt;
&lt;script&gt;
  const app = {
    data() {
      return { msg: ''Hello Vue.js'' };
    }
  };
  const vm = Vue.createApp(app).mount(''#app'');
&lt;/script&gt;</pre><p>在控制台中输入<code>vm.msg = "welcome"</code>，可以看到页面中的文字立刻进行了更新。另外，通过使用<strong>v-once</strong>指令，开发者也可以实现一次性的插值，即当数据改变时，插值处的内容不会更新：</p><pre>&lt;span v-once&gt;这个将不会改变: {{ msg }}&lt;/span&gt;</pre><h3>3.2 插入原始HTML</h3><p>如果要绑定的数据是HTML代码，需要使用<strong>v-html</strong>指令。Mustache语法不能作用在HTML属性上，应该使用<strong>v-bind</strong>指令。</p><pre>&lt;p&gt;Using mustaches: {{ rawHtml }}&lt;/p&gt;
&lt;p&gt;Using v-html directive: &lt;span v-html="rawHtml"&gt;&lt;/span&gt;&lt;/p&gt;
&lt;div v-bind:id="dynamicId"&gt;&lt;/div&gt;</pre><p>如果isButtonDisabled的值是null、undefined或false，则disabled属性甚至不会被包含在渲染出来的&lt;button&gt;元素中：</p><pre>&lt;button v-bind:disabled="isButtonDisabled"&gt;Button&lt;/button&gt;</pre><h3>3.3 使用JavaScript表达式</h3><p>实际上对于所有的数据绑定，Vue 3都提供了完全的JavaScript表达式支持，这些表达式会在所属实例的作用域下作为JavaScript被解析，<strong>每个绑定都只能包含单个表达式</strong>：</p><pre>{{ number + 1 }}
{{ ok ? ''YES'' : ''NO'' }}
{{ message.split('''').reverse().join('''') }}
&lt;div v-bind:id="''list-'' + id"&gt;&lt;/div&gt;</pre><h2>四、案例实践</h2><h3>4.1 利用表单实现简单登录页面</h3><p>构建一个简单的登录页面，核心代码如下：</p><pre>const app = {
    data() {
        return {
            title: ''登 录'',
            accountTitle: ''用户名'',
            passwordTitle: ''密码'',
            rememberTitle: ''记住我'',
            ext: ''忘记密码？''
        };
    }
};
const vm = Vue.createApp(app).mount(''#app'');</pre><h3>4.2 利用计算属性过滤指定字符</h3><p>在实际的前端工程中，经常需要开发者屏蔽一些特殊字符。假设有这样一个页面，其中包含一个输入框，当用户在输入框中输入内容时，页面会实时显示用户的输入内容，并将其中的所有小写字母转化为大写字母，相当于对字符串进行格式化。</p><p>使用Vue 3中的<strong>计算属性</strong>来实现对输入内容的格式化处理，具体步骤如下：</p><ol><li>在Vue 3实例中定义一个数据属性inputText来保存用户输入的内容</li><li>使用<strong>v-model</strong>指令将inputText与输入框绑定，实现输入内容的实时更新</li><li>使用计算属性将inputText中的所有小写字母转化为大写字母，并将格式化后的内容作为计算属性的返回值</li><li>使用Mustache语法将格式化后的内容渲染到页面中</li></ol><pre>&lt;div id=''app''&gt;
    &lt;div class="translate-main"&gt;
        &lt;div class="trans-left"&gt;
            &lt;div class="trans-input-wrap"&gt;
                &lt;div class="input-wrap"&gt;
                    &lt;div class="textarea-wrap"&gt;
                        &lt;textarea v-model="notedata" class="textarea" placeholder="输入内容"&gt;&lt;/textarea&gt;
                    &lt;/div&gt;
                &lt;/div&gt;
            &lt;/div&gt;
        &lt;/div&gt;
        &lt;div class="trans-right"&gt;
            &lt;div class="output-wrap output-blank"&gt;{{toUpperCase}}&lt;/div&gt;
        &lt;/div&gt;
    &lt;/div&gt;
&lt;/div&gt;</pre><pre>const app = {
    data() {
        return { notedata: null };
    },
    computed: {
        toUpperCase() {
            if(!this.notedata) { return ''''; }
            return this.notedata.toUpperCase();
        }
    }
};
const vm = Vue.createApp(app).mount(''#app'');</pre>', '通过Hello World示例讲解Vue 3基础语法与数据绑定，详细介绍组件8个生命周期钩子函数，深入讲解文本插值、v-html、v-bind及JavaScript表达式，最后通过登录页面和计算属性转大写两个案例巩固知识', '/img/3.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (4, '第3章 Vue 3 基本指令', '', '<h2>一、条件渲染指令</h2><h3>1.1 v-if、v-else-if、v-else</h3><p>条件渲染指令的主要功能是根据指令的值为true或false进而触发组件不同的表现形式。指令的主要职责是在其值发生改变时，将相应的影响作用于DOM对象。v-if、v-else-if和v-else这三个指令用于实现条件判断，在true和false之间切换时，元素或组件将被<strong>销毁或重建</strong>。</p><pre>&lt;div id="app"&gt;
  &lt;h1 v-if="display"&gt;Display&lt;/h1&gt;
  &lt;h1 v-if="hide"&gt;Hide&lt;/h1&gt;
  &lt;h1 v-if="age &gt;= 25"&gt;Age: {{ age }}&lt;/h1&gt;
  &lt;h1 v-if="name.indexOf(''Tom'')&gt;=0"&gt;Name:{{name}}&lt;/h1&gt;
&lt;/div&gt;

&lt;script&gt;
  const vm = Vue.createApp({
    data() {
      return {
        display: true,
        hide: false,
        age: 28,
        name: ''Tom Cruise''
      }
    }
  }).mount(''#app'');
&lt;/script&gt;</pre><p>将age属性的值修改为20（即<code>vm.age = 20</code>），条件不满足时元素不会被渲染。</p><p><strong>注意事项：</strong></p><ul><li>如需控制多个元素的创建或删除，可以使用&lt;template&gt;元素将这些元素包装起来，然后在&lt;template&gt;元素上使用v-if指令</li><li>当一个条件被满足时，后续的条件判断都不会再执行</li><li>v-else-if和v-else需要紧跟在v-if或v-else-if之后</li></ul><pre>&lt;div id="app"&gt;
  &lt;template v-if="!isLogin"&gt;
    &lt;form&gt;
      &lt;p&gt;username:&lt;input type="text"&gt;&lt;/p&gt;
      &lt;p&gt;password:&lt;input type="password"&gt;&lt;/p&gt;
    &lt;/form&gt;
  &lt;/template&gt;
&lt;/div&gt;</pre><h3>1.2 v-show指令</h3><p>v-show指令根据其值切换元素的CSS样式中的<strong>display属性</strong>，当条件变化时，该指令会触发过渡效果。</p><pre>&lt;div id="app"&gt;
  &lt;h1 v-show="display"&gt;Display&lt;/h1&gt;
  &lt;h1 v-show="hide"&gt;Hide&lt;/h1&gt;
&lt;/div&gt;</pre><p><strong>v-show与v-if的区别：</strong></p><ul><li>v-show的值是true还是false，v-show指令<strong>都会创建元素</strong>，它通过CSS样式中的display属性来控制元素是否显示</li><li>当v-if的值为false时，v-if指令<strong>不会创建</strong>该元素</li><li>只有当v-if的值为true时，v-if指令才会真正创建该元素</li><li>从页面展示效果来看两者似乎没有不同，但在页面结构中有本质区别</li></ul><h2>二、列表渲染指令v-for</h2><h3>2.1 基本用法</h3><p>列表渲染指令的主要功能是根据数组的值来进行列表的遍历循环，从而快速的渲染HTML结构，使代码具有整洁性、开发的快速和便捷性。v-for指令基于一个数组来渲染一个列表，需要使用<strong>item in items</strong>形式的特殊语法，其中items是源数据数组，item是被迭代的数组元素的别名。</p><pre>&lt;ul id="array-rendering"&gt;
  &lt;li v-for="item in items"&gt;{{ item.message }}&lt;/li&gt;
&lt;/ul&gt;
&lt;script&gt;
  const vm = Vue.createApp({
    data() {
      return {
        items: [{ message: ''Foo'' }, { message: ''Bar'' }]
      }
    }
  }).mount(''#app'');
&lt;/script&gt;</pre><p>在v-for块中，可以访问所有父作用域的属性，item是数组中元素的别名，在每次循环时，item的值为数组当前索引的值。</p><h3>2.2 遍历对象与获取索引</h3><p>v-for还支持一个可选的第二个参数，也可以用v-for来遍历一个对象的所有可枚举属性：</p><pre>&lt;ul id="v-for-object" class="demo"&gt;
  &lt;li v-for="value of myObject"&gt;{{ value }}&lt;/li&gt;
&lt;/ul&gt;</pre><p>可以增加第三个参数来获取索引：</p><pre>&lt;li v-for="(value, name, index) in myObject"&gt;
  {{ index }}. {{ name }}: {{ value }}
&lt;/li&gt;</pre><h3>2.3 key的重要性</h3><p>Vue 3默认采用<strong>"就地更新"策略</strong>。如果数据项的顺序被更改，Vue 3将不会移动页面元素来匹配数据项的顺序，而是就地更新每个元素，并确保它们在每个索引位置被正确渲染。<strong>建议在使用v-for指令时尽可能提供key值</strong>，这样可以提高v-for的渲染效率：</p><pre>&lt;div v-for="item in items" :key="item.id"&gt;
  &lt;!-- 内容 --&gt;
&lt;/div&gt;</pre><h3>2.4 v-for的其他操作</h3><p>v-for可以用来显示数组过滤或排序后的结果。如果要显示一个数组经过过滤或排序后的版本，而不改变原始数据，可以创建一个计算属性来返回处理后的数组。v-for循环中无法使用计算属性时，可以使用methods()函数来解决。</p><pre>const vm = Vue.createApp({
    data() {
      return { sets: [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]] }
    },
    methods: {
      even(numbers) {
        return numbers.filter(number =&gt; number % 2 === 0)
      }
    }
  }).mount(''#app'');</pre><p>v-for也可以接受整数n作为迭代参数，模板会重复循环n次：</p><pre>&lt;div id="range" class="demo"&gt;
  &lt;span v-for="n in 10" :key="n"&gt;{{ n }} &lt;/span&gt;
&lt;/div&gt;</pre><p>可以利用带有v-for的&lt;template&gt;来循环渲染一段包含多个元素的内容。<strong>注意：当它们处于同一节点时，v-if的优先级比v-for更高</strong>，这意味着v-if将没有权限访问v-for中的变量。</p><h2>三、数据绑定指令v-bind</h2><h3>3.1 基本用法</h3><p>v-bind的主要作用是<strong>动态更新HTML元素上的属性</strong>，同时也可以动态绑定组件的props属性，可以使用简写的符号<strong>":"</strong>来代替它。</p><pre>&lt;div id="app"&gt;
  &lt;a v-bind:href="url"&gt;前往百度&lt;/a&gt;
&lt;/div&gt;</pre><h3>3.2 对象形式绑定</h3><p>v-bind指令不需要接收参数时，可以直接使用对象形式绑定多个属性：</p><pre>&lt;form v-bind="formObj"&gt;
  &lt;input type="text"&gt;
&lt;/form&gt;</pre><pre>formObj: { method: ''get'', action: ''#'' }</pre><p>Vue 3官方提供了简写方式:bind。注意绑定顺序会影响最终渲染结果：</p><pre>&lt;!-- 模板 --&gt;
&lt;div id="red" v-bind="{ id: ''blue'' }"&gt;&lt;/div&gt;
&lt;!-- 结果：id="blue" --&gt;

&lt;!-- 模板 --&gt;
&lt;div v-bind="{ id: ''blue'' }" id="red"&gt;&lt;/div&gt;
&lt;!-- 结果：id="red" --&gt;</pre><h2>四、v-model与表单</h2><h3>4.1 双向数据绑定</h3><p>v-model指令用于在表单中的&lt;input&gt;、&lt;textarea&gt;和&lt;select&gt;元素上创建<strong>双向数据绑定</strong>，负责监听用户的输入事件从而更新数据，并对一些极端场景进行特殊处理。</p><pre>&lt;div id="app"&gt;
  &lt;input type="text" v-model="message"&gt;
&lt;/div&gt;</pre><p>在开发者工具的控制台窗口中，输入<code>vm.message = ''Welcome to the Vue world''</code>，可以看到v-model绑定的表达式数据发生改变，导致页面元素的值随之改变。</p><h3>4.2 值绑定</h3><p><strong>复选框</strong>：在使用单个复选框时，可以使用两个特殊的属性true-value和false-value来指定选中状态下和未选中状态下v-model绑定的值。</p><pre>&lt;input id="agreement" type="checkbox" v-model="isAgree" true-value="yes" false-value="no"&gt;</pre><p><strong>单选按钮</strong>：被选中时，v-model绑定的数据属性的值默认被设置为该单选按钮的value值。可以使用v-bind将value属性再绑定到另一个数据属性上。</p><pre>&lt;input id="male" type="radio" v-model="gender" :value="genderVal[0]"&gt;
&lt;label for="male"&gt;男&lt;/label&gt;</pre><p><strong>选择框</strong>：选项的value属性也可以使用v-bind指令绑定到一个数据属性上，或者将value属性绑定到一个对象字面量上。</p><h3>4.3 修饰符</h3><ul><li><strong>.trim修饰符</strong>：用于自动过滤用户输入内容首尾两端的空格</li><li><strong>.lazy修饰符</strong>：用于将v-model的默认触发方式由input事件更改为change事件</li><li><strong>.number修饰符</strong>：用于自动将用户输入的数据转换为数值类型</li></ul><h2>五、方法、计算属性与监听属性</h2><h3>5.1 methods方法</h3><p>methods选项用于定义组件中的方法，可以在模板中通过插值或事件绑定调用。</p><h3>5.2 computed计算属性</h3><p>在模板中使用表达式非常方便，但如果表达式的逻辑比较复杂，使用计算属性会大大减少模板的复杂度。计算属性是以函数形式在computed选项中定义，默认只有getter。如需修改可以定义setter：</p><pre>computed: {
  fullName: {
    get() { return this.firstName + '' '' + this.lastName; },
    set(newValue) {
      let names = newValue.split('' '');
      this.firstName = names[0];
      this.lastName = names[names.length - 1];
    }
  }
}</pre><h3>5.3 watch监听属性</h3><p>v-on指令（简写"@"）用于绑定事件监听器，还可以接收一个用于调用的函数名称。</p><h3>5.4 自定义指令</h3><p>可以注册全局自定义指令，包含bind、inserted、update、componentUpdated、unbind等钩子函数。</p>', '详解Vue 3条件渲染指令v-if/v-show的区别与使用、列表渲染v-for的数组/对象遍历及key优化、v-bind属性绑定、v-model表单双向绑定与修饰符，以及计算属性、方法和自定义指令的应用', '/img/4.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (5, '第4章 Vue 3 组件', '', '<h2>一、组件基础</h2><h3>1.1 什么是组件</h3><p>组件是Vue 3中最核心的功能之一，可用于前端应用程序的模块化开发，实现系统的<strong>可重用性和可扩展性</strong>。组件是可复用的实例，在根组件实例中可用的选项也可以在组件中使用。开发人员能使用可复用组件系统构建大型应用程序，几乎所有类型的应用程序界面都可以抽象为一棵组件树。</p><h3>1.2 基本使用方法</h3><p>定义一个名为&lt;button-counter&gt;的新组件：</p><pre>Vue.component(''button-counter'', {
  data: function () {
    return { count: 0 }
  },
  template: ''&lt;button v-on:click="count++"&gt;You clicked me {{ count }} times.&lt;/button&gt;''
})</pre><p>组件是可复用的Vue 3实例且带有一个名字。开发者可以在通过new Vue创建的Vue 3根实例中，将这个组件作为自定义元素来使用。组件可以接收与new Vue相同的选项，如data、computed、watch、methods以及钩子函数等，但<strong>el选项例外</strong>。</p><h3>1.3 组件复用的数据独立性</h3><p>每当复用一个组件时，都会创建一个独立的组件实例，每个实例都独立维护它的数据。定义组件时，data选项并不是一个对象，而是一个函数，这是因为组件的data选项<strong>必须返回一个对象的独立拷贝</strong>，以便每个组件实例可以维护自己的一份数据：</p><pre>data: function () {
  return { count: 0 }
}</pre><h3>1.4 组件注册方式</h3><p>需要将组件注册到Vue 3实例中才能使用，组件的注册方式分为<strong>全局注册</strong>和<strong>局部注册</strong>两种。</p><h4>全局注册</h4><p>全局注册组件使用Vue 3实例的component()函数，该函数接收两个参数：组件的名称和组件的配置对象。</p><pre>const app = Vue.createApp({});
app.component(''ButtonCounter'', {
    data() { return { count: 0 } },
    template: ''&lt;button @click="count++"&gt;You clicked me {{ count }} times.&lt;/button&gt;''
});
app.mount(''#app'');</pre><h4>命名规范</h4><ul><li>HTML并不区分元素和属性的大小写，浏览器会把所有大写字符解释为小写字符</li><li>在HTML模板中采用<strong>kebab-case命名</strong>引用组件（&lt;button-counter&gt;）</li><li>注册时采用PascalCase（&lt;ButtonCounter&gt;），可以两种命名引用</li><li>在非HTML模板中可以使用组件的原始名称，且鼓励将没有内容的组件作为<strong>自闭合元素</strong>使用</li></ul><h4>局部注册</h4><p>局部注册是在组件实例的选项对象中使用components选项注册，只能在父组件的模板中使用：</p><pre>const MyComponent = {
    data() { return { count: 0 } },
    template: ''&lt;button v-on:click="count++"&gt;You clicked me {{ count }} times.&lt;/button&gt;''
}
const app = Vue.createApp({
    components: { ButtonCounter: MyComponent }
}).mount(''#app'');</pre><h3>1.5 钩子函数与Composition API</h3><p>Vue 3的Composition API提供了一个<strong>setup()函数</strong>封装了大部分组件代码，并处理了响应式、钩子函数等，可以取代之前的beforeCreate()函数和created()函数。钩子函数必须导入到项目中：</p><pre>import { onMounted, onUpdated, onUnmounted } from ''vue''

export default {
  setup() {
    onBeforeMount(() =&gt; { /* ... */ })
    onMounted(() =&gt; { /* ... */ })
    onBeforeUpdate(() =&gt; { /* ... */ })
    onUpdated(() =&gt; { /* ... */ })
    onBeforeUnmount(() =&gt; { /* ... */ })
    onErrorCaptured(() =&gt; { /* ... */ })
  }
}</pre><h2>二、组件间数据传递</h2><h3>2.1 通过props属性传递数据（父传子）</h3><p>使用组件时可以为组件元素设置属性。首先需要在组件内部注册一些自定义属性，称为<strong>prop</strong>，这些prop是在组件的props选项中定义的，然后就可以将这些prop名称作为元素的属性名来使用，通过属性向组件传递数据。</p><pre>Vue.component(''blog-post'', {
  props: [''title''],
  template: ''&lt;h3&gt;{{ title }}&lt;/h3&gt;''
})</pre><p>一个组件默认可以拥有任意数量的prop，任何值都可以传递给任何prop。</p><h3>2.2 通过"总线"传递数据（任意组件间）</h3><p>事件总线是Vue 3的一个实例，也称作<strong>EventBus</strong>。定义方式：</p><pre>import Vue from ''vue''
export default new Vue()
// 或在main.js中
Vue.prototype.$EventBus = new Vue()</pre><p>发送事件使用的是<strong>$emit()</strong>函数，接收事件使用<strong>$on()</strong>，移除事件使用<strong>$off()</strong>：</p><pre>// 发送事件
bus.$emit(''collapse'', this.collapse)

// 接收事件
bus.$on("collapse", msg =&gt; { this.collapse = msg })

// 移除事件
bus.$off("collapse", {}) // 移除单个事件
bus.$off() // 移除全部事件</pre><h3>2.3 通过监听事件传递数据（子传父）</h3><p>子组件使用<strong>$emit()</strong>函数触发事件，父组件使用v-on指令监听子组件的自定义事件。$emit()函数的语法形式：<code>$emit(eventName, [...args])</code></p><pre>app.component(''child'', {
  data () { return { name: ''张三'' }},
  methods: {
    handleClick() {
      this.$emit(''greet'', this.name);
    }
  },
  template: ''&lt;button @click="handleClick"&gt;开始欢迎&lt;/button&gt;''
})

// 父组件
&lt;child @greet="sayHello"&gt;&lt;/child&gt;</pre><p>与组件和prop不同，事件名<strong>不会自动转换大小写</strong>。调用$emit()函数触发的事件名称需要与用于监听该事件的名称完全匹配。</p><h2>三、内容分发（Slot插槽）</h2><h3>3.1 基本使用方法</h3><p>插槽机制允许在组件中预留位置，由使用组件的地方填充内容。当组件渲染时，&lt;slot&gt;&lt;/slot&gt;将被替换为父组件提供的内容。插槽内可以包含任何模板代码或者组件。如果组件的模板中没有包含&lt;slot&gt;元素，则该组件起始标签和结束标签之间的内容都会被抛弃。</p><h3>3.2 编译作用域</h3><p>插槽跟模板的其他地方一样可以访问相同的实例属性（也就是相同的"作用域"），而<strong>不能访问子组件的作用域</strong>。</p><h3>3.3 后备内容（默认内容）</h3><p>可以给一个插槽设置默认内容，这个内容只会在没有提供内容时被渲染：</p><pre>&lt;button type="submit"&gt;
  &lt;slot&gt;Submit&lt;/slot&gt;
&lt;/button&gt;</pre><h3>3.4 具名插槽</h3><p>有时在项目中需要使用多个插槽，&lt;slot&gt;元素有一个特殊的属性name可以用来定义额外的插槽，没有name属性的&lt;slot&gt;元素会有一个隐含的名字"default"。</p><pre>&lt;div class="container"&gt;
  &lt;header&gt;&lt;slot name="header"&gt;&lt;/slot&gt;&lt;/header&gt;
  &lt;main&gt;&lt;slot&gt;&lt;/slot&gt;&lt;/main&gt;
  &lt;footer&gt;&lt;slot name="footer"&gt;&lt;/slot&gt;&lt;/footer&gt;
&lt;/div&gt;</pre><p>在向具名插槽提供内容的时候，可以在&lt;template&gt;元素上使用<strong>v-slot</strong>指令（简写为<strong>#</strong>），并以v-slot的参数的形式提供其名称。注意v-slot只能添加在&lt;template&gt;上。</p><h3>3.5 作用域插槽</h3><p>有时候让插槽内容能够访问子组件中的数据是非常有用的。绑定在&lt;slot&gt;元素上的属性被称为<strong>插槽prop</strong>，在父级作用域中可以使用带值的v-slot来定义插槽prop的名字：</p><pre>&lt;span&gt;
  &lt;slot v-bind:user="user"&gt;{{ user.lastName }}&lt;/slot&gt;
&lt;/span&gt;

// 父组件使用
&lt;current-user&gt;
  &lt;template v-slot:default="slotProps"&gt;
    {{ slotProps.user.firstName }}
  &lt;/template&gt;
&lt;/current-user&gt;</pre><h3>3.6 动态插槽名</h3><p>动态指令参数也可以用在v-slot上，来定义动态的插槽名：</p><pre>&lt;template v-slot:[dynamicSlotName]&gt;...&lt;/template&gt;</pre><h2>四、其他应用</h2><h3>4.1 动态组件</h3><p>在每次组件切换时，Vue 3都会创建一个新的组件实例。为了避免重复渲染导致的性能问题，可以使用<strong>&lt;keep-alive&gt;</strong>元素将动态组件包裹起来以保持组件状态：</p><pre>&lt;keep-alive&gt;
  &lt;component v-bind:is="currentTabComponent" class="tab"&gt;&lt;/component&gt;
&lt;/keep-alive&gt;</pre><h3>4.2 异步组件</h3><p>在大型应用中有时需要将应用程序分割为小的代码块，并在需要时仅从服务器加载一个模块。Vue 3允许以工厂函数的方式定义组件，这个工厂函数将异步解析组件定义。推荐结合webpack的代码分割功能：</p><pre>// 工厂函数方式
Vue.component(''async-example'', function (resolve, reject) {
  setTimeout(function () {
    resolve({ template: ''&lt;div&gt;I am async!&lt;/div&gt;'' })
  }, 1000)
})

// 动态导入方式（推荐）
Vue.component(''async-webpack-example'', () =&gt; import(''./my-async-component''))

// 命名chunk
const Foo = () =&gt; import(/* webpackChunkName: "group-foo" */ ''./Foo.vue'')</pre>', '详解Vue 3组件化开发核心概念，包括组件注册（全局/局部）、数据传递（Props/EventBus/$emit）、Slot插槽机制（默认/具名/作用域/动态插槽），以及动态组件与异步组件的高级应用', '/img/5.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (6, '第5章 Vue 3 样式绑定', '', '<h2>一、绑定HTML样式（class）</h2><h3>1.1 对象控制样式</h3><p>在Vue 3中，除了可以使用字符串为属性赋值之外，也可以使用对象或数组为属性赋值。可以通过传给<strong>v-bind:class</strong>一个对象，来动态地切换class属性值。当返回的isActive的值为true时，样式被成功渲染；当设置为false后，样式将不会被渲染在页面。</p><pre>&lt;div id=''app''&gt;
  &lt;div v-bind:class="{active:isActive}"&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;script&gt;
  const app = {
    data() { return { isActive: true }; }
  };
  const vm = Vue.createApp(app).mount(''#app'');
&lt;/script&gt;</pre><h3>1.2 与普通class共存</h3><p>在Vue 3中，v-bind:class指令也可以与普通class属性共存，普通的class属性和v-bind:class指令实现了共存：</p><pre>&lt;div class="static" v-bind:class="{
  active: isActive,
  ''text-danger'': hasError
}"&gt;&lt;/div&gt;

data(){
  return {
    isActive: true,
    hasError: false
  }
}</pre><h3>1.3 复杂对象绑定</h3><p>如果需绑定的数据对象比较复杂时，可以选择在数据属性中单独定义一个对象进行绑定，通过返回对象的计算属性来进行绑定也是可行的：</p><pre>// 数据属性中定义对象
data() {
  return{
    classObject: {
      active: true,
      ''text-danger'': false
    }
  }
}

// 计算属性返回对象
computed: {
  classObject() {
    return {
      active: this.isActive &amp;&amp; !this.error,
      ''text-danger'': this.error &amp;&amp; this.error.type === ''fatal''
    }
  }
}</pre><h3>1.4 数组控制样式</h3><p>通过将数组传给v-bind:class，这样会在元素上应用一个样式列表。若想根据条件来切换在列表中的样式时，可以使用三元表达式来切换，简化的对象语法也是可以使用的：</p><pre>// 基础数组语法
&lt;div v-bind:class="[activeClass, errorClass]"&gt;&lt;/div&gt;

// 三元表达式
&lt;div v-bind:class="[isActive?activeClass:'''',errorClass]"&gt;&lt;/div&gt;

// 简化对象语法
&lt;div v-bind:class="[{active: isActive}, errorClass]"&gt;&lt;/div&gt;</pre><h3>1.5 在组件中的应用</h3><p>在一个自定义单根元素组件上使用class属性时，会将样式添加到组件的根元素上，而不会进行覆盖。对于带数据绑定的class属性同样适用。组件中存在多个根元素时，需要通过使用<strong>$attrs</strong>组件属性去指定哪个根元素去接收：</p><pre>app.component(''my-component'', {
  template: ''
    &lt;p :class="$attrs.class"&gt;Hi!&lt;/p&gt;
    &lt;span&gt;This is a child component&lt;/span&gt;
  ''
})</pre><h2>二、绑定内联样式（style）</h2><h3>2.1 对象描述样式</h3><p>v-bind:style可以给元素绑定内联样式，它实际上是一个JS对象。通过在数据属性中定义一个样式对象，进而使用v-bind:style进行绑定：</p><pre>// 内联对象
&lt;div v-bind:style="{
  color: activeColor,
  fontSize: fontSize + ''px''
}"&gt;&lt;/div&gt;

// 数据属性中的样式对象
&lt;div v-bind:style="styleObject"&gt;&lt;/div&gt;
data() {
  return {
    styleObject: {
      color: ''red'',
      fontSize: ''13px''
    }
  }
}</pre><h3>2.2 数组描述样式</h3><p>v-bind:style的数组语法可以将多个样式对象应用到同一个元素上：</p><pre>&lt;div v-bind:style="[baseStyles, moreStyles]"&gt;&lt;/div&gt;
data() {
  return {
    baseStyles: { border: ''solid 2px black'' },
    moreStyles: { width: ''100px'', height: ''100px'', background: ''orange'' }
  }
}</pre><h3>2.3 自动前缀处理</h3><p>当v-bind:style使用需要添加浏览器引擎前缀的CSS属性时，Vue 3会<strong>自动侦测并添加相应的前缀</strong>。可以为绑定的style属性赋一个包含多个带前缀的数组，这样只会渲染数组中最后一个被浏览器支持的值：</p><pre>&lt;div :style="{
  display: [''-webkit-box'', ''-ms-flexbox'', ''flex'']
}"&gt;&lt;/div&gt;</pre><h2>三、实例：实现列表行的奇偶行不同样式</h2><h3>3.1 需求分析</h3><p>实现一个表格，奇数行和偶数行显示不同的背景色，并且支持删除操作。</p><h3>3.2 实现步骤</h3><p>首先定义针对偶数行的样式规则：</p><pre>.even {
  background-color: #cdedcd;
}</pre><p>表格的数据采用v-for指令循环输出，v-for指令可携带一个参数，根据这个索引参数来判断奇偶行：</p><pre>&lt;tr v-for="(book, index) in books" :key="book.id" :class="{even:(index+1)%2===0}"&gt;
  &lt;td&gt;{{book.id}}&lt;/td&gt;
  &lt;td&gt;{{book.title}}&lt;/td&gt;
  &lt;td&gt;{{book.teacher}}&lt;/td&gt;
  &lt;td&gt;{{book.classHour}}&lt;/td&gt;
  &lt;td&gt;&lt;button @click="deleteItem(index)"&gt;删除&lt;/button&gt;&lt;/td&gt;
&lt;/tr&gt;</pre><h3>3.3 数据与方法</h3><pre>const vm = Vue.createApp({
  data() {
    return {
      books: [
        { id: 1, title: ''高等数学'', teacher: ''王老师'', classHour: 32 },
        { id: 2, title: ''VC++'', teacher: ''李老师'', classHour: 8 },
        { id: 3, title: ''英语'', teacher: ''孙老师'', classHour: 16 },
        { id: 4, title: ''Web开发基础'', teacher: ''王老师'', classHour: 16 }
      ]
    }
  },
  methods: {
    deleteItem(index) {
      this.books.splice(index, 1);
    }
  }
}).mount(''#app'');</pre><p>books数组实际上是一个对象数组，其中每个对象都包含了一本书籍的详细信息。deleteItem方法用于从数组中删除指定索引的书籍。</p>', '详解Vue 3样式绑定的两种核心方式：v-bind:class的对象/数组语法及与普通class共存、组件中$attrs处理多根节点；v-bind:style的对象/数组语法及自动前缀处理；最后通过表格奇偶行样式案例综合运用所学知识', '/img/6.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (7, '第6章 Vue 3 组件复用', '', '<h2>一、DOM渲染函数实现复用</h2><h3>1.1 DOM基础</h3><p>DOM（文档对象模型）是HTML和XML文档的编程接口，每个DOM节点对应一个可编程的DOM对象，允许通过编程对DOM对象进行创建、修改、删除或者添加事件等操作。Document节点称为根节点，包含一个子节点。HTML节点包含两个子节点，分别是head和body节点，而head和body也都有自己的子节点，形成树状结构。</p><h3>1.2 JavaScript动态生成DOM对象</h3><p>可以使用<strong>document.createElement()</strong>向DOM树添加新对象，并通过textContent为其添加内容。常用选择对象方法：</p><ul><li><strong>getElementById()</strong>：返回一个匹配特定ID的对象</li><li><strong>querySelector()</strong>：返回文档中与指定选择器或选择器组匹配的第一个HTMLElement对象</li><li><strong>querySelectorAll()</strong>：返回与指定选择器组匹配的文档中的对象列表</li></ul><pre>const movieItems = document.getElementById("movies");
const newMovie = document.createElement("li");
newMovie.textContent = "《老鹰抓小鸡》";
movieItems.appendChild(newMovie);</pre><p>通过使用style属性能够更改HTML文档中的CSS样式：</p><pre>const pageTitle = document.querySelector("h1");
pageTitle.style.fontSize = "24px";
pageTitle.style.color = "#0000FF";</pre><h3>1.3 render()渲染函数</h3><p>在一些场景中需要直接使用JavaScript进行渲染编程，这时可以使用render()函数。render函数接收createElement函数作为参数，用于创建虚拟DOM节点：</p><pre>Vue.component(''anchored-heading'', {
  render: function (createElement) {
    return createElement(
      ''h'' + this.level,
      this.$slots.default
    )
  },
  props: {
    level: { type: Number, required: true }
  }
})</pre><h3>1.4 JSX语法</h3><p>JSX是一种JavaScript的语法扩展，允许在JavaScript中编写类似HTML的代码。使用JSX语法可以使render函数更加直观：</p><pre>import AnchoredHeading from ''./AnchoredHeading.vue''
const app = createApp({
  render() {
    return (
      &lt;Anchored-heading level={1}&gt;
        &lt;span&gt;Hello&lt;/span&gt;world!
      &lt;/Anchored-heading&gt;
    )
  }
})</pre><h3>1.5 函数式组件</h3><p>没有管理任何状态，也没有监听任何状态和钩子函数，只是一个接受一些props的函数，该场景下可以将组件标记为函数式组件。组件需要的一切都通过<strong>context参数</strong>传递，该参数是一个包括以下字段的对象：</p><ul><li><strong>props</strong>：提供所有props的对象</li><li><strong>children</strong>：VNode子节点的数组</li><li><strong>slots</strong>：一个函数，返回了包含所有插槽的对象</li><li><strong>scopedSlots</strong>：一个暴露传入的作用域插槽的对象</li><li><strong>data</strong>：传递给组件的整个数据对象</li><li><strong>parent</strong>：对父组件的引用</li><li><strong>listeners</strong>：一个包含了所有父组件为当前组件注册的事件监听器的对象</li><li><strong>injections</strong>：如果使用了inject选项，则该对象包含了应当被注入的property</li></ul><h3>1.6 模板编译</h3><p>Vue.compile()函数可以实时编译模板字符串为渲染函数。以下模板：</p><pre>&lt;div&gt;
  &lt;header&gt;&lt;h1&gt;I''m a template!&lt;/h1&gt;&lt;/header&gt;
  &lt;p v-if="message"&gt;{{ message }}&lt;/p&gt;
  &lt;p v-else&gt;No message.&lt;/p&gt;
&lt;/div&gt;</pre><p>会编译成包含_c（创建元素）、_m（渲染静态内容）、_v（创建文本节点）、_s（转字符串）等内部辅助函数的渲染函数。</p><h2>二、混入对象（Mixin）</h2><h3>2.1 混入的概念</h3><p>混入是一种分发Vue组件中可复用功能的灵活方式。当组件使用混入对象时，所有混入对象的选项都会被"混合"到该组件本身的选项中。</p><h3>2.2 全局混入</h3><pre>Vue.mixin({
  created: function () {
    var myOption = this.$options.myOption
    if (myOption) { console.log(myOption) }
  }
})
new Vue({ myOption: ''hello!'' }) // 输出 hello!</pre><h3>2.3 局部混入</h3><pre>var myMixin = {
  created: function () { this.hello() },
  methods: {
    hello: function () { console.log(''hello from mixin!'') }
  }
}
var Component = Vue.extend({ mixins: [myMixin] })
var component = new Component() // 输出hello from mixin!</pre><h3>2.4 自定义选项合并策略</h3><p>可以向Vue.config.optionMergeStrategies添加一个函数来自定义合并逻辑：</p><pre>Vue.config.optionMergeStrategies.myOption = function (toVal, fromVal) {
  // 返回合并后的值
}
// 使用与methods相同的合并策略
var strategies = Vue.config.optionMergeStrategies
strategies.myOption = strategies.methods</pre><h2>三、插件复用</h2><h3>3.1 编写插件</h3><p>Vue 3的插件公开一个<strong>install()</strong>函数，该函数的第一个参数是Vue 3构造器，第二个参数是一个可选的选项对象。插件可以实现以下功能：</p><ol><li>添加全局函数或property</li><li>添加全局资源（指令、过滤器、过渡等）</li><li>注入组件选项（混入）</li><li>添加实例方法（通过添加到Vue.prototype上）</li></ol><pre>MyPlugin.install = function (Vue, options) {
  Vue.myGlobalMethod = function () { /* 逻辑... */ }
  Vue.directive(''my-directive'', { bind(el, binding, vnode, oldVnode) { /* ... */ } })
  Vue.mixin({ created: function () { /* ... */ } })
  Vue.prototype.$myMethod = function (methodOptions) { /* ... */ }
}</pre><h3>3.2 使用插件</h3><p>使用插件需要通过全局函数<strong>Vue.use()</strong>，在调用new Vue()启动应用之前，需要先完成该操作：</p><pre>Vue.use(MyPlugin)
new Vue({ /* 组件选项 */ })
Vue.use(MyPlugin, { someOption: true })</pre><p>在CommonJS这样的模块环境中，应始终显式地调用Vue.use()：</p><pre>var Vue = require(''vue'')
var VueRouter = require(''vue-router'')
Vue.use(VueRouter)</pre><h2>四、案例：使用渲染函数渲染列表</h2><h3>4.1 场景描述</h3><p>假设场景为帖子列表，每个列表项将展示帖子的简介内容，包括标题、发帖人、发帖时间和点赞数，并支持点赞功能。</p><h3>4.2 子组件ListItem</h3><pre>app.component(''ListItem'', {
  props: {
    content: { type: Object, required: true }
  },
  render() {
    return Vue.h(''li'', [
      Vue.h(''p'', [
        Vue.h(''span'',
          ''标题：'' + this.content.title +
          '' |发帖人：'' + this.content.author +
          '' |发帖时间：'' + this.content.date +
          '' |点赞数：'' + this.content.Vote
        ),
        Vue.h(''button'', {
          onClick: () =&gt; this.$emit(''vote'')
        }, ''赞'')
      ])
    ]);
  }
})</pre><h3>4.3 父组件ContentList</h3><pre>app.component(''ContentList'', {
  data() {
    return {
      contents: [
        { id: 1, title: ''如何学好前端开发'', author: ''张三'', date: ''3个月前'', vote: 0 }
        // ...
      ]
    }
  },
  methods: {
    handleVote(id) {
      this.contents.map(item =&gt; {
        item.id === id ? { ...item, vote: ++item.vote } : item;
      })
    }
  },
  render() {
    let contentNodes = [];
    this.contents.map(item =&gt; {
      let node = Vue.h(Vue.resolveComponent(''ListItem''), {
        content: item,
        onVote: () =&gt; this.handleVote(item.id)
      });
      contentNodes.push(node);
    })
    return Vue.h(''div'', [Vue.h(''ul'', [contentNodes])]);
  }
})</pre><p>该案例使用this.contents.map取代v-for指令，通过Vue.h()构造子组件的虚拟节点，实现完整的帖子列表渲染和点赞交互功能。</p>', '深入讲解Vue 3组件复用技术：DOM渲染函数与JSX语法、函数式组件context参数、模板编译原理；混入对象的全局/局部注册与合并策略；插件的install机制与使用方式；最后通过render函数渲染帖子列表的综合案例巩固知识', '/img/7.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (8, '第7章 Vue Router 路由管理', '', '<h2>一、路由基础</h2><h3>1.1 前端路由方案</h3><p>目前常见的前端路由方案主要有以下4种：</p><table border="1" cellpadding="5"><tr><th>模式</th><th>说明</th></tr><tr><td><strong>hash模式</strong></td><td>基于锚点的原理实现，简单易用，URL中带#号，不会触发页面刷新</td></tr><tr><td><strong>history模式</strong></td><td>使用HTML 5标准中的History API通过监听popstate事件来对DOM对象进行操作，每次路由变化不会引起重定向，URL更美观但需要后端配置支持</td></tr><tr><td><strong>memory模式</strong></td><td>在内存中维护一个堆栈用于管理访问历史的方式，在早期移动端使用比较多，实现麻烦，问题也较多。React Native使用这种路由模式</td></tr><tr><td><strong>static模式</strong></td><td>主要用于服务端渲染（SSR），需要后端去管理路由</td></tr></table><h3>1.2 在HTML中使用Vue Router</h3><p>在使用Vue Router时需要使用自定义组件<strong>router-link</strong>来创建链接。Vue Router可以在不重新加载页面的情况下更改URL、处理URL的生成及编码，<strong>router-view</strong>组件负责控制显示与URL对应的组件，可以将其放置在任何位置，以适应所需的布局：</p><pre>&lt;script src="https://unpkg.com/vue-router@4"&gt;&lt;/script&gt;

&lt;div id="app"&gt;
  &lt;h1&gt;Hello App!&lt;/h1&gt;
  &lt;p&gt;
    &lt;!-- 使用router-link组件来导航 --&gt;
    &lt;!-- 通过传入''to''属性指定链接 --&gt;
    &lt;!-- &lt;router-link&gt;默认会被渲染成一个''&lt;a&gt;''标签 --&gt;
    &lt;router-link to="/foo"&gt;Go to Foo&lt;/router-link&gt;
    &lt;router-link to="/bar"&gt;Go to Bar&lt;/router-link&gt;
  &lt;/p&gt;
  &lt;!-- 路由出口 --&gt;
  &lt;!-- 路由匹配到的组件将渲染在这里 --&gt;
  &lt;router-view&gt;&lt;/router-view&gt;
&lt;/div&gt;</pre><h3>1.3 在JavaScript代码中使用Vue Router</h3><p>在JavaScript中可以方便地使用Vue Router，完整的配置流程如下：</p><pre>// 0. 如果使用模块化机制编程，导入Vue和VueRouter，要调用Vue.use(VueRouter)
// 1. 定义(路由)组件，可以从其他文件import进来
const Foo = { template: ''&lt;div&gt;foo&lt;/div&gt;'' }
const Bar = { template: ''&lt;div&gt;bar&lt;/div&gt;'' }

// 2. 定义路由
const routes = [
  { path: ''/foo'', component: Foo },
  { path: ''/bar'', component: Bar }
]

// 3. 创建router实例，然后传routes配置
const router = VueRouter.createRouter({
  history: VueRouter.createWebHashHistory(),
  routes // 相当于routes: routes
})

// 4. 创建和挂载根实例
const app = Vue.createApp({
  // options
}).use(router).$mount(''#app'')</pre><p>通过注入路由器可以在任何组件内使用路由器，通过<strong>this.$router</strong>访问路由器或者访问当前路由的信息<strong>this.$route</strong>：</p><pre>// Home.vue
export default {
  computed: {
    username() {
      return this.$route.params.username
    }
  },
  methods: {
    goBack() {
      window.history.length &gt; 1 ? this.$router.go(-1) : this.$router.push(''/'')
    }
  }
}</pre><h2>二、动态路由</h2><h3>2.1 动态路径参数</h3><p>若需将所有匹配某种模式的路由都映射到同一个组件，对于所有id不相同的用户都用此组件来渲染，可以在Vue Router的路由路径中使用<strong>动态路径参数（dynamic segment）</strong>来实现这一目标。在Vue Router中，使用冒号<strong>":"</strong>标记路径参数：</p><pre>const User = { template: ''&lt;div&gt;User&lt;/div&gt;'' }

const router = VueRouter.createRouter({
  routes: [
    // 动态路径参数以冒号开头
    { path: ''/user/:id'', component: User }
  ]
})</pre><p>通过上述配置，用户在URL中输入路径/user/foo和/user/bar都将被映射到同一个路由。在匹配到路由时，参数值会被设置到<strong>this.$route.params</strong>中，可以在每个组件内使用。可以利用这个特性更新User组件的模板：</p><pre>const User = {
  template: ''&lt;div&gt;User {{ $route.params.id }}&lt;/div&gt;''
}</pre><p>在一个路由中设置多个路径参数，对应的值都会被设置到$route.params中。除了$route.params外，$route对象还提供了其他有用的信息，例如<strong>$route.query</strong>（如果URL中有查询参数）、<strong>$route.hash</strong>等。</p><h3>2.2 参数响应</h3><p>当使用带有参数的路由时，相同的组件实例将被重复使用。两个路由渲染同一个组件，相较于销毁再创建，复用则更加高效，但组件的钩子函数不会被调用。若要对同一个组件中参数的变化作出响应，开发者可以观测$route对象上的任意属性如$route.params，也可以使用<strong>beforeRouteUpdate</strong>导航守卫来取消导航：</p><pre>// 方式一：使用watch监听
const User = {
  template: ''...'',
  created() {
    this.$watch(
      () =&gt; this.$route.params,
      (toParams, previousParams) =&gt; {
        // 对路由变化作出响应
      }
    )
  },
}

// 方式二：使用beforeRouteUpdate
const User = {
  template: ''...'',
  async beforeRouteUpdate(to, from) {
    // 对路由变化作出响应
    this.userData = await fetchUser(to.params.id)
  },
}</pre><h3>2.3 捕获所有路由</h3><p>常规参数只匹配URL片段之间的字符，使用"/"分隔。若匹配任意路径可使用自定义的路径参数正则表达式：</p><pre>const routes = [
  // 将匹配所有内容并将其放在$route.params.pathMatch下
  { path: ''/:pathMatch(.*)*'', name: ''NotFound'', component: NotFound },
  // 将匹配以/user-开头的所有内容，并将其放在$route.params.afterUser下
  { path: ''/user-:afterUser(.*)'', component: UserGeneric },
]</pre><p>在路径参数后的括号中加入了一个自定义的正则表达式，并将pathMatch参数标记为可选可重复。这样做是为了让开发者可以通过将路径拆分成一个数组直接导航到路由：</p><pre>this.$router.push({
  name: ''NotFound'',
  // 保留当前路径并删除第一个字符
  params: { pathMatch: this.$route.path.substring(1).split(''/'') },
  // 保留现有的查询和hash值
  query: this.$route.query,
  hash: this.$route.hash,
})</pre><h2>三、路由的进阶使用</h2><h3>3.1 嵌套路由</h3><p>实际应用中的界面通常由多个嵌套的组件组成，URL中的动态路径也按照一定的结构对应于嵌套的组件层次结构。通过vue-router的嵌套路由配置，可以简单地表示出应用程序中的多层嵌套组件关系：</p><pre>&lt;div id="app"&gt;
  &lt;router-view&gt;&lt;/router-view&gt;
&lt;/div&gt;</pre><p>这里的&lt;router-view&gt;是一个顶层的router-view，用来渲染顶层路由匹配的组件。一个被渲染的组件也可以嵌套&lt;router-view&gt;，例如在User组件的模板内添加一个&lt;router-view&gt;，将组件渲染到嵌套的router-view中，并在路由中配置子路由（children）：</p><pre>const User = {
  template: ''
    &lt;div class="user"&gt;
      &lt;h2&gt;User {{ $route.params.id }}&lt;/h2&gt;
      &lt;router-view&gt;&lt;/router-view&gt;
    &lt;/div&gt;
  '',
}

const routes = [
  {
    path: ''/user/:id'',
    component: User,
    children: [
      {
        // 当/user/:id/profile匹配成功
        // UserProfile将被渲染到User的&lt;router-view&gt;内部
        path: ''profile'',
        component: UserProfile,
      },
      {
        // 当/user/:id/posts匹配成功
        // UserPosts将被渲染到User的&lt;router-view&gt;内部
        path: ''posts'',
        component: UserPosts,
      },
    ],
  },
]</pre><h3>3.2 编程式导航</h3><p>除了使用&lt;router-link&gt;创建a标签来定义导航链接，还可以通过调用router实例的各种函数编写代码来实现导航：</p><ul><li><strong>router.push()函数</strong>：向history栈添加一个新的记录，点击浏览器的后退按钮可以回到之前的URL</li><li><strong>router.replace()</strong>：替换当前的history记录，不会向history添加新记录</li><li><strong>router.go()</strong>：在history记录中向前或后退多少步，参数为整数</li></ul><h3>3.3 命名路由</h3><p>有时候通过一个名称来标识一个路由更加方便，特别是在链接一个路由或执行一些跳转时。在创建Router实例并配置routes时，可以为某个路由设置名称：</p><pre>const router = new VueRouter({
  routes: [
    {
      path: ''/user/:userId'',
      name: ''user'',
      component: User
    }
  ]
})</pre><p>要链接到一个命名路由，可以给router-link的to属性传一个对象：</p><pre>&lt;router-link :to="{ name: ''user'', params: { userId: 123 }}"&gt;User&lt;/router-link&gt;</pre><h3>3.4 命名视图</h3><p>有时候需要同时展示多个同级视图，而不是嵌套视图，例如创建一个布局，有sidebar（侧导航）和main（主内容）两个视图，这时可以使用<strong>命名视图</strong>。开发者可以在界面中拥有多个单独命名的视图，而不是只有一个默认的router-view，如果没有为router-view设置名称，则默认名称为"default"：</p><pre>&lt;router-view class="view one"&gt;&lt;/router-view&gt;
&lt;router-view class="view two" name="a"&gt;&lt;/router-view&gt;
&lt;router-view class="view three" name="b"&gt;&lt;/router-view&gt;</pre><p>对于命名视图，需要在components配置项中为每个命名视图指定组件：</p><pre>const router = new VueRouter({
  routes: [{
    path: ''/'',
    components: {
      default: Foo,
      a: Bar,
      b: Baz
    }
  }]
})</pre><h3>3.5 重定向与别名</h3><p><strong>重定向</strong>可以在routes配置中完成，重定向的目标也可以是一个命名路由，甚至是一个函数，动态返回重定向目标：</p><pre>const routes = [{ path: ''/home'', redirect: ''/'' }]
const routes = [{ path: ''/home'', redirect: { name: ''homepage'' } }]
const routes = [
  {
    // /search/screens -&gt; /search?q=screens
    path: ''/search/:searchText'',
    redirect: to =&gt; {
      // 函数接收目标路由作为参数
      // return重定向的字符串路径/路径对象
      return { path: ''/search'', query: { q: to.params.searchText } }
    },
  },
]</pre><p><strong>相对重定向</strong>：</p><pre>const routes = [{
  // 将总是把/users/123/posts重定向到/users/123/profile
  path: ''/users/:id/posts'',
  redirect: to =&gt; {
    return ''profile''
  },
}]</pre><p><strong>别名</strong>允许为同一路由配置多个访问路径：</p><pre>const routes = [{
  path: ''/users'',
  component: UsersLayout,
  children: [
    // 为这3个URL呈现UserList
    // - /users
    // - /users/list
    // - /people
    { path: '''', component: UserList, alias: [''/people'', ''list''] },
  ],
}]</pre><h3>3.6 路由组件参数传递</h3><p>在组件中使用$route会与路由紧密耦合，这会限制组件的灵活性，可以通过<strong>props配置</strong>来解耦，这允许在任何地方使用该组件，使该组件更容易重用和测试：</p><pre>const User = {
  // 请确保添加一个与路由参数完全相同的属性名
  props: [''id''],
  template: ''&lt;div&gt;User {{ id }}&lt;/div&gt;''
}
const routes = [{ path: ''/user/:id'', component: User, props: true }]</pre><p>props配置有以下几种方式：</p><ul><li><strong>布尔模式</strong>：当props设置为true时，route.params将被设置为组件的props</li><li><strong>命名视图</strong>：对于有命名视图的路由，必须为每个命名视图定义props配置</li><li><strong>对象模式</strong>：props: { newsletterPopup: false }</li><li><strong>函数模式</strong>：props: route =&gt; ({ query: route.query.q })</li></ul><h2>四、History模式</h2><h3>4.1 HTML 5 History API</h3><p>DOM中的window对象通过history对象提供了对浏览器历史的访问，它暴露了很多有用的函数和属性，允许开发者在用户浏览历史中向前和向后跳转。从HTML 5开始，还提供了对history栈中内容的操作：</p><ul><li>在history中跳转：back()、forward()、go()</li><li><strong>pushState()函数</strong>：向history栈添加一个新的记录</li><li><strong>replaceState()函数</strong>：修改当前history记录</li></ul><h3>4.2 后端配置</h3><p>如果需要将项目部署在一个子目录下，应该使用Vue CLI中的publicPath选项以及相关的路由器基础属性，然后调整Web服务器根目录将其替换为子目录。使用history模式需要后端配合处理所有路由请求：</p><pre># Apache配置代码
&lt;IfModule mod_rewrite.c&gt;
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
&lt;/IfModule&gt;

# Nginx配置代码
location / {
  try_files $uri $uri/ /index.html;
}</pre><p>Node.js中的路由功能代码如下：</p><pre>const http = require(''http'')
const fs = require(''fs'')
const httpPort = 80
http.createServer((req, res) =&gt; {
  fs.readFile(''index.html'', ''utf-8'', (err, content) =&gt; {
    if (err) {
      console.log(''We cannot open "index.html" file.'')
    }
    res.writeHead(200, {
      ''Content-Type'': ''text/html; charset=utf-8''
    })
    res.end(content)
  })
}).listen(httpPort, () =&gt; {
  console.log(''Server listening on: http://localhost:%s'', httpPort)
})</pre><h2>五、导航守卫</h2><h3>5.1 全局守卫</h3><p>开发者可以使用<strong>router.beforeEach</strong>注册一个全局前置守卫函数：</p><pre>const router = new VueRouter({ ... })
router.beforeEach((to, from, next) =&gt; {
  // ...
})
router.afterEach((to, from) =&gt; {
  // ...
})</pre><p>当一个导航被触发时，全局前置守卫函数按照创建顺序调用。守卫函数是异步解析执行的，此时导航在所有守卫函数执行完之前一直处于等待中。每个守卫函数接收以下3个参数：</p><ul><li><strong>to</strong>：Route对象，即将要进入的目标路由对象</li><li><strong>from</strong>：Route对象，当前导航正要离开的路由对象</li><li><strong>next</strong>：Function函数，必须调用该函数来通知守卫函数执行完毕，执行效果依赖next函数的调用参数</li></ul><p>也可以注册<strong>全局后置守卫函数</strong>，该函数不会接受next函数也不会改变导航本身。</p><h3>5.2 路由独享守卫和组件内守卫</h3><p>在路由配置上直接定义<strong>beforeEnter</strong>守卫：</p><pre>const router = new VueRouter({
  routes: [
    {
      path: ''/foo'',
      component: Foo,
      beforeEnter: (to, from, next) =&gt; {
        // ...
      }
    }
  ]
})</pre><p>可以在路由组件内直接定义以下3个路由导航守卫：</p><ul><li><strong>beforeRouteEnter</strong>：渲染该组件前调用，不能访问组件实例this</li><li><strong>beforeRouteUpdate</strong>：在当前路由改变且组件被复用时调用</li><li><strong>beforeRouteLeave</strong>：导航离开组件路由时调用</li></ul><pre>const Foo = {
  template: ''...'',
  beforeRouteEnter(to, from, next) {
    // 渲染该组件前调用
  },
  beforeRouteUpdate(to, from, next) {
    // 在当前路由改变且组件被复用时调用
  },
  beforeRouteLeave(to, from, next) {
    // 导航离开组件路由时调用
  }
}</pre><h3>5.3 导航解析流程</h3><ol><li>导航被触发</li><li>在失活的组件里调用beforeRouteLeave守卫</li><li>调用全局的beforeEach守卫</li><li>在重用的组件里调用beforeRouteUpdate守卫（需vue-router 2.2版本以上）</li><li>在路由配置里调用beforeEnter守卫</li><li>解析异步路由组件</li><li>在被激活的组件里调用beforeRouteEnter守卫</li><li>调用全局的beforeResolve守卫（需vue-router 2.5版本以上）</li><li>导航被确认</li><li>调用全局的afterEach()钩子函数</li><li>触发DOM树结构更新</li><li>调用beforeRouteEnter守卫中传递给next的回调函数，已创建好的组件实例会作为回调函数的参数传递</li></ol><h2>六、路由元信息</h2><p>定义路由的时候可以配置<strong>meta</strong>字段，用于存储额外信息如权限控制：</p><pre>const router = new VueRouter({
  routes: [
    {
      path: ''/foo'',
      component: Foo,
      children: [
        {
          path: ''bar'',
          component: Bar,
          // 元信息
          meta: { requiresAuth: true }
        }
      ]
    }
  ]
})</pre><p>可以在全局导航守卫中检查元信息，实现路由权限控制：</p><pre>router.beforeEach((to, from, next) =&gt; {
  if (to.matched.some(record =&gt; record.meta.requiresAuth)) {
    // 判断是否已经登录
    // 如果没有登录，跳转到登录页面
    if (!auth.loggedIn()) {
      next({
        path: ''/login'',
        query: { redirect: to.fullPath }
      })
    } else {
      next()
    }
  } else {
    next() // 确保一定要调用next()函数
  }
})</pre><h2>七、过渡动效</h2><h3>7.1 单路由过渡</h3><p>在各个路由组件内部使用&lt;transition&gt;标签，并设置不同的name：</p><pre>const Foo = {
  template: ''
    &lt;transition name="slide"&gt;
      &lt;div class="foo"&gt;...&lt;/div&gt;
    &lt;/transition&gt;
  ''
}
const Bar = {
  template: ''
    &lt;transition name="fade"&gt;
      &lt;div class="bar"&gt;...&lt;/div&gt;
    &lt;/transition&gt;
  ''
}</pre><p>或者采用下面这种方式，在路由元信息中配置过渡名称：</p><pre>const routes = [
  {
    path: ''/custom-transition'',
    component: PanelLeft,
    meta: { transition: ''slide-left'' },
  },
  {
    path: ''/other-transition'',
    component: PanelRight,
    meta: { transition: ''slide-right'' },
  }
]</pre><p>&lt;router-view&gt;是基本的动态组件，可以用&lt;transition&gt;组件给它添加一些过渡效果：</p><pre>&lt;router-view v-slot="{ Component, route }"&gt;
  &lt;!-- 使用任何自定义过渡和回退到''fade'' --&gt;
  &lt;transition :name="route.meta.transition || ''fade''"&gt;
    &lt;component :is="Component" /&gt;
  &lt;/transition&gt;
&lt;/router-view&gt;</pre><h3>7.2 路由动态过渡</h3><p>基于当前路由与目标路由的变化关系，动态设置过渡效果：</p><pre>&lt;!-- 使用动态的transition name --&gt;
&lt;transition :name="transitionName"&gt;
  &lt;router-view&gt;&lt;/router-view&gt;
&lt;/transition&gt;

// 在父组件内使用$route规则决定使用哪种过渡
watch: {
  ''$route'' (to, from) {
    const toDepth = to.path.split(''/'').length
    const fromDepth = from.path.split(''/'').length
    this.transitionName = toDepth &lt; fromDepth ? ''slide-right'' : ''slide-left''
  }
}</pre><h2>八、数据获取</h2><h3>8.1 导航完成后获取数据</h3><p>使用该方式，系统会立即进行导航和组件渲染，并在组件的created()钩子函数中获取数据。这使得开发人员有机会在数据获取期间展示加载状态，并可以在不同的视图中显示不同的加载状态。假设有一个"文章（post）"组件，需要基于$route.params.id获取文章数据：</p><pre>&lt;template&gt;
  &lt;div class="post"&gt;
    &lt;div v-if="loading" class="loading"&gt;Loading...&lt;/div&gt;
    &lt;div v-if="error" class="error"&gt;{{ error }}&lt;/div&gt;
    &lt;div v-if="post" class="content"&gt;
      &lt;h2&gt;{{ post.title }}&lt;/h2&gt;
      &lt;p&gt;{{ post.body }}&lt;/p&gt;
    &lt;/div&gt;
  &lt;/div&gt;
&lt;/template&gt;

export default {
  data () {
    return {
      loading: false,
      post: null,
      error: null
    }
  },
  created () {
    this.fetchData() // 组件创建完后获取数据
  },
  watch: {
    ''$route'': ''fetchData'' // 如果路由有变化，会再次执行该函数
  },
  methods: {
    fetchData () {
      this.error = this.post = null
      this.loading = true
      getPost(this.$route.params.id, (err, post) =&gt; {
        this.loading = false
        if (err) {
          this.error = err.toString()
        } else {
          this.post = post
        }
      })
    }
  }
}</pre><h3>8.2 在导航完成前获取数据</h3><p>采用这种方式，可以在导航进入新路由之前获取数据。开发人员可以在接下来的组件的beforeRouteEnter守卫中获取数据，当数据获取成功后只需调用next()函数即可：</p><pre>export default {
  data () {
    return {
      post: null,
      error: null
    }
  },
  beforeRouteEnter (to, from, next) {
    getPost(to.params.id, (err, post) =&gt; {
      next(vm =&gt; vm.setData(err, post))
    })
  },
  // 路由改变前，组件就已经渲染完毕
  beforeRouteUpdate (to, from, next) {
    this.post = null
    getPost(to.params.id, (err, post) =&gt; {
      this.setData(err, post)
      next()
    })
  },
  methods: {
    setData (err, post) {
      if (err) {
        this.error = err.toString()
      } else {
        this.post = post
      }
    }
  }
}</pre><h2>九、路由懒加载</h2><p>首先，可以将异步组件定义为返回一个Promise对象的工厂函数，该函数返回的Promise对象代表了resolve组件本身。其次，在webpack中，可以使用动态import语法来定义代码分块点。将这两者结合起来，即可定义一个能够被webpack自动分割代码的异步组件。在路由配置中，无须作任何更改，只需像往常一样使用Foo组件：</p><pre>const Foo = () =&gt; Promise.resolve({
  // 组件定义对象
})
import(''./Foo.vue'') // 返回Promise

const Foo = () =&gt; import(''./Foo.vue'')
const router = new VueRouter({
  routes: [{ path: ''/foo'', component: Foo }]
})</pre><p>有时开发者希望将某个路由下的所有组件打包到同一个异步代码块（chunk）中，需要使用<strong>命名chunk</strong>，即一种特殊的注释语法来提供chunk name（要求使用webpack &gt; 2.4版本）。webpack会将任何一个异步模块与相同的块名称组合到相同的异步代码块中：</p><pre>const Foo = () =&gt; import(/* webpackChunkName: "group-foo" */ ''./Foo.vue'')
const Bar = () =&gt; import(/* webpackChunkName: "group-foo" */ ''./Bar.vue'')
const Baz = () =&gt; import(/* webpackChunkName: "group-foo" */ ''./Baz.vue'')</pre><h2>十、滚动行为</h2><p>在创建一个Router实例时，可以提供一个<strong>scrollBehavior()</strong>函数。scrollBehavior()函数接收to和from路由对象作为参数。第三个参数<strong>savedPosition</strong>仅在popstate导航时（即通过浏览器的前进/后退按钮触发）可用。这个函数返回一个滚动位置的对象信息：</p><pre>const router = new VueRouter({
  routes: [...],
  scrollBehavior (to, from, savedPosition) {
    // return期望滚动到哪个的位置
  }
})</pre><p>返回值格式：</p><ul><li>{ x: number, y: number }</li><li>{ selector: string, offset?: { x: number, y: number } }</li></ul><p>可以将<strong>behavior</strong>选项添加到scrollBehavior()函数内部返回的对象中，从而启用支持它的浏览器的原生平滑滚动：</p><pre>scrollBehavior (to, from, savedPosition) {
  if (to.hash) {
    return {
      selector: to.hash,
      behavior: ''smooth'',
    }
  }
}</pre>', '全面讲解Vue Router路由管理：四种路由模式详解、动态路由与参数响应、嵌套路由与编程式导航、命名路由与命名视图、重定向与别名、路由组件参数传递、History模式后端配置、导航守卫完整解析流程、路由元信息与权限控制、过渡动效、数据获取两种策略、路由懒加载与代码分割、滚动行为控制', '/img/8.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (9, '第8章 Vue 3 服务端通信', '', '<h2>一、服务端通信概述</h2><p>在现代Web应用开发中，前端与后端的数据交互是核心环节。Vue 3作为前端框架本身并不提供HTTP通信能力，需要借助第三方库或浏览器原生API来实现与服务器的数据交换。</p><p>常见的服务端通信方式包括：</p><ul><li><strong>XMLHttpRequest</strong>：浏览器内置的HTTP请求API，使用较为繁琐</li><li><strong>Fetch API</strong>：现代浏览器提供的基于Promise的HTTP请求接口</li><li><strong>Axios</strong>：目前最流行的HTTP客户端库，基于Promise，功能丰富</li><li><strong>WebSocket</strong>：全双工通信协议，适用于实时数据推送场景</li><li><strong>JSONP</strong>：解决跨域问题的传统方案，现已较少使用</li></ul><h2>二、Axios详解</h2><h3>2.1 Axios简介</h3><p>Axios是一个基于Promise的HTTP客户端，可以用于浏览器和Node.js环境。其主要特性包括：</p><ul><li>从浏览器中创建XMLHttpRequests</li><li>从Node.js创建http请求</li><li>支持Promise API</li><li>拦截请求和响应</li><li>转换请求数据和响应数据</li><li>取消请求</li><li>自动转换JSON数据</li><li>客户端支持防御XSRF攻击</li></ul><h3>2.2 安装与基本使用</h3><pre>// 安装
npm install axios

// 基本GET请求
axios.get(''/user?ID=12345'')
  .then(response =&gt; {
    console.log(response.data)
    console.log(response.status)
    console.log(response.statusText)
    console.log(response.headers)
    console.log(response.config)
  })
  .catch(error =&gt; {
    console.log(error)
  })

// 基本POST请求
axios.post(''/user'', {
  firstName: ''Fred'',
  lastName: ''Flintstone''
})
.then(response =&gt; { console.log(response) })
.catch(error =&gt; { console.log(error) })</pre><h3>2.3 请求配置</h3><pre>axios({
  method: ''post'',
  url: ''/user/12345'',
  data: {
    firstName: ''Fred'',
    lastName: ''Flintstone''
  },
  headers: { ''X-Requested-With'': ''XMLHttpRequest'' },
  timeout: 1000,
  responseType: ''json''
})</pre><h3>2.4 拦截器</h3><p>Axios提供了请求和响应拦截器，可以在请求发送前或响应到达后进行统一处理：</p><pre>// 请求拦截器
axios.interceptors.request.use(config =&gt; {
  // 在发送请求之前做些什么，例如添加token
  config.headers.Authorization = ''Bearer '' + localStorage.getItem(''token'')
  return config
}, error =&gt; {
  // 对请求错误做些什么
  return Promise.reject(error)
})

// 响应拦截器
axios.interceptors.response.use(response =&gt; {
  // 对响应数据做点什么
  return response
}, error =&gt; {
  // 对响应错误做点什么，例如统一处理401
  if (error.response.status === 401) {
    // 跳转到登录页
  }
  return Promise.reject(error)
})</pre><h3>2.5 创建实例</h3><p>可以使用自定义配置新建一个axios实例，便于统一管理：</p><pre>const instance = axios.create({
  baseURL: ''https://api.example.com'',
  timeout: 1000,
  headers: { ''X-Custom-Header'': ''foobar'' }
})

instance.get(''/longRequest'')
instance.post(''/user'', { name: ''John'' })</pre><h2>三、在Vue 3中使用Axios</h2><h3>3.1 全局挂载</h3><p>在Vue 3项目中，通常将axios挂载到全局属性或封装为插件使用：</p><pre>// main.js
import { createApp } from ''vue''
import App from ''./App.vue''
import axios from ''axios''

const app = createApp(App)
app.config.globalProperties.$axios = axios
app.config.globalProperties.$http = axios
app.mount(''#app'')</pre><p>在组件中使用：</p><pre>export default {
  mounted() {
    this.$axios.get(''/api/users'')
      .then(res =&gt; { this.users = res.data })
  }
}</pre><h3>3.2 封装请求模块</h3><p>为了更好地管理API请求，建议将axios请求封装为独立的模块：</p><pre>// utils/request.js
import axios from ''axios''

const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API,
  timeout: 5000
})

service.interceptors.request.use(
  config =&gt; {
    // 添加token等操作
    return config
  },
  error =&gt; {
    return Promise.reject(error)
  }
)

service.interceptors.response.use(
  response =&gt; {
    const res = response.data
    if (res.code !== 200) {
      // 处理错误
      return Promise.reject(new Error(res.message || ''Error''))
    }
    return res
  },
  error =&gt; {
    return Promise.reject(error)
  }
)

export default service</pre><h2>四、跨域处理</h2><h3>4.1 什么是跨域</h3><p>跨域是指浏览器不能执行其他网站的脚本，是由浏览器的<strong>同源策略</strong>造成的。同源策略限制从一个源加载的文档或脚本如何与来自另一个源的资源进行交互。同源是指<strong>协议、域名、端口</strong>都相同。</p><h3>4.2 开发环境代理配置</h3><p>在Vue CLI项目中，可以通过配置vue.config.js中的devServer.proxy来解决开发环境的跨域问题：</p><pre>// vue.config.js
module.exports = {
  devServer: {
    proxy: {
      ''/api'': {
        target: ''http://localhost:8080'',
        changeOrigin: true,
        pathRewrite: {
          ''^/api'': ''''
        }
      }
    }
  }
}</pre><h3>4.3 生产环境跨域</h3><p>生产环境通常通过以下方式解决跨域：</p><ul><li><strong>Nginx反向代理</strong>：配置Nginx将前端请求转发到后端服务</li><li><strong>后端配置CORS</strong>：服务端设置Access-Control-Allow-Origin响应头</li><li><strong>JSONP</strong>：仅支持GET请求，现已较少使用</li></ul><h2>五、异步处理最佳实践</h2><h3>5.1 async/await语法</h3><p>结合async/await语法可以使异步代码更加清晰易读：</p><pre>export default {
  data() {
    return {
      users: [],
      loading: false,
      error: null
    }
  },
  async created() {
    await this.fetchUsers()
  },
  methods: {
    async fetchUsers() {
      this.loading = true
      this.error = null
      try {
        const response = await this.$axios.get(''/api/users'')
        this.users = response.data
      } catch (err) {
        this.error = err.message
      } finally {
        this.loading = false
      }
    }
  }
}</pre><h3>5.2 错误处理</h3><p>良好的错误处理机制可以提升用户体验：</p><ul><li>网络错误提示</li><li>请求超时处理</li><li>服务端错误码统一处理</li><li>重试机制</li></ul><h2>六、RESTful API设计规范</h2><p>前后端分离项目中，通常遵循RESTful API设计规范：</p><table border="1" cellpadding="5"><tr><th>HTTP方法</th><th>操作</th><th>示例</th></tr><tr><td>GET</td><td>获取资源</td><td>/api/users 获取用户列表</td></tr><tr><td>POST</td><td>创建资源</td><td>/api/users 创建新用户</td></tr><tr><td>PUT</td><td>更新资源（完整）</td><td>/api/users/1 更新用户1的全部信息</td></tr><tr><td>PATCH</td><td>更新资源（部分）</td><td>/api/users/1 更新用户1的部分信息</td></tr><tr><td>DELETE</td><td>删除资源</td><td>/api/users/1 删除用户1</td></tr></table>', '详解Vue 3服务端通信技术：Axios安装配置与拦截器使用、请求封装最佳实践、跨域问题解决方案（开发代理/生产Nginx/CORS）、async/await异步处理、RESTful API设计规范及错误处理机制', '/img/9.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (10, '第9章 Vue CLI 项目部署', '', '<h2>一、Vue CLI简介</h2><h3>1.1 安装Vue CLI</h3><p>Vue CLI是一个基于Vue.js进行快速开发的完整系统，提供：</p><ul><li>通过@vue/cli搭建交互式的项目脚手架</li><li>通过@vue/cli + @vue/cli-service-global快速开始零配置原型开发</li><li>一个运行时依赖（@vue/cli-service），该依赖可升级，基于webpack构建，并可以通过插件进行扩展</li><li>一个丰富的官方插件集合，集成了前端生态中最好的工具</li></ul><p>可以在命令行中使用下列任一命令进行安装：</p><pre>npm install -g @vue/cli
# OR
yarn global add @vue/cli</pre><p>安装完成后，可以使用以下命令检查Vue 3的版本是否正确：</p><pre>vue --version</pre><p>如果需要升级全局的Vue CLI包，运行以下命令：</p><pre>npm update -g @vue/cli
# 或者
yarn global upgrade --latest @vue/cli</pre><p>如需升级项目中的Vue CLI相关模块（以@vue/cli-plugin-或vue-cli-plugin-开头），则在项目目录下运行以下命令，选项包括-t（升级到指定版本）、-f（跳过版本检测）、-r（使用指定registry）、--all（升级所有插件）、--next（检查alpha/beta/rc版本）、-h（帮助）：</p><pre>vue upgrade [options] [plugin-name]</pre><h3>1.2 vue serve与vue build</h3><p>开发者可以使用vue serve和vue build命令对单个*.vue文件进行快速原型开发。这需要先额外安装一个全局的扩展：</p><pre>npm install -g @vue/cli-service-global</pre><p>vue serve命令用法如下，选项包括-o（打开浏览器）、-c（复制URL到剪切板）、-h（帮助）：</p><pre>vue serve [options] [entry]</pre><p>vue build命令用法如下，在生产环境模式下零配置构建一个.js或.vue文件。选项包括-t（构建目标app/lib/wc/wc-async，默认app）、-n（库的名字）、-d（输出目录，默认dist）、-h（帮助）：</p><pre>vue build [options] [entry]</pre><h3>1.3 vue create创建项目</h3><p>创建一个由vue-cli-service提供支持的新项目：</p><pre>vue create hello-world</pre><p>create命令选项包括：</p><ul><li>-p, --preset &lt;presetName&gt;：忽略提示符并使用已保存的或远程的预设选项</li><li>-d, --default：忽略提示符并使用默认预设选项</li><li>-i, --inlinePreset &lt;json&gt;：忽略提示符并使用内联的JSON字符串预设选项</li><li>-m, --packageManager &lt;command&gt;：在安装依赖时使用指定的npm客户端</li><li>-r, --registry &lt;url&gt;：在安装依赖时使用指定的npm registry</li><li>-g, --git [message]：强制/跳过git初始化，并可选地指定初始化提交信息</li><li>-n, --no-git：跳过git初始化</li><li>-f, --force：覆写目标目录可能存在的配置</li><li>-c, --clone：使用git clone获取远程预设选项</li><li>-x, --proxy：使用指定的代理创建项目</li><li>-b, --bare：创建项目时省略默认组件中的新手指导信息</li><li>-h, --help：输出使用帮助信息</li></ul><h3>1.4 了解Vue CLI项目结构</h3><p>打开生成好的hello-world项目文件夹，可以看到最终生成的项目结构。各子目录作用如下：</p><table border="1" cellpadding="5"><tr><th>目录/文件</th><th>说明</th></tr><tr><td>node_modules</td><td>存放项目的所有第三方依赖</td></tr><tr><td>public</td><td>存放基础模板和一些资源文件，例如index.html文件和favicon.ico文件等</td></tr><tr><td>src</td><td>存放项目的主体代码，包括静态资源、入口文件和自定义组件等</td></tr><tr><td>package.json</td><td>项目配置文件，定义依赖和脚本</td></tr><tr><td>babel.config.js</td><td>Babel转译配置</td></tr><tr><td>vue.config.js</td><td>Vue CLI配置文件（可选）</td></tr></table><h2>二、webpack概述</h2><h3>2.1 配置webpack</h3><p>调整webpack配置最简单的方式是在vue.config.js文件中的<strong>configureWebpack</strong>选项中创建一个对象：</p><pre>// vue.config.js
module.exports = {
  configureWebpack: {
    plugins: [
      new MyAwesomeWebpackPlugin()
    ]
  }
}</pre><p>如果需要基于环境条件配置行为，或者想要直接修改配置，则需要将configureWebpack选项修改为函数：</p><pre>// vue.config.js
module.exports = {
  configureWebpack: config =&gt; {
    if (process.env.NODE_ENV === ''production'') {
      // 为生产环境修改配置
    } else {
      // 为开发环境修改配置
    }
  }
}</pre><h3>2.2 链式操作（chainWebpack）</h3><p>Vue CLI内部的webpack配置是通过webpack-chain维护的。使用<strong>chainWebpack</strong>可以链式访问特定的loader和插件：</p><pre>// 添加一个新的loader
module.exports = {
  chainWebpack: config =&gt; {
    // GraphQL loader
    config.module
      .rule(''graphql'')
      .test(/\.graphql$/)
      .use(''graphql-tag/loader'')
        .loader(''graphql-tag/loader'')
        .end()
      // 也可再添加一个loader
      .use(''other-loader'')
        .loader(''other-loader'')
        .end()
  }
}</pre><p>修改loader选项：</p><pre>module.exports = {
  chainWebpack: config =&gt; {
    config.module
      .rule(''vue'')
      .use(''vue-loader'')
        .tap(options =&gt; {
          // 修改选项
          return options
        })
  }
}</pre><p>对于CSS相关的loader，推荐使用css.loaderOptions选项进行配置，而不是直接使用链式语法指定loader。</p><h3>2.3 替换已有loader</h3><p>替换一个已有的基础loader，例如将svg处理从file-loader替换为vue-svg-loader：</p><pre>module.exports = {
  chainWebpack: config =&gt; {
    const svgRule = config.module.rule(''svg'')
    // 清除已有的所有loader
    svgRule.uses.clear()
    // 添加要替换的loader
    svgRule
      .use(''vue-svg-loader'')
        .loader(''vue-svg-loader'')
  }
}</pre><h3>2.4 修改插件选项</h3><pre>module.exports = {
  chainWebpack: config =&gt; {
    config
      .plugin(''html'')
      .tap(args =&gt; {
        return [/* 传递给html-webpack-plugin构造函数的新参数 */]
      })
  }
}</pre><h3>2.5 审查项目的webpack配置</h3><p>Vue CLI提供了inspect命令来检查解析好的webpack配置：</p><pre># 只审查第一条规则
vue inspect module.rules.0

# 或者指向一个规则或插件的名字
vue inspect --rule vue
vue inspect --plugin html

# 最后，可以列出所有规则和插件的名字
vue inspect --rules
vue inspect --plugins</pre><h2>三、构建与部署Vue CLI项目</h2><h3>3.1 构建目标</h3><p>当运行vue-cli-service build时，可以通过<strong>--target</strong>选项指定不同的构建目标，以允许将相同的源代码根据不同的用例生成不同的构建：</p><ul><li><strong>app（默认）</strong>：用于构建一个标准的Web应用</li><li><strong>lib</strong>：用于构建一个库</li><li><strong>wc</strong>：用于构建一个Web Component</li><li><strong>wc-async</strong>：用于构建一个异步Web Component</li></ul><p>应用模式的默认模式有以下特点：</p><ol><li>index.html带有注入的资源和resource hint</li><li>第三方库被分到一个独立包以便更好地缓存</li><li>小于4kb的静态资源被内联在JavaScript中</li><li>public中的静态资源被复制到输出目录中</li></ol><h3>3.2 本地预览生产构建</h3><p>在本地预览生产环境构建最简单的方式就是使用一个Node.js静态文件服务器：</p><pre>npm install -g serve
# -s参数的意思是将其架设在SPA模式下
# 这个模式会处理即将提到的路由问题
serve -s dist</pre><h3>3.3 生产环境部署</h3><p>生产环境部署通常涉及以下步骤：</p><ol><li><strong>构建项目</strong>：运行npm run build生成dist目录</li><li><strong>配置Web服务器</strong>：使用Nginx或Apache托管静态文件</li><li><strong>配置反向代理</strong>：将API请求转发到后端服务</li><li><strong>配置HTTPS</strong>：使用SSL证书启用HTTPS</li><li><strong>配置Gzip压缩</strong>：减少传输体积</li><li><strong>配置缓存策略</strong>：利用浏览器缓存提升性能</li></ol><h3>3.4 Nginx配置示例</h3><pre>server {
  listen 80;
  server_name example.com;

  location / {
    root /var/www/html/dist;
    index index.html;
    try_files $uri $uri/ /index.html;
  }

  location /api {
    proxy_pass http://localhost:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}</pre>', '全面介绍Vue CLI脚手架工具：安装升级与版本管理、vue serve/build/create命令使用、项目目录结构解析；深入webpack配置修改（configureWebpack/chainWebpack）、loader替换与插件配置；项目构建目标、本地预览及Nginx生产环境部署配置', '/img/10.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

INSERT INTO `article` VALUES (11, '第10章 Vuex 状态管理', '', '<h2>一、Vuex是什么</h2><p>Vuex是为了Vue 3应用程序开发而设计的<strong>状态管理模式</strong>。它采用<strong>集中式存储</strong>管理应用程序中的所有组件状态，并且使用相应的规则来确保状态以一种可预测的方式发生变化。此外，Vuex还集成在Vue 3的官方调试工具devtools extension中，提供一些高级调试功能，如零配置的时间旅行调试、状态快照导入导出等。</p><p>Vuex解决了多个组件共享状态时面临的两个问题：</p><ul><li>多个视图依赖于同一状态：传参方法对于多层嵌套组件将会非常繁琐，并且对于兄弟组件间的状态传递无能为力</li><li>不同视图的行为需要变更同一状态：经常会采用父子组件直接引用或者通过事件来变更和同步状态的多份拷贝，这些模式非常脆弱，通常会导致无法维护的代码</li></ul><h2>二、Vuex安装</h2><p>使用npm安装Vuex：</p><pre>npm install vuex@next --save</pre><p>或者使用yarn安装：</p><pre>yarn add vuex@next --save</pre><p><strong>注意</strong>：安装Vuex时，需要安装支持Vue 3新版本的Vuex，即这里的vuex@next。支持Vue 2.x的Vuex版本名是Vuex。</p><p>如果需要使用dev分支下的最新版本，可以在GitHub上克隆代码并自己构建：</p><pre>git clone https://github.com/vuejs/vuex.git node_modules/vuex
cd node_modules/vuex
yarn
yarn build</pre><h2>三、Vuex核心概念与状态管理</h2><h3>3.1 Store（仓库）</h3><p>每一个Vuex应用的核心就是store（仓库），"store"可以看作一个容器，包含着应用中大部分的状态（state）。Vuex和单纯的全局对象有以下不同点：</p><ul><li><strong>Vuex的状态存储是响应式的</strong>：当Vue 3组件从store中读取状态的时候，若store中的状态发生变化，那么相应的组件也会得到高效更新</li><li><strong>不能直接改变store中的状态</strong>：改变store中状态的唯一途径就是显式地提交（commit）mutation。这样Vuex可以方便跟踪每一个状态的变化，从而让Vuex能够实现一些工具帮助管理应用</li></ul><h3>3.2 组件中获取Vuex状态</h3><p>Vuex中的状态是响应式的，因此从store实例中读取状态的方法是在<strong>计算属性</strong>中返回相应状态：</p><pre>// 创建一个Counter组件
const Counter = {
  template: ''&lt;div&gt;{{ count }}&lt;/div&gt;'',
  computed: {
    count () {
      return store.state.count
    }
  }
}</pre><p>每当store.state.count发生变化时，计算属性会重新计算并触发与其相关的DOM对象更新。然而这种模式会使组件依赖全局状态单例，导致在模块化构建系统中，每个需要使用状态的组件都需要频繁导入，并且在测试组件时需要模拟状态。</p><h3>3.3 辅助函数mapState()</h3><p>当一个组件需要获取多个状态时，每个状态都声明为计算属性则会冗余且重复。使用<strong>mapState()</strong>辅助函数帮助生成计算属性，可以解决这个问题：</p><pre>import { mapState } from ''vuex''

export default {
  // ...
  computed: mapState({
    count: state =&gt; state.count,
    // 传字符串参数''count''等同于''state =&gt; state.count''
    countAlias: ''count'',
    // 为了能够使用''this''获取局部状态，必须使用常规函数
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}</pre><h3>3.4 对象展开运算符</h3><p>mapState()函数返回一个对象，通常情况下需要一个工具函数将多个对象合并成一个对象，并传递给计算属性，<strong>对象展开运算符</strong>可以极大地简化这个过程：</p><pre>computed: {
  localComputed() { /* ... */ },
  // 使用对象展开运算符将此对象混入到外部对象中
  ...mapState({
    // ...
  })
}</pre><h2>四、Vuex状态获取方法（Getters）</h2><h3>4.1 基本使用</h3><p>有时候需要从store的state中衍生出一些状态，例如对列表进行过滤并计数。为了简化上述代码，Vuex允许在store中定义getters内的函数，简称为<strong>getter函数</strong>，getter函数接受state作为它的第一个参数：</p><pre>const store = createStore({
  state: {
    todos: [
      { id: 1, text: ''...'', done: true },
      { id: 2, text: ''...'', done: false }
    ]
  },
  getters: {
    // 定义getter函数
    doneTodos (state) {
      return state.todos.filter(todo =&gt; todo.done)
    }
  }
})</pre><h3>4.2 辅助函数mapGetters()</h3><p><strong>mapGetters</strong>辅助函数仅仅是将store中的getter函数映射到局部计算属性：</p><pre>import { mapGetters } from ''vuex''

export default {
  // ...
  computed: {
    // 使用对象展开运算符将getter函数混入computed对象中
    ...mapGetters([
      ''doneTodosCount'',
      ''anotherGetter'',
      // ...
    ])
  }
}</pre><p>也可以将getter函数重新命名：</p><pre>...mapGetters({
  // 把''this.doneCount''映射为''this.$store.getters.doneTodosCount''
  doneCount: ''doneTodosCount''
})</pre><h2>五、Vuex状态同步更改方法（Mutations）</h2><h3>5.1 提交mutation</h3><p>在Vuex的store中，更改状态的唯一方法是<strong>提交mutation</strong>。mutation类似于事件，定义在mutations内部，每个mutation包含一个<strong>字符串类型（type）</strong>和一个<strong>回调函数（handler）</strong>。回调函数的功能是实际进行状态更改，并且第一个参数是state，mutation处理函数不能被直接调用，而是需要以相应的type调用<strong>store.commit()</strong>函数：</p><pre>const store = createStore({
  state: {
    count: 1
  },
  mutations: {
    increment (state) {
      // 变更状态
      state.count++
    }
  }
})

store.commit(''increment'')</pre><h3>5.2 对象风格提交方式</h3><p>提交mutation的另一种方式是直接使用包含type属性的对象。当使用对象风格的提交方式，整个对象都作为<strong>载荷（payload）</strong>传给mutation函数：</p><pre>store.commit({
  type: ''increment'',
  amount: 10
})

mutations: {
  increment (state, payload) {
    state.count += payload.amount
  }
}</pre><h2>六、Vuex状态异步更改方法（Actions）</h2><h3>6.1 Action的概念</h3><p>Action类似于mutation，不同在于：</p><ul><li>Action<strong>提交的是mutation</strong>，而不是直接变更状态</li><li>Action<strong>可以包含任意异步操作</strong></li></ul><p>下面注册一个简单的action：</p><pre>const store = createStore({
  state: { count: 0 },
  mutations: {
    increment (state) { state.count++ }
  },
  actions: {
    increment (context) {
      context.commit(''increment'')
    }
  }
})</pre><h3>6.2 分发Action</h3><p>Action通过<strong>store.dispatch()</strong>方法触发：</p><pre>store.dispatch(''increment'')</pre><p>Action通常是异步的，store.dispatch()函数可以处理被触发的action函数返回的Promise对象，处理完成后仍旧返回Promise对象：</p><pre>actions: {
  actionA ({ commit }) {
    return new Promise((resolve, reject) =&gt; {
      setTimeout(() =&gt; {
        commit(''someMutation'')
        resolve()
      }, 1000)
    })
  }
}

store.dispatch(''actionA'').then(() =&gt; {
  // ...
})</pre><p>在另一个action中可以组合使用：</p><pre>actions: {
  actionB ({ dispatch, commit }) {
    return dispatch(''actionA'').then(() =&gt; {
      commit(''someOtherMutation'')
    })
  }
}</pre><h2>七、Vuex状态模块化管理</h2><h3>7.1 模块动态注册</h3><p>使用<strong>store.registerModule()</strong>函数注册模块：</p><pre>import { createStore } from ''vuex''

const store = createStore({ /* 选项 */ })

// 注册模块''myModule''
store.registerModule(''myModule'', {
  // ...
})

// 注册嵌套模块''nested/myModule''
store.registerModule([''nested'', ''myModule''], {
  // ...
})</pre><p>通过store.state.myModule和store.state.nested.myModule访问模块的状态。模块动态注册指通过其他Vue 3插件在store中附加新模块的功能，从而使用Vuex管理状态。例如，vuex-router-sync插件就是通过动态注册模块将Vue Router和Vuex结合，实现应用的路由状态管理。</p><p>相关API：</p><ul><li><strong>store.registerModule(moduleName, module)</strong>：动态注册模块</li><li><strong>store.unregisterModule(moduleName)</strong>：动态卸载模块（无法卸载静态模块）</li><li><strong>store.hasModule(moduleName)</strong>：检查该模块是否已经被注册到store</li></ul><p>需要注意嵌套模块应该以<strong>数组形式</strong>传递给registerModule和hasModule，而不是以路径字符串的形式传递给module。</p><h3>7.2 模块重用</h3><p>创建一个模块的多个实例的需求如下：</p><ul><li>创建多个store，它们共用一个模块</li><li>在一个store中多次注册同一个模块</li></ul><p>如果使用一个纯对象来声明模块的状态，那么这个状态对象会通过引用被共享，导致状态对象被修改时store或模块间数据互相污染的问题。实际上这和Vue 3组件内的data是同样的问题，因此解决办法也相同：<strong>使用一个函数来声明模块状态</strong>：</p><pre>const MyReusableModule = {
  state: () =&gt; ({
    foo: ''bar''
  }),
  // mutation、action和getter等等...
}</pre><h3>7.3 命名空间</h3><p>默认情况下，模块内部的action、mutation和getter是注册在<strong>全局命名空间</strong>的。如果希望模块具有更高的封装度和复用性，可以通过添加<strong>namespaced: true</strong>的方式使其成为带命名空间的模块。当模块被注册后，它的所有getter、action及mutation都会自动根据模块注册的路径调整命名。</p><pre>const store = createStore({
  modules: {
    account: {
      namespaced: true,
      state: () =&gt; ({ ... }),
      getters: {
        isAdmin () { ... } // -&gt; getters[''account/isAdmin'']
      },
      actions: {
        login () { ... } // -&gt; dispatch(''account/login'')
      },
      mutations: {
        login () { ... } // -&gt; commit(''account/login'')
      }
    }
  }
})</pre>', '深入讲解Vuex集中式状态管理：核心概念与Store响应式原理、mapState辅助函数与对象展开运算符、Getter状态派生与mapGetters映射、Mutation同步提交与对象风格载荷、Action异步处理与Promise链式调用、模块动态注册与命名空间管理', '/img/11.jpg', 1, 1, 1145, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14', 0, 0);

-- ----------------------------
-- Table structure for article_tag
-- ----------------------------
DROP TABLE IF EXISTS `article_tag`;
CREATE TABLE `article_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_article_tag`(`article_id` ASC, `tag_id` ASC) USING BTREE,
  INDEX `idx_tag_id`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_tag
-- ----------------------------
-- 文章1: 个人博客系统开发文档 -> Vue, 前端, 全栈, 项目实战
INSERT INTO `article_tag` VALUES (1, 1, 1);
INSERT INTO `article_tag` VALUES (2, 1, 2);
INSERT INTO `article_tag` VALUES (3, 1, 9);
INSERT INTO `article_tag` VALUES (4, 1, 10);
-- 文章2: 第1章 Vue 3 简介 -> Vue, 前端, 入门
INSERT INTO `article_tag` VALUES (5, 2, 1);
INSERT INTO `article_tag` VALUES (6, 2, 2);
INSERT INTO `article_tag` VALUES (7, 2, 3);
-- 文章3: 第2章 Hello World 与 Vue 3 基础特性 -> Vue, 前端, 入门
INSERT INTO `article_tag` VALUES (8, 3, 1);
INSERT INTO `article_tag` VALUES (9, 3, 2);
INSERT INTO `article_tag` VALUES (10, 3, 3);
-- 文章4: 第3章 Vue 3 基本指令 -> Vue, 前端, 入门
INSERT INTO `article_tag` VALUES (11, 4, 1);
INSERT INTO `article_tag` VALUES (12, 4, 2);
INSERT INTO `article_tag` VALUES (13, 4, 3);
-- 文章5: 第4章 Vue 3 组件 -> Vue, 前端, 组件化
INSERT INTO `article_tag` VALUES (14, 5, 1);
INSERT INTO `article_tag` VALUES (15, 5, 2);
INSERT INTO `article_tag` VALUES (16, 5, 4);
-- 文章6: 第5章 Vue 3 样式绑定 -> Vue, 前端, 组件化
INSERT INTO `article_tag` VALUES (17, 6, 1);
INSERT INTO `article_tag` VALUES (18, 6, 2);
INSERT INTO `article_tag` VALUES (19, 6, 4);
-- 文章7: 第6章 Vue 3 组件复用 -> Vue, 前端, 组件化
INSERT INTO `article_tag` VALUES (20, 7, 1);
INSERT INTO `article_tag` VALUES (21, 7, 2);
INSERT INTO `article_tag` VALUES (22, 7, 4);
-- 文章8: 第7章 Vue Router 路由管理 -> Vue, 前端, 路由
INSERT INTO `article_tag` VALUES (23, 8, 1);
INSERT INTO `article_tag` VALUES (24, 8, 2);
INSERT INTO `article_tag` VALUES (25, 8, 5);
-- 文章9: 第8章 Vue 3 服务端通信 -> Vue, 前端, 网络请求
INSERT INTO `article_tag` VALUES (26, 9, 1);
INSERT INTO `article_tag` VALUES (27, 9, 2);
INSERT INTO `article_tag` VALUES (28, 9, 7);
-- 文章10: 第9章 Vue CLI 项目部署 -> Vue, 前端, 工程化
INSERT INTO `article_tag` VALUES (29, 10, 1);
INSERT INTO `article_tag` VALUES (30, 10, 2);
INSERT INTO `article_tag` VALUES (31, 10, 8);
-- 文章11: 第10章 Vuex 状态管理 -> Vue, 前端, 状态管理
INSERT INTO `article_tag` VALUES (32, 11, 1);
INSERT INTO `article_tag` VALUES (33, 11, 2);
INSERT INTO `article_tag` VALUES (34, 11, 6);

-- ----------------------------
-- Table structure for blog_config
-- ----------------------------
DROP TABLE IF EXISTS `blog_config`;
CREATE TABLE `blog_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '设置ID',
  `config_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置值',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_config
-- ----------------------------
INSERT INTO `blog_config` VALUES (1, 'blog_name', '个人技术博客', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (2, 'blog_description', '分享技术，记录生活', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (3, 'blog_author', '王可昕', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (4, 'blog_footer', 'Copyright © 2026 个人博客 All Rights Reserved', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (8, 'about_name', '王可昕', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (9, 'about_job', '学生', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (10, 'about_intro', '北邮世纪软工1班学生', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (11, 'about_content', 'Ciallo～(∠・ω< )⌒☆', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (12, 'social_github', 'https://github.com/NeneAyachi0721', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (13, 'social_bilibili', 'https://space.bilibili.com/436646687', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (14, 'social_steam', 'https://steamcommunity.com/profiles/76561199568695173', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `blog_config` VALUES (15, 'social_email', 'Sherry1318476070@gmail.com', '2026-05-20 11:45:14', '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类描述',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父分类ID(0表示顶级分类)',
  `order_num` int NULL DEFAULT 0 COMMENT '排序号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '计算机', '计算机相关文章', 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `category` VALUES (2, '动漫', '动漫相关文章', 0, 2, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `category` VALUES (3, '游戏', '游戏相关文章', 0, 3, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `category` VALUES (4, '高达', '高达相关文章', 0, 4, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `category` VALUES (5, '汽车', '汽车相关文章', 0, 5, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `category` VALUES (6, '摩托车', '摩托车相关文章', 0, 6, '2026-05-20 11:45:14', '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `user_id` bigint NOT NULL COMMENT '评论用户ID',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父评论ID(0表示顶级评论)',
  `to_user_id` bigint NULL DEFAULT 0 COMMENT '回复用户ID(0表示不是回复)',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(0:待审核,1:已通过,2:已拒绝)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 'Ciallo～(∠・ω< )⌒☆', 1, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (2, 'Ciallo～(∠・ω< )⌒☆', 1, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (3, 'Ciallo～(∠・ω< )⌒☆', 1, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (4, 'Ciallo～(∠・ω< )⌒☆', 2, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (5, 'Ciallo～(∠・ω< )⌒☆', 2, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (6, 'Ciallo～(∠・ω< )⌒☆', 2, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (7, 'Ciallo～(∠・ω< )⌒☆', 3, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (8, 'Ciallo～(∠・ω< )⌒☆', 3, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (9, 'Ciallo～(∠・ω< )⌒☆', 3, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (10, 'Ciallo～(∠・ω< )⌒☆', 4, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (11, 'Ciallo～(∠・ω< )⌒☆', 4, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (12, 'Ciallo～(∠・ω< )⌒☆', 4, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (13, 'Ciallo～(∠・ω< )⌒☆', 5, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (14, 'Ciallo～(∠・ω< )⌒☆', 5, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (15, 'Ciallo～(∠・ω< )⌒☆', 5, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (16, 'Ciallo～(∠・ω< )⌒☆', 6, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (17, 'Ciallo～(∠・ω< )⌒☆', 6, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (18, 'Ciallo～(∠・ω< )⌒☆', 6, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (19, 'Ciallo～(∠・ω< )⌒☆', 7, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (20, 'Ciallo～(∠・ω< )⌒☆', 7, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (21, 'Ciallo～(∠・ω< )⌒☆', 7, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (22, 'Ciallo～(∠・ω< )⌒☆', 8, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (23, 'Ciallo～(∠・ω< )⌒☆', 8, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (24, 'Ciallo～(∠・ω< )⌒☆', 8, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (25, 'Ciallo～(∠・ω< )⌒☆', 9, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (26, 'Ciallo～(∠・ω< )⌒☆', 9, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (27, 'Ciallo～(∠・ω< )⌒☆', 9, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (28, 'Ciallo～(∠・ω< )⌒☆', 10, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (29, 'Ciallo～(∠・ω< )⌒☆', 10, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (30, 'Ciallo～(∠・ω< )⌒☆', 10, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (31, 'Ciallo～(∠・ω< )⌒☆', 11, 2, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (32, 'Ciallo～(∠・ω< )⌒☆', 11, 3, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `comment` VALUES (33, 'Ciallo～(∠・ω< )⌒☆', 11, 4, 0, 0, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for friend_link
-- ----------------------------
DROP TABLE IF EXISTS `friend_link`;
CREATE TABLE `friend_link`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '链接ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接名称',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接地址',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '链接logo',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '链接描述',
  `order_num` int NULL DEFAULT 0 COMMENT '排序号',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(0:隐藏,1:显示)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '友情链接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of friend_link
-- ----------------------------
INSERT INTO `friend_link` VALUES (1, 'GitHub', 'https://github.com', '/img/GitHub.png', '全球最大的代码托管平台', 1, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `friend_link` VALUES (2, 'Vue.js', 'https://vuejs.org', '/img/Vue.js.png', '渐进式JavaScript框架', 2, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `friend_link` VALUES (3, 'Spring', 'https://spring.io', '/img/Spring.png', '企业级Java应用开发框架', 3, 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签颜色',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES (1, 'Vue', '#f4d3dc', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (2, '前端', '#f6d5ca', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (3, '入门', '#efdabe', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (4, '组件化', '#e0e2bf', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (5, '路由', '#d0e7cc', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (6, '状态管理', '#c4e8df', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (7, '网络请求', '#c2e6f1', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (8, '工程化', '#cbe1fc', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (9, '全栈', '#dcd9fb', '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `tag` VALUES (10, '项目实战', '#ebd4ef', '2026-05-20 11:45:14', '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(加密存储)',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色code',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '性别',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(0:禁用,1:正常)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$Cc6gX7Jel5UtKreBdrY8SeRiqwqEuccdySNafjQRMtz30KE92sPaS', 'Sherry1318476070@gmail.com', '13502340721', 'ADMIN', '王可昕', '女', '/img/王可昕.jpg', 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `user` VALUES (2, 'AyachiNene', '$2a$10$Cc6gX7Jel5UtKreBdrY8SeRiqwqEuccdySNafjQRMtz30KE92sPaS', 'AyachiNene@gmail.com', '13502340721', 'USER', '绫地宁宁', '女', '/img/绫地宁宁.jpg', 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `user` VALUES (3, 'TomotakeYoshino', '$2a$10$Cc6gX7Jel5UtKreBdrY8SeRiqwqEuccdySNafjQRMtz30KE92sPaS', 'TomotakeYoshino@gmail.com', '13502340721', 'USER', '朝武芳乃', '女', '/img/朝武芳乃.jpg', 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `user` VALUES (4, 'HitachiMako', '$2a$10$Cc6gX7Jel5UtKreBdrY8SeRiqwqEuccdySNafjQRMtz30KE92sPaS', 'HitachiMako@gmail.com', '13502340721', 'USER', '常陆茉子', '女', '/img/常陆茉子.jpg', 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');
INSERT INTO `user` VALUES (5, 'TMurasame', '$2a$10$Cc6gX7Jel5UtKreBdrY8SeRiqwqEuccdySNafjQRMtz30KE92sPaS', 'Murasame@gmail.com', '13502340721', 'USER', '丛雨', '女', '/img/丛雨.jpg', 1, '2026-05-20 11:45:14', '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for user_collect
-- ----------------------------
DROP TABLE IF EXISTS `user_collect`;
CREATE TABLE `user_collect`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_article`(`user_id` ASC, `article_id` ASC) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_collect
-- ----------------------------
INSERT INTO `user_collect` VALUES (1, 2, 1, '2026-05-20 11:45:14');

-- ----------------------------
-- Table structure for user_like
-- ----------------------------
DROP TABLE IF EXISTS `user_like`;
CREATE TABLE `user_like`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_article`(`user_id` ASC, `article_id` ASC) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_like
-- ----------------------------
INSERT INTO `user_like` VALUES (1, 2, 1, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (2, 3, 1, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (3, 4, 1, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (4, 2, 2, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (5, 3, 2, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (6, 4, 2, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (7, 2, 3, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (8, 3, 3, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (9, 4, 3, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (10, 2, 4, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (11, 3, 4, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (12, 4, 4, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (13, 2, 5, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (14, 3, 5, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (15, 4, 5, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (16, 2, 6, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (17, 3, 6, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (18, 4, 6, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (19, 2, 7, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (20, 3, 7, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (21, 4, 7, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (22, 2, 8, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (23, 3, 8, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (24, 4, 8, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (25, 2, 9, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (26, 3, 9, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (27, 4, 9, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (28, 2, 10, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (29, 3, 10, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (30, 4, 10, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (31, 2, 11, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (32, 3, 11, '2026-05-20 11:45:14');
INSERT INTO `user_like` VALUES (33, 4, 11, '2026-05-20 11:45:14');

SET FOREIGN_KEY_CHECKS = 1;
