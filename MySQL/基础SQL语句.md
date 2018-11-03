### 数据库操作
mysql:
> mac PassWord:  qQwer@@1234
#### 创建
```sql
/* IF NOT EXISTS 子句 如果不存在  防止数据错误*/
CREATE DATABASE [IF NOT EXISTS] database_name;
````
#### 导入
```sql
1. 创建一个数据库并且切换
mysql> CREATE DATABASE IF NOT EXISTS dbname DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
mysql> use dbname;

2. 导入数据脚本
mysql> source /filePath/db.sql;

```
#### 选择
```sql
USE database_name;
```
#### 查询
```sql
SHOW DATABASES;
````
#### 删除
```sql
/* IF NOT EXISTS 子句 如果存在 防止数据错误*/
DROP DATABASE IF EXISTS tempdb;
```

### 数据表操作
#### 查询
```sql
SELECT  /*选择字段*/
    column_1, column_2, ...
FROM /* 从哪张表*/
    table_1
[INNER | LEFT |RIGHT] JOIN table_2 ON conditions      /*关联查询：*/
WHERE
    conditions  /*条件*/
GROUP BY column_1     /*分组*/
HAVING group_conditions /*分组中的子包含*/
ORDER BY column_1  /*排序*/
LIMIT offset, length; /*限制返回的条数*/
```
#### where子句
```sql
/*过滤表达式的比较运算符*/
操作符	          描述
=	          等于，几乎任何数据类型都可以使用它。
<> 或 !=	  不等于
<	          小于，通常使用数字和日期/时间数据类型。
>	          大于，
<=	          小于或等于
>=	          大于或等于

还有一些条件可以配合下面子句进行复杂的筛选。

BETWEEN  选择在给定范围值内的值   expr [NOT] BETWEEN begin_expr AND end_expr;
LIKE     匹配基于模式匹配的值       firstName LIKE 'a%';
IN       指定值是否匹配列表中的任何值
IS NULL  检查该值是否为NULL
```
DROP TABLE IF EXISTS 'user';  
CREATE TABLE 'user' (
  'id'      INT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  'email'    VARCHAR(255) COMMENT '用户邮箱',
  'phone'    VARCHAR(255) COMMENT '手机号码',
  'password' VARCHAR(255) NOT NULL COMMENT '用户密码',
  'user_name' VARCHAR(255) COMMENT '用户昵称',
  'age' INT COMMENT '年龄',
  'sex' VARCHAR(255) COMMENT '性别',
  'status'   INT  DEFAULT 0 COMMENT '用户状态',
  'register_time'  DATETIME  NOT NULL  DEFAULT NOW() COMMENT '注册时间',
  PRIMARY KEY (id)
  ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `user`(
   `id` INT UNSIGNED AUTO_INCREMENT,
   `username` VARCHAR(100) NOT NULL,
   `password` VARCHAR(40) NOT NULL,
   `age` VARCHAR(10),
   `sex` VARCHAR(10),
   `phone` VARCHAR(20),
   PRIMARY KEY ( `id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
