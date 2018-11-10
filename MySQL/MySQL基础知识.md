## MySQL基础知识
### 数据库操作
mysql:
> mac PassWord:  qQwer@@1234
#### 创建
```sql
/* IF NOT EXISTS 子句 如果不存在  防止数据错误*/
CREATE DATABASE [IF NOT EXISTS] database_name;
```
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
### 数据类型
#### 数值类型
类型	|  大小	|  范围（有符号）|	范围（无符号）|	用途
---|---|---|---|---
TINYINT	|1 字节|(-128，127),(0，255)|小整数值
SMALLINT|2 字节	|(-32 768，32 767),(0，65 535)	| 大整数值
MEDIUMINT|3 字节|(-8 388 608，8 388 607),(0，16 777 215) |	大整数值
INT或INTEGER|4 字节|(-2 147 483 648，2 147 483 647)	(0，4 294 967 295) |	大整数值
BIGINT|	8 字节|(-9 233 372 036 854 775 808，9 223 372 036 854 775 807),(0，18 446 744 073 709 551 615) |极大整数值
FLOAT|4 字节|(-3.402 823 466 E+38，-1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38)0，(1.175 494 351 E-38，3.402 823 466 E+38) |单精度|浮点数值
DOUBLE|	8 字节|	(-1.797 693 134 862 315 7 E+308，-2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)	0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)|双精度|浮点数值
DECIMAL	|对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2|	依赖于M和D的值|	依赖于M和D的值|小数值

#### 日期和时间类型
类型|	大小(字节)	|范围|	格式|	用途
---|---|---|---|---
DATE	|3  |1000-01-01/9999-12-31	|YYYY-MM-DD|	日期值
TIME	|3|'-838:59:59'/'838:59:59'	|HH:MM:SS	|时间值或持续时间|
YEAR	|1|1901/2155|	YYYY|	年份值
DATETIME	|8|	1000-01-01 00:00:00/9999-12-31 23:59:59	|YYYY-MM-DD HH:MM:SS	|混合日期和时间值
TIMESTAMP	|4|	1970-01-01 00:00:00/2038结束时间是第 2147483647 秒，北京时间 2038-1-19 11:14:07，格林尼治时间 2038年1月19日 凌晨 03:14:07|YYYYMMDD HHMMSS	|混合日期和时间值，时间戳

#### 字符串类型
类型	|大小	|用途
---|---|---
CHAR	|0-255字节	|定长字符串
VARCHAR	|0-65535 字节|	变长字符串
TINYBLOB	|0-255字节|	不超过 255 个字符的二进制字符串
TINYTEXT	|0-255字节|	短文本字符串
BLOB	|0-65 535字节|	二进制形式的长文本数据
TEXT	|0-65 535字节|	长文本数据
MEDIUMBLOB	|0-16 777 215字节|	二进制形式的中等长度文本数据
MEDIUMTEXT	|0-16 777 215字节|	中等长度文本数据
LONGBLOB	|0-4 294 967 295字节|	二进制形式的极大文本数据
LONGTEXT	|0-4 294 967 295字节	|极大文本数据
### 表、字段操作
#### 
#### 查询
* 查看表结构
```sql
desc table_name;
```
* 查看表创建的详细SQL语句
```sql
show create table user \G;
```
* 查询字段值
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
#### 增加
* 创建表
```sql
CREATE TABLE table_name (
    column_name column_type
    );
/*示例*/
CREATE TABLE IF NOT EXISTS `post`(
   `id` INT UNSIGNED AUTO_INCREMENT, /*类型  字段约束 修饰*/
   `title` VARCHAR(100) NOT NULL,
   `author` VARCHAR(40) NOT NULL,
   `date` DATE,
   PRIMARY KEY ( `id` )  /*定义主键*/
)ENGINE=InnoDB DEFAULT CHARSET=utf8; /*定义引擎  字符集*/
```
* 表的外键
>外键：A表(子表)的非主键字段，指向B表(父表)的主键字段，则A表的这个字段称为外键

>外键约束（对父表）：在父表上进行update/delete以更新或删除在子表中有一条或多条对应匹配行的候选键时，父表的行为取决于：在定义子表的外键时指定的on update/on delete子句。

关键字   |   含义
---|---
CASCADE  |  删除包含与已删除键值有参照关系的所有记录
SET NULL  |  修改包含与已删除键值有参照关系的所有记录，使用NULL值替换(只能用于已标记为NOT NULL的字段)
RESTRICT  |  拒绝删除要求，直到使用删除键值的辅助表被手工删除，并且没有参照时(这是默认设置，也是最安全的设置)
NO ACTION  | 无操作

* 插入字段值
```sql
/*表 字段  值*/
INSERT INTO table_name ( field1, field2,...fieldN )
                       VALUES
                       ( value1, value2,...valueN );
```
#### 删除
* 删除表
```sql
/*表名*/
DROP TABLE table_name ;
```

* 删除字段
```sql
/*表名  筛选字段条件*/
DELETE FROM table_name [WHERE Clause]
/*示例*/
DELETE FROM user WHERE user_id=3;
```
#### 筛选
* 判断where
```sql
/*过滤表达式的比较运算符*/
操作符	          描述
=	          等于，几乎任何数据类型都可以使用它。
<> 或 !=	  不等于
<	          小于，通常使用数字和日期/时间数据类型。
>	          大于，
<=	          小于或等于
>=	          大于或等于
```
##### 常用筛选子句
* BETWEEN子句
```sql
BETWEEN  选择在给定范围值内的值   expr [NOT] BETWEEN begin_expr AND end_expr;
/*示例*/
DELETE FROM user WHERE id BETWEEN 11 and 16;
```
* LIKE子句
```sql
LIKE     匹配基于模式匹配的值       firstName LIKE 'a%';
/*示例*/
DELETE FROM user WHERE username LIKE '李%';
```
* IN子句
```sql
IN       指定值是否匹配列表中的任何值
/*示例*/
DELETE FROM user WHERE id [NOT] IN (1,2,3);
```
* 空值NULL
```sql
IS NULL: 当列的值是 NULL,此运算符返回 true。
IS NOT NULL: 当列的值不为 NULL, 运算符返回 true。
/*示例*/
DELETE FROM user WHERE username IS NULL;
DELETE FROM user WHERE username IS NOT NULL;
```
* 正则表达式 REGEXP
```sql
REGEXP      指定字符模板
/*示例*/
SELECT name FROM user WHERE name REGEXP '^st';
```

#### 更新
* 更新表结构
> ALTER 删除，添加, 修改表字段
```sql
/*删除字段*/
ALTER TABLE user  DROP age;

/*添加字段*/
ALTER TABLE user ADD age INT;

/*修改字段类型  MODIFY 或 CHANGE*/
ALTER TABLE user MODIFY username CHAR(20);

/*修改字段名称和类型 旧字段  新字段  类型*/
ALTER TABLE user CHANGE old_name new_name INT;
```
* update语句
```sql
/*表  字段  新值*/
UPDATE table_name SET field1=new_value1, field2=new_value2
[WHERE Clause]
/*示例*/
UPDATE user SET username='张三', password='123456'
```
#### 组合
* UNION语句
> 用于连接两个以上的 SELECT 语句的结果组合到一个结果集合中。多个 SELECT 语句会删除重复的数据。
```sql
/*两个select 结果集*/
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions]
UNION [ALL | DISTINCT] /*ALL：所有数据包含重复 DISTINCT:删除重复数据*/
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions];

/*示例*/
SELECT username FROM user01
UNION
SELECT username FROM user02
ORDER BY username;/*排序*/
```
* 连接（多表查询）
```
1. INNER JOIN（内连接,或等值连接）：获取两个表中字段匹配关系的记录。
2. LEFT JOIN（左连接）：获取左表所有记录，即使右表没有对应匹配的记录。
3. RIGHT JOIN（右连接）： 与 LEFT JOIN 相反，用于获取右表所有记录，即使左表没有对应匹配的记录。
```
表数据
- name_age表 == a表
```sql
+-----+--------+----+
| age | name  | id |
+-----+--------+----+
| 18  | 张三   | 1 |
| 20  | 王五   | 2 |
| 21  | 张麻子 | 3 |
+-----+--------+----+
```
- name_address表 == b表
```sql
+----------+------+----+
| address | name | id |
+----------+------+----+
| 北京一路 | 张三  | 1 |
| 北京二路 | 李四  | 2 |
| 北京三路 | 王五  | 3 |
+----------+------+----+
```
1. INNER JOIN 取两者共同部分
![内连接](img/img_innerjoin.gif)
```sql
/*name_age a 给表起别名*/
SELECT a.name,a.age,b.address FROM name_age a INNER JOIN name_address b WHERE（on） a.name=b.name;/* on 相当于where*/

+------+-----+----------+
| name | age | address |
+------+-----+----------+
| 张三 | 18 | 北京一路 |
| 王五 | 20 | 北京三路 |
+------+-----+----------+
```
2. LEFT JOIN 以左边数据表为准，没对上的为NUll
![内连接](img/img_leftjoin.gif)
```sql
SELECT a.name,a.age,b.address FROM name_age a left JOIN name_address b on
 a.name=b.name;
+--------+-----+----------+
| name  | age | address |
+--------+-----+----------+
| 张三   | 18 | 北京一路 |
| 王五   | 20 | 北京三路 |
| 张麻子  | 21 | NULL   |
+--------+-----+----------+
```
2. RIGHT JOIN 以右边的数据为准，没对上的为NUll
![内连接](img/img_rightjoin.gif)
```sql
SELECT b.name,a.age,b.address FROM name_age a right JOIN name_address b on a.name=b.name;
+------+------+----------+
| name | age  | address |
+------+------+----------+
| 张三 | 18   | 北京一路 |
| 王五 | 20   | 北京三路 |
| 李四 | NULL | 北京二路 |
+------+------+----------+
```
#### 数据处理
* 排序
```sql
/* ASC升序  DESC降序*/
ORDER BY field1, [field2...] [ASC [DESC]]

/*示例*/
SELECT * from USER ORDER BY age ASC
```
* 分组（将数据按规则归类，相同规则在一类）
> GROUP BY 语句根据 一个或多个列 对结果集进行分组(归类)。在分组的列上我们可以使用 COUNT, SUM, AVG,等函数。
```sql
/*function功能函数*/
SELECT column_name, function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name;
/*示例*/
SELECT name, COUNT(*) FROM   employee_tbl GROUP BY name;
+--------+----------+
| name   | COUNT(*) |
+--------+----------+
|  老王   |        1 |
|  老李   |        3 |
|  小王   |        2 |
+--------+----------+
/*理解*/
+----+--------+---------------------+--------+
| id | name   | date                | singin |
+----+--------+---------------------+--------+
|  1 | 老李    | 2017-08-22 10:25:33 |      1 |
|  2 | 小王    | 2017-08-20 10:25:47 |      3 |
|  3 | 老王    | 2017-08-19 10:26:02 |      2 |
|  4 | 小王    | 2017-08-07 10:26:14 |      4 |
|  5 | 老李    | 2017-08-11 10:26:40 |      4 |
|  6 | 老李    | 2017-08-04 10:26:54 |      2 |
+----+--------+---------------------+--------+
如果像上述的数据表结构我们想统计每个人有多少个记录的时候
我们可以使用分组，将其归到一类。
```
#### 事务
* 定义解析
```
mysql默认事务都是自动提交，一段行为统一进行提交。
事务的满足条件：
原子性（Atomicity，或称不可分割性）：
    一个事务要么全完成，要么全不完成，整体性原则。
一致性（Consistency）：
    在事务开始之前和结束以后，数据库完整性没有被破坏。
隔离性（Isolation，又称独立性）：
    并发事务应该避免交叉修改数据，因为数据库支持并发事务
持久性（Durability）：
    事务结束后对数据修改是永久性的。
```
* 事务语句
```sql
BEGIN或START TRANSACTION；显式地开启一个事务；
COMMIT；也可以使用COMMIT WORK，不过二者是等价的。COMMIT会提交事务，并使已对数据库进行的所有修改成为永久性的；
ROLLBACK；有可以使用ROLLBACK WORK，不过二者是等价的。回滚会结束用户的事务，并撤销正在进行的所有未提交的修改；
SAVEPOINT identifier；SAVEPOINT允许在事务中创建一个保存点，一个事务中可以有多个SAVEPOINT；
RELEASE SAVEPOINT identifier；删除一个事务的保存点，当没有指定的保存点时，执行该语句会抛出一个异常；
ROLLBACK TO identifier；把事务回滚到标记点；
SET TRANSACTION；用来设置事务的隔离级别。InnoDB存储引擎提供事务的隔离级别有READ UNCOMMITTED、READ COMMITTED、REPEATABLE READ和SERIALIZABLE。
```

* 事务处理方法与示例
```sql
/*事务处理的方法*/
1、用 BEGIN, ROLLBACK, COMMIT来实现

BEGIN 开始一个事务
ROLLBACK 事务回滚
COMMIT 事务确认
2、直接用 SET 来改变 MySQL 的自动提交模式:

SET AUTOCOMMIT=0 禁止自动提交
SET AUTOCOMMIT=1 开启自动提交

/*示例*/
mysql> begin;  # 开始事务
mysql> insert into test_table id value(5);
mysql> insert into test_table id value(6);
mysql> commit; # 提交事务
```

#### 索引
> 索引实际上也是一张表，索引应该建在where的条件列上，索引可以加快查询速度，但是索引会使insert，delete，update的速度变慢。
* 创建索引
```sql
CREATE INDEX indexName ON mytable(username(length)); 
```
* 查询索引
```sql
SHOW INDEX FROM table_name;
```
* 添加索引(修改表结构）
```sql
/*ATLER 创建*/
ALTER table tableName ADD INDEX indexName(columnName)

/*示例  创建时就指定索引*/
CREATE TABLE mytable(  
    ID INT NOT NULL,   
    username VARCHAR(16) NOT NULL,  
    INDEX [indexName] (username(16))  /*索引*/
);  
```
* 删除
```sql
/*使用drop删除*/
DROP INDEX [indexName] ON mytable; 

/*使用Alter删除*/
ALTER TABLE table_name DROP INDEX c;
```
* 唯一索引
```sql
/*创建索引 UNIQUE*/
CREATE UNIQUE INDEX indexName ON mytable(username(length)) 

/*修改表结构*/
ALTER table mytable ADD UNIQUE [indexName] (username(length))

/*创建表的时候直接指定*/
CREATE TABLE mytable(  
    ID INT NOT NULL,   
    username VARCHAR(16) NOT NULL,  
    UNIQUE [indexName] (username(length))  
);  
```
#### 临时表
> 临时表只在当前连接有效，退出连接时就会销毁。
```sql
/*语法*/
CREATE TEMPORARY TABLE table_name(
    colname  type_name
);
/*示例*/
CREATE TEMPORARY TABLE SalesSummary (
    product_name VARCHAR(50) NOT NULL
    total_sales DECIMAL(12,2) NOT NULL DEFAULT 0.00
    avg_unit_price DECIMAL(7,2) NOT NULL DEFAULT 0.00
    total_units_sold INT UNSIGNED NOT NULL DEFAULT 0
);
```
#### 复制表
```sql
/*步骤*/
1. 查看表完整的表结构
    SHOW CREATE TABLE 命令获取创建数据表(CREATE TABLE) 语句，该语句包含了原数据表的结构，索引等。
/*示例*/
/*-------------------------------------------------------*/
mysql> show create table user \G;
*************************** 1. row ***************************
       Table: user
Create Table: CREATE TABLE `user2` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(40) NOT NULL,
  `age` varchar(10) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8
/*-------------------------------------------------------*/

2. 用相同SQL语句创建别名表
以下命令显示的SQL语句，修改数据表名，并执行SQL语句，通过以上命令 将完全的复制数据表结构。
/*-------------------------------------------------------*/
mysql> CREATE TABLE `user2` (
    ->   `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    ->   `username` varchar(100) NOT NULL,
    ->   `password` varchar(40) NOT NULL,
    ->   `age` varchar(10) DEFAULT NULL,
    ->   `sex` varchar(10) DEFAULT NULL,
    ->   `phone` varchar(20) DEFAULT NULL,
    ->   PRIMARY KEY (`id`)
    -> ) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*-------------------------------------------------------*/

3. 复制表数据
如果你想复制表的内容，你就可以使用 INSERT INTO ... SELECT 语句来实现。
/*-------------------------------------------------------*/
mysql> INSERT INTO user2 (id,username,password,age,sex,phone) 
    -> SELECT id,username,password,age,sex,phone
    -> FROM user;
/*-------------------------------------------------------*/
/*结果  完成复制*/
mysql> select * from user2;
+----+------------+----------+------+------+-------+
| id | username   | password | age  | sex  | phone |
+----+------------+----------+------+------+-------+
|  1 | 张三       | 123456   | NULL | NULL | NULL  |
|  2 | 1=\《""=1  | weq*&@*# | NULL | NULL | NULL  |
| 17 | zhang2     | dasda    | NULL | NULL | NULL  |
+----+------------+----------+------+------+-------+
3 rows in set (0.00 sec)
mysql> select * from user;
+----+------------+----------+------+------+-------+
| id | username   | password | age  | sex  | phone |
+----+------------+----------+------+------+-------+
|  1 | 张三       | 123456   | NULL | NULL | NULL  |
|  2 | 1=\《""=1  | weq*&@*# | NULL | NULL | NULL  |
| 17 | zhang2     | dasda    | NULL | NULL | NULL  |
+----+------------+----------+------+------+-------+
3 rows in set (0.00 sec)
```
#### 补充点
* 序列
```sql
/*创建*/
AUTO_INCREMENT 关键字实现自动增长

/*重置 注意不要有新的记录插入*/
mysql> ALTER TABLE insect DROP id;
mysql> ALTER TABLE insect
    -> ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
    -> ADD PRIMARY KEY (id);

/*设置开始值 auto_increment=100*/
CREATE TABLE user(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL, 
    date DATE NOT NULL,
    PRIMARY KEY (id),
)engine=innodb auto_increment=100 charset=utf8;
````

* 重复数据
```sql
1. 防止
/*PRIMARY KEY（主键） 或者 UNIQUE（唯一） 索引*/
CREATE TABLE person
(
   first_name CHAR(20) NOT NULL,
   last_name CHAR(20) NOT NULL,
   sex CHAR(10),
   PRIMARY KEY (last_name, first_name)/*双主键*/
);
/*插入时候有重复数据会报错*/

/*解决方式*/
INSERT IGNORE INTO语句:可以插入数据时进行校验，存在就忽略，没有就插入
REPLACE INTO：数据重复时，先删除再插入

2. 统计
/*统计重复的数据*/
SELECT COUNT(*) as num, last_name, first_name
FROM person
GROUP BY last_name, first_name
HAVING num > 1;

3. 过滤
/*过滤重复的值 distinct*/
SELECT DISTINCT last_name, first_name
FROM person;

4. 删除
/*删除重复数据步骤：三步*/
4.1 创建辅助表
CREATE TABLE tmp 
    SELECT last_name, first_name, sex 
    FROM person 
    GROUP BY (last_name, first_name, sex);
4.2 删除原始数据表
DROP TABLE person;
4.3 重命名辅助表为原始表表名
ALTER TABLE tmp RENAME TO person;
```


