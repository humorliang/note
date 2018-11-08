## MySQL基础知识
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
### 数据类型
#### 数值类型

类型	|  大小	|  范围（有符号）|	范围（无符号）|	用途|
---|---|---|---|---|---
TINYINT	|1 字节|(-128，127),(0，255)|小整数值|
SMALLINT|2 字节	|(-32 768，32 767),(0，65 535)	|大整数值|
MEDIUMINT|3 字节|(-8 388 608，8 388 607),(0，16 777 215)|	大整数值|
INT或INTEGER|4 字节|(-2 147 483 648，2 147 483 647)	(0，4 294 967 295)|	大整数值|
BIGINT|	8 字节|(-9 233 372 036 854 775 808，9 223 372 036 854 775 807),(0，18 446 744 073 709 551 615)|极大整数值|
FLOAT|4 字节|(-3.402 823 466 E+38，-1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38)	0，(1.175 494 351 E-38，3.402 823 466 E+38)|单精度|浮点数值|
DOUBLE|	8 字节|	(-1.797 693 134 862 315 7 E+308，-2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)	0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)|双精度|浮点数值|
DECIMAL	|对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2|	依赖于M和D的值|	依赖于M和D的值|小数值|
#### 日期和时间类型
类型|	大小(字节)	|范围|	格式|	用途|
---|---|---|---|---|---
DATE	|3  |1000-01-01/9999-12-31	|YYYY-MM-DD|	日期值|
TIME	|3|'-838:59:59'/'838:59:59'	|HH:MM:SS	|时间值或持续时间|
YEAR	|1|1901/2155|	YYYY|	年份值|
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
/*示例*/
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
DROP TABLE table_name ;
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
#### 