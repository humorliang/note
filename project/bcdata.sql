/*创建数据库*/
CREATE DATABASE IF NOT EXISTS `bg_cms`;
USE `bg_cms`;

/*用户表*/
CREATE TABLE IF NOT EXISTS `bc_users`(
    `user_id`  BIGINT(20)UNSIGNED AUTO_INCREMENT,
    `user_login` VARCHAR(60) NOT NULL COMMENT '用户名',
    `user_pass` VARCHAR(64) NOT NULL COMMENT '密码',
    `user_nicename` VARCHAR(50) DEFAULT '山猫' COMMENT '昵称',
    `user_email` VARCHAR(50)  DEFAULT '' COMMENT '邮箱',
    `user_registered` DATETIME DEFAULT now() COMMENT '注册时间',
    `user_activation_key` VARCHAR(60)  DEFAULT '0000' COMMENT '激活码',
    `user_status`   INT DEFAULT 0 COMMENT '用户状态',
    PRIMARY KEY (`user_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 用户元素据表 */
CREATE TABLE IF NOT EXISTS `bc_usermeta`(
    `meta_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `user_id` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键用户ID',
    `meta_key` VARCHAR(255),
    `meta_value` LONGTEXT,
    PRIMARY KEY (`meta_id`),
    foreign key(`user_id`) references bc_users(`user_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 分类表 */
CREATE TABLE IF NOT EXISTS `bc_terms`(
    `term_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `name` varchar(200) NOT NULL  COMMENT '分类名',
    `term_group` INT DEFAULT 0 COMMENT '分类组',
    PRIMARY KEY (`term_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 分类法表 */
CREATE TABLE IF NOT EXISTS `bc_term_taxonomy`(
    `term_taxonomy_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `term_id` BIGINT(20)UNSIGNED NOT NULL COMMENT '外键分类ID',
    `taxonomy` VARCHAR(32) NOT NULL COMMENT '分类法名',
    `description` VARCHAR(255) COMMENT '分类法描述',
    `parent_id` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键本身ID',
    PRIMARY KEY (`term_taxonomy_id`),
    foreign key(`parent_id`) references bc_term_taxonomy(`term_taxonomy_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 分类与分类法关系表*/
CREATE TABLE IF NOT EXISTS `bc_term_relationships`(
    `object_id` BIGINT(20)UNSIGNED DEFAULT 0  COMMENT '分类对象ID',
    `term_taxonomy_id` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键分类法ID',
    foreign key(`term_taxonomy_id`) references bc_term_taxonomy(`term_taxonomy_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 文章表 */
CREATE TABLE IF NOT EXISTS `bc_posts`(
    `post_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `post_author`  BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '作者',
    `post_date`  DATETIME DEFAULT now() COMMENT '时间',
    `post_content` LONGTEXT COMMENT '内容',
    `post_title` TEXT COMMENT '标题',
    `post_excerpt` TEXT COMMENT '描述',
    `post_status` VARCHAR(20) DEFAULT 'publish' COMMENT '文章状态',
    `comment_status` VARCHAR(20) DEFAULT 'open' COMMENT '评论状态',
    `post_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间', 
    `comment_count` INT COMMENT '评论数',
    `term_id` BIGINT(20)UNSIGNED COMMENT '外键到分类ID',
    PRIMARY KEY (`post_id`),
    foreign key(`post_author`) references bc_users(`user_id`),
    foreign key(`term_id`) references bc_terms(`term_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 文章元数据表 */
CREATE TABLE IF NOT EXISTS `bc_postmeta`(
    `meta_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `post_id` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键文章ID',
    `meta_key` VARCHAR(255),
    `meta_value` LONGTEXT,
    PRIMARY KEY (`meta_id`),
    foreign key(`post_id`) references bc_posts(`post_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


/* 评论表 */
CREATE TABLE IF NOT  EXISTS `bc_comments`(
    `comment_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `comment_post_id` BIGINT(20)UNSIGNED COMMENT '外键文章ID',
    `comment_author` TINYTEXT COMMENT '评论作者',
    `comment_author_email` VARCHAR(100) COMMENT '评论作者邮箱',
    `comment_author_IP` VARCHAR(100) COMMENT '评论作者IP',
    `comment_date` DATETIME DEFAULT now() COMMENT '评论时间',
    `comment_content` TEXT COMMENT '评论内容',
    `comment_approved` VARCHAR(20) COMMENT '是否被允许',
    `comment_parent` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键父评论ID',
    `user_id` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键用户ID',
    PRIMARY KEY (`comment_id`),
    foreign key(`comment_post_id`) references bc_posts(`post_id`),
    foreign key(`comment_parent`) references bc_comments(`comment_id`),
    foreign key(`user_id`) references bc_users(`user_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 评论元数据表 */
CREATE TABLE IF NOT  EXISTS `bc_commentmeta`(
    `meta_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `comment_id` BIGINT(20)UNSIGNED DEFAULT 0 COMMENT '外键评论ID',
    `meta_key` VARCHAR(255),
    `meta_value` LONGTEXT,
    PRIMARY KEY (`meta_id`),
    foreign key(`comment_id`) references bc_comments(`comment_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


/* 连接表 */
CREATE TABLE IF NOT  EXISTS `bc_links`(
    `link_id` BIGINT(20)UNSIGNED  AUTO_INCREMENT,
    `link_url` VARCHAR(255) COMMENT '链接URL',
    `link_name` VARCHAR(255) COMMENT '链接名称',
    `link_image` VARCHAR(255) COMMENT '链接图片',
    `link_description` VARCHAR(255) COMMENT '链接描述',
    `link_visible` VARCHAR(10) DEFAULT 'Y' COMMENT '是否可见',
    `link_owner` BIGINT(20)UNSIGNED DEFAULT 1 COMMENT '添加者ID',
    `link_rating` INT DEFAULT 0 COMMENT '链接评分等级',
    `link_updated` DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP  COMMENT '链接更新时间',
    PRIMARY KEY (`link_id`),
    foreign key(`link_owner`) references bc_users(`user_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

