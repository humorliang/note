## 
### 数据库表结构设置
1. 用户表
    - 用户名，密码，邮箱
2. 权限表
    - 权限(00只读  01只写 10可读可写 11不可读不可写)，用户ID
3. 文章表
    - 标题，内容，作者，日期，用户ID，分类ID
4. 评论表
    - 内容，文章ID，用户ID
5. 回复表
    - 内容，评论ID，用户ID
6. 留言表
    - 内容，用户ID
7. 分类表
    - 名称
* 表关系映射
```
    用户 --- 1 : 1 --> 权限
    用户 --- 1 : n --> 文章 -- 1:n --> 评论 
                          `-- m:n --> 分类
    用户 --- 1 : n --> 评论 -- 1:n -->  回复
    用户 --- 1 : n --> 回复 
    用户 --- 1 : n --> 留言 -- 1:n --> 回复
    用户 --- 1 : 1 --> 权限
```
* 数据表SQL
```sql
/*创建数据库*/
CREATE DATABASE [IF NOT EXISTS] blog_cms;
USE blog_cms;

/*用户表*/
CREATE TABLE IF NOT EXISTS user(
    `id` INT AUTO_INCREMENT,
    `user_name` VARCHAR(30) NOT NULL,
    `pass_word` VARCHAR(255) NOT NULL,
    `email` VARCHAR(30),
    PRIMARY KEY (`id`),
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*权限表*/
CREATE TABLE IF NOT EXISTS rule(
    `id` INT AUTO_INCREMENT,
    `rule_name` TINYINT DEFAULT 00 comment '00只读  01只写 10可读可写 11不可读不可写',
    `user_id` INT,
    PRIMARY KEY (`id`),
    foreign key(user_id) references user(id)
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*文章表*/
CREATE TABLE IF NOT EXISTS article(
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT,
    `user_id` INT,
    PRIMARY KEY (`id`),
    foreign key(user_id) references user(id)
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*分类表*/
CREATE TABLE IF NOT EXISTS tag(
    `id` INT AUTO_INCREMENT,
    `tag_name` VARCHAR(50),
    `article_id` INT UNSIGINED
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*文章  分类  关系表*/
CREATE TABLE IF NOT EXISTS article_tag(
    `tag_id` INT AUTO_INCREMENT,
    `article_id` INT,
    foreign key(tag_id) references tag(id),
    foreign key(article_id) references article(id)
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*评论表*/
CREATE TABLE IF NOT EXISTS comment(
    `id` INT AUTO_INCREMENT,
    `content` VARCHAR ,
    `user_id` INT,
    `article_id` INT,
    PRIMARY KEY (`id`),
    foreign key(user_id) references user(id),
    foreign key(article_id) references article(id)
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*回复表*/
CREATE TABLE IF NOT EXISTS reply(
    `id` INT AUTO_INCREMENT,
    `content` VARCHAR,
    `user_id` INT,
    `comment_id` INT,
    PRIMARY KEY (`id`),
    foreign key(user_id) references user(id),
    foreign key(comment_id) references comment(id)
)ENGINE=InnoDB DEFAULT CHATSET=utf8;

/*留言表*/
CREATE TABLE IF NOT EXISTS msg(
    `id` INT AUTO_INCREMENT,
    `content` VARCHAR,
    PRIMARY KEY (`id`),
)ENGINE=InnoDB DEFAULT CHATSET=utf8;
```