### go Interview
#### requirment
GO
```

```
MYSQL
```
1. 数据库操作：
创建
create database 数据库名;
删除
drop database <数据库名>;
选择
use 数据库名;
2. 数据类型：
数值类型 
日期和时间类型
字符串类型
3. 表操作
创建表：
CREATE TABLE table_name (column_name column_type);
修改表：
ALTER TABLE testalter_tbl  DROP i; //删除字段i
ALTER TABLE testalter_tbl ADD i INT; //添加字段i
ALTER TABLE testalter_tbl MODIFY c CHAR(10);//修改表字段
删除表：
DROP TABLE table_name ;
4. 数据操作
插入数据：
INSERT INTO table_name ( field1, field2,...fieldN )
                       VALUES
                       ( value1, value2,...valueN );
查询数据：
SELECT column_name,column_name
FROM table_name
[WHERE Clause]
[LIMIT N][ OFFSET M]
更新数据：
UPDATE table_name SET field1=new-value1, field2=new-value2
[WHERE Clause]
删除数据：
DELETE FROM table_name [WHERE Clause]

5. 索引
CREATE INDEX indexName ON mytable(username(length)); 
ALTER table tableName ADD INDEX indexName(columnName)

6.常见子句
- link
LIKE condition1 [AND [OR]] filed2 = 'somevalue'
- union
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions]
UNION [ALL | DISTINCT]
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions];
- 排序
ORDER BY field1, [field2...] [ASC [DESC]]
- GROUP BY 语法
SELECT column_name, function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name;
- 连接
INNER JOIN（内连接,或等值连接）：获取两个表中字段匹配关系的记录。
LEFT JOIN（左连接）：获取左表所有记录，即使右表没有对应匹配的记录。
RIGHT JOIN（右连接）： 与 LEFT JOIN 相反，用于获取右表所有记录，即使左表没有对应匹配的记录。

7.数据库实战
主服务器：
    开启二进制日志
    配置唯一的server-id
    获得master二进制日志文件名及位置
    创建一个用于slave和master通信的用户账号
从服务器：
    配置唯一的server-id
    使用master分配的用户账号读取master二进制日志
    启用slave服务

主数据库master修改：
1.修改mysql配置
找到主数据库的配置文件my.cnf(或者my.ini)，我的在/etc/mysql/my.cnf,在[mysqld]部分插入如下两行：
[mysqld]
log-bin=mysql-bin #开启二进制日志
server-id=1 #设置server-id

2.重启mysql，创建用于同步的用户账号
mysql> CREATE USER 'repl'@'123.57.44.85' IDENTIFIED BY 'slavepass';#创建用户  从数据库IP
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'123.57.44.85';#分配权限
mysql>flush privileges;   #刷新权限

3.查看master状态
SHOW MASTER STATUS;

从服务器slave修改：
1.修改mysql配置
同样找到my.cnf配置文件，添加server-id
[mysqld]
server-id=2 #设置server-id，必须唯一

2.重启mysql，打开mysql会话，执行同步SQL语句(需要主服务器主机名，登陆凭据，二进制文件的名称和位置)：
mysql> CHANGE MASTER TO
    ->     MASTER_HOST='182.92.172.80',
    ->     MASTER_USER='rep1',
    ->     MASTER_PASSWORD='slavepass',
    ->     MASTER_LOG_FILE='mysql-bin.000003',
    ->     MASTER_LOG_POS=73;

3.启动slave同步进程：
mysql>start slave;

4.查看slave状态：
复制代码
mysql> show slave status\G;

```
docker
```
Docker 容器使用
~# docker     //查看命令
~# docker stats --help  //命令帮助
// 运行一个web应用
~# docker pull training/webapp  # 载入镜像
~# docker run -d -P training/webapp python app.py
参数说明：
    -d:让容器在后台运行。
    -P:将容器内部使用的网络端口映射到我们使用的主机上。
~# docker ps //查看运行容器
参数：
    -l 最后一次启动的容器
~# docker logs -f bf08b7f2cd89  //查看容器内的标准输出   tail -f 
~$ docker top wizardly_chandrasekhar //docker top 来查看容器内部运行的进程
~$ docker stop wizardly_chandrasekhar //停止容器
~$ docker start wizardly_chandrasekhar //启动容器
~$ docker rm wizardly_chandrasekhar //删除容器

Docker 镜像使用
~$ docker images  //镜像列表
~$ docker run -t -i ubuntu:15.10 /bin/bash  //运行一个镜像并打开控制台
~$ docker pull ubuntu:13.10 //获取一个镜像
~$  docker search httpd //查找镜像
~$ docker commit -m="has update" -a="runoob" e218edb10161 runoob/ubuntu:v2  //更新提交容器镜像
参数说明：
    -m:提交的描述信息
    -a:指定镜像作者
    e218edb10161：容器ID
    runoob/ubuntu:v2:指定要创建的目标镜像名
构建镜像：
docker build 命令--> Dockerfile 文件
dockerfile文件内容：
    FROM    centos:6.7   //指定镜像源
    MAINTAINER      Fisher "fisher@sudops.com"
    // RUN  docker内部运行命令
    RUN     /bin/echo 'root:123456' |chpasswd  
    RUN     useradd runoob
    RUN     /bin/echo 'runoob:123456' |chpasswd
    RUN     /bin/echo -e "LANG=\"en_US.UTF-8\"" >/etc/default/local
    EXPOSE  22
    EXPOSE  80
    CMD     /usr/sbin/sshd -D
~$ docker build -t test/centos:6.7 .  // 构建镜像
参数说明：
    -t ：指定要创建的目标镜像名
    . ：Dockerfile 文件所在目录，可以指定Dockerfile 的绝对路径
~$ docker tag 860c279d2fec test/centos:dev //设置镜像标签

Docker 容器连接
~$ docker run -d -P training/webapp python app.py
~$ docker run -d -p 5000:5000 training/webapp python app.py
参数说明：
    -P（大） :是容器内部端口随机映射到主机的高端口。
    -p（小）: 是容器内部端口绑定到指定的主机端口。
~$ docker run -d -p 127.0.0.1:5000:5000/udp training/webapp python app.py // UDP端口

~$ docker port adoring_stonebraker 5000 // docker port 命令可以让我们快捷地查看端口的绑定情况。

~$  docker run -d -P --name demo training/webapp python app.py // 容器命名

mysql容器：
$ docker run -p 3306:3306 --name mymysql 
    -v $PWD/conf:/etc/mysql/conf.d 
    -v $PWD/logs:/logs 
    -v $PWD/data:/var/lib/mysql 
    -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.6 
说明：
    -p 3306:3306：将容器的 3306 端口映射到主机的 3306 端口。
    -v -v $PWD/conf:/etc/mysql/conf.d：将主机当前目录下的 conf/my.cnf 挂载到容器的 /etc/mysql/my.cnf。
    -v $PWD/logs:/logs：将主机当前目录下的 logs 目录挂载到容器的 /logs。
    -v $PWD/data:/var/lib/mysql ：将主机当前目录下的data目录挂载到容器的 /var/lib/mysql 。
    -e MYSQL_ROOT_PASSWORD=123456：初始化 root 用户的密码。
```
Nginx
```
...              #全局块

events {         #events块
   ...
}
http      #http块
{
    ...   #http全局块
    server        #server块
    { 
        ...       #server全局块
        location [PATTERN]   #location块
        {
            ...
        }
        location [PATTERN] 
        {
            ...
        }
    }
    server
    {
      ...
    }
    ...     #http全局块
}
1、全局块：配置影响nginx全局的指令。一般有运行nginx服务器的用户组，nginx进程pid存放路径，日志存放路径，配置文件引入，允许生成worker process数等。

2、events块：配置影响nginx服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网路连接，开启多个网络连接序列化等。

3、http块：可以嵌套多个server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type定义，日志自定义，是否使用sendfile传输文件，连接超时时间，单连接请求数等。

4、server块：配置虚拟主机的相关参数，一个http中可以有多个server。

5、location块：配置请求的路由，以及各种页面的处理情况。
```
RPC
```

```
protobuf
```

```
Redis
```redis
Redis支持五种数据类型：
string（字符串）:
1	SET key value 
设置指定 key 的值
2	GET key 
获取指定 key 的值。
3	GETRANGE key start end 
返回 key 中字符串值的子字符
4	GETSET key value
将给定 key 的值设为 value ，并返回 key 的旧值(old value)。
5	GETBIT key offset
对 key 所储存的字符串值，获取指定偏移量上的位(bit)。
6	MGET key1 [key2..]
获取所有(一个或多个)给定 key 的值。
7	SETBIT key offset value
对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)。
8	SETEX key seconds value
将值 value 关联到 key ，并将 key 的过期时间设为 seconds (以秒为单位)。
9	SETNX key value
只有在 key 不存在时设置 key 的值。
10	SETRANGE key offset value
用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始。
11	STRLEN key
返回 key 所储存的字符串值的长度。
12	MSET key value [key value ...]
同时设置一个或多个 key-value 对。
13	MSETNX key value [key value ...] 
同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。
14	PSETEX key milliseconds value
这个命令和 SETEX 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 SETEX 命令那样，以秒为单位。
15	INCR key
将 key 中储存的数字值增一。
16	INCRBY key increment
将 key 所储存的值加上给定的增量值（increment） 。
17	INCRBYFLOAT key increment
将 key 所储存的值加上给定的浮点增量值（increment） 。
18	DECR key
将 key 中储存的数字值减一。
19	DECRBY key decrement
key 所储存的值减去给定的减量值（decrement） 。
20	APPEND key value
如果 key 已经存在并且是一个字符串， APPEND 命令将指定的 value 追加到该 key 原来值（value）的末尾。
```
hash（哈希）:
```redis
1	HDEL key field1 [field2] 
删除一个或多个哈希表字段
2	HEXISTS key field 
查看哈希表 key 中，指定的字段是否存在。
3	HGET key field 
获取存储在哈希表中指定字段的值。
4	HGETALL key 
获取在哈希表中指定 key 的所有字段和值
5	HINCRBY key field increment 
为哈希表 key 中的指定字段的整数值加上增量 increment 。
6	HINCRBYFLOAT key field increment 
为哈希表 key 中的指定字段的浮点数值加上增量 increment 。
7	HKEYS key 
获取所有哈希表中的字段
8	HLEN key 
获取哈希表中字段的数量
9	HMGET key field1 [field2] 
获取所有给定字段的值
10	HMSET key field1 value1 [field2 value2 ] 
同时将多个 field-value (域-值)对设置到哈希表 key 中。
11	HSET key field value 
将哈希表 key 中的字段 field 的值设为 value 。
12	HSETNX key field value 
只有在字段 field 不存在时，设置哈希表字段的值。
13	HVALS key 
获取哈希表中所有值
14	HSCAN key cursor [MATCH pattern] [COUNT count] 
迭代哈希表中的键值对。
```
list（列表）:
```redis
1	BLPOP key1 [key2 ] timeout 
移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
2	BRPOP key1 [key2 ] timeout 
移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
3	BRPOPLPUSH source destination timeout 
从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
4	LINDEX key index 
通过索引获取列表中的元素
5	LINSERT key BEFORE|AFTER pivot value 
在列表的元素前或者后插入元素
6	LLEN key 
获取列表长度
7	LPOP key 
移出并获取列表的第一个元素
8	LPUSH key value1 [value2] 
将一个或多个值插入到列表头部
9	LPUSHX key value 
将一个值插入到已存在的列表头部
10	LRANGE key start stop 
获取列表指定范围内的元素
11	LREM key count value 
移除列表元素
12	LSET key index value 
通过索引设置列表元素的值
13	LTRIM key start stop 
对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除。
14	RPOP key 
移除列表的最后一个元素，返回值为移除的元素。
15	RPOPLPUSH source destination 
移除列表的最后一个元素，并将该元素添加到另一个列表并返回
16	RPUSH key value1 [value2] 
在列表中添加一个或多个值
17	RPUSHX key value 
为已存在的列表添加值
```
set（集合）:
```redis
1	SADD key member1 [member2] 
向集合添加一个或多个成员
2	SCARD key 
获取集合的成员数
3	SDIFF key1 [key2] 
返回给定所有集合的差集
4	SDIFFSTORE destination key1 [key2] 
返回给定所有集合的差集并存储在 destination 中
5	SINTER key1 [key2] 
返回给定所有集合的交集
6	SINTERSTORE destination key1 [key2] 
返回给定所有集合的交集并存储在 destination 中
7	SISMEMBER key member 
判断 member 元素是否是集合 key 的成员
8	SMEMBERS key 
返回集合中的所有成员
9	SMOVE source destination member 
将 member 元素从 source 集合移动到 destination 集合
10	SPOP key 
移除并返回集合中的一个随机元素
11	SRANDMEMBER key [count] 
返回集合中一个或多个随机数
12	SREM key member1 [member2] 
移除集合中一个或多个成员
13	SUNION key1 [key2] 
返回所有给定集合的并集
14	SUNIONSTORE destination key1 [key2] 
所有给定集合的并集存储在 destination 集合中
15	SSCAN key cursor [MATCH pattern] [COUNT count] 
迭代集合中的元素
```
zset(sorted set：有序集合)
```

```
Kafka
```

```
JWT
```

```
Python
```

```
flask
```


```
flask组件
```


```
