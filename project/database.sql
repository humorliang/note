/*创建数据库*/
CREATE DATABASE IF NOT EXISTS `blog_cms`;
USE `blog_cms`;

/*用户表*/
CREATE TABLE IF NOT EXISTS `user`(
    `id` INT AUTO_INCREMENT,
    `user_name` VARCHAR(30) NOT NULL,
    `pass_word` VARCHAR(255) NOT NULL,
    `email` VARCHAR(30),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*权限表*/
CREATE TABLE IF NOT EXISTS `rule`(
    `id` INT AUTO_INCREMENT,
    `rule_name` TINYINT DEFAULT 00 comment '00只读  01只写 10可读可写 11不可读不可写',
    `user_id` INT,
    PRIMARY KEY (`id`),
    foreign key(`user_id`) references user(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*文章表*/
CREATE TABLE IF NOT EXISTS `article`(
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `user_id` INT,
    PRIMARY KEY (`id`),
    foreign key(`user_id`) references user(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*分类表*/
CREATE TABLE IF NOT EXISTS `tag`(
    `id` INT AUTO_INCREMENT,
    `tag_name` VARCHAR(50) NOT NULL,
    `article_id` INT,
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*文章  分类  关系表*/
CREATE TABLE IF NOT EXISTS `article_tag`(
    `tag_id` INT,
    `article_id` INT,
    foreign key(`tag_id`) references tag(`id`),
    foreign key(`article_id`) references article(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*评论表*/
CREATE TABLE IF NOT EXISTS `comment`(
    `id` INT AUTO_INCREMENT,
    `content` VARCHAR(255),
    `user_id` INT,
    `article_id` INT,
    PRIMARY KEY (`id`),
    foreign key(`user_id`) references user(`id`),
    foreign key(`article_id`) references article(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*回复表*/
CREATE TABLE IF NOT EXISTS `reply`(
    `id` INT AUTO_INCREMENT,
    `content` VARCHAR(255),
    `user_id` INT,
    `comment_id` INT,
    PRIMARY KEY (`id`),
    foreign key(`user_id`) references user(`id`),
    foreign key(`comment_id`) references comment(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*留言表*/
CREATE TABLE IF NOT EXISTS `msg`(
    `id` INT AUTO_INCREMENT,
    `content` VARCHAR(255),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
