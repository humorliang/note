### 基本数据结构
### 字符串（string）
```shell
#  设置 当key存在时SET会失败，或相反的，当key不存在时它只会成功。
#  SET KEY VALUE [EX seconds] [PX milliseconds] [NX|XX] 
# 
# EX seconds − 设置指定的到期时间(以秒为单位)。
# PX milliseconds - 设置指定的到期时间(以毫秒为单位)。
# NX - 仅在键不存在时设置键。
# XX - 只有在键已存在时才设置
#  
> set mykey somevalue
OK
# 获取
> get mykey
"somevalue"

# 原子递增　　INCR 命令将字符串值解析成整型，将其加一，最后将结果保存为新的字符串值
# 原子递减　　DECR 和 DECRBY
> set counter 100
OK
> incr counter
(integer) 101
> incr counter
(integer) 102
> incrby counter 50
(integer) 152

# 取（设置）多个值
# 使用MSET和MGET命令
> mset a 10 b 20 c 30
OK
> mget a b c
1) "10"
2) "20"
3) "30"

#  删除键值
# EXISTS命令返回1或0标识给定key的值是否存在，
# DEL命令可以删除key对应的值，DEL命令返回1或0标识值是被删除(值存在)或者没被删除(key对应的值不存在)。
> set mykey hello
OK
> exists mykey
(integer) 1
> del mykey
(integer) 1
> exists mykey
(integer) 0

# 键值存储类型
# TYPE命令可以返回key对应的值的存储类型
> set mykey v
OK
> type mykey
string
> del mykey
(integer) 1
> type mykey
none

# 设置有效时间
> set key some-value
OK
> expire key 5　　# 5秒后过期
(integer) 1
> get key (immediately)
"some-value"
> get key (after some time)
(nil)
> set key 100 ex 10
OK
> ttl key    # 剩余过期时间　　-1永远不过期
(integer) 9
```
### 列表（list）
```bash
# redis 的list是linked list 
# 一个list中有数百万个元素，在头部或尾部添加一个元素的操作，其时间复杂度也是常数级别的
# LPUSH 命令在十个元素的list头部添加新元素，和在千万元素list头部添加新元素的 速度相同
# 数组实现的list中利用索引访问元素的速度极快，而同样的操作在linked list实现的list上没有那么快
# 特点：能非常快的在很大的列表上添加元素

# 添加元素
# LPUSH 命令可向list的左边（头部）添加一个新元素
# RPUSH 命令可向list的右边（尾部）添加一个新元素
> rpush mylist a
(integer) 1
> rpush mylist b
(integer) 2
> lpush mylist first
(integer) 3
# > rpush mylist 0 1 2 3 # 添加多个元素
# (integer) 7


# 取范围元素
# LRANGE 命令可从list中取出一定范围的元素
# 这两个索引都可以为负来告知Redis从尾部开始计数，-1表示最后一个元素，-2表示list中的倒数第二个元素，以此类推。
> lrange mylist 0 -1
1) "first"
2) "a"
3) "b"
4) "0"
5) "1"
6) "2"
7) "3"
> lrange mylist 0 1　
1) "first"
2) "a"

# 删除元素
# lpop 左边删除
# rpop　右边删除
> rpop mylist
"3"
> rpop mylist
"2"
> lpop mylist
"first"
> rpop mylist # 没有元素为nil
(nil)
> del mylist # 删除列表
(integer) 1

# 阻塞操作
# 消费者可以在获取数据时指定如果数据不存在阻塞的时间，如果在时限内获得数据则立即返回，
# 如果超时还没有数据则返回null, 0表示一直阻塞
#  BRPOP 和 BLPOP 命令
#  RPOPLPUSH 和 BRPOPLPUSH。

# 通用操作
> exists mylist　# 是否存在
(integer) 0
> llen mylist　# list长度
(integer) 0
# 场景
# 可被用来实现聊天系统　还可以作为不同进程间传递消息的队列
# 在评级系统中，比如社会化新闻网站 reddit.com，你可以把每个新提交的链接添加到一个list，用LRANGE可简单的对结果分页。
# 在博客引擎实现中，你可为每篇日志设置一个list，在该list中推入博客评论
```
### 散列（hash）
```bash
# 　hash特别适合用于存储对象

# 设置获取hash
# HMSET 指令设置 hash 中的多个域
# HSET 指令设置 hash 中的单个域
# HGET 取回单个域。
# HMGET 和 HGET 类似，但返回一系列值
> hset user:10 name jack
(integer) 1
> hmset user:10 name mark  age 12 # 覆盖
OK
> hget user:10 name
"mark"
> hmget user:10 name age
1) "mark"
2) "12"
> hmset user:10 name mark2  age 12　
OK
> hmget user:10 name age　# 覆盖
1) "mark2"
2) "12"


# 常见命令
> hkeys user:10  #获取所有字段
1) "name"
2) "age"
> hexists user:10 city　# 判断字段是否存在
(integer) 0
> hsetnx user:10 city shanghai　# 字段不存在则设置
(integer) 1
> hvals user:10　# 获取所有字段值
1) "mark2"
2) "12"
3) "shanghai"
> hlen user:10　# 获取字段数量
(integer) 3
> hincrby user:10 age 10　# 字段值增加
(integer) 22
> hgetall user:10　# 获取字段所有信息
1) "name"
2) "mark2"
3) "age"
4) "22"
5) "city"
6) "shanghai"
```
### 集合（sets）
集合是string类型元素的集合,且不允许重复的成员
- 无序集合 
```bash
# Redis Set 是 String 的无序排列。SADD 指令把新的元素添加到 set 中。对 set 也可做一些其他的操作，
# 比如测试一个给定的元素是否存在，对不同 set 取交集，并集或差，等等 
# 设置添加，删除和测试成员的存在(恒定时间O(1)，而不考虑集合中包含的元素数量)
> sadd myset 1 2 3 4  # 添加
(integer) 4
> smembers myset　# 获取
1) "1"
2) "2"
3) "3"
4) "4"
> scard myset # 获取个数
(integer) 4
> sismember myset 4　#查询
(integer) 1
> sismember myset 10
(integer) 0

# 场景
# 文章打标签
> sadd posts:10:tags 1 7 6 
(integer) 3
> sadd tags:1:post 10
(integer) 1
> sadd tags:7:post 10
(integer) 1
> sadd tags:6:post 10
(integer) 1

# 返回共同拥有的成员
# 我们可能需要一个含有 1, ６ 和 7 标签的对象的列表。我们可以用 SINTER 命令来完成这件事
# 不满足则为空　返回一个共同拥有的成员
> sinter tags:1:post tags:7:post tags:6:post
1) "10"
> sinter tags:1:post tags:7:post tags:6:post
1) "10"
> sinter tags:1:post tags:7:post tags:6:post tags:8:post
(empty list or set)

# 随机元素
# SPOP 命令删除一个或多个随机元素，把它返回给客户端
# 随机获取一组扑克牌
> sadd deck C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 CJ CQ CK
(integer) 13
> spop deck 2　
1) "CK"
2) "C10

# 集合并集
> smembers deck
 1) "CJ"
 2) "C7"
 3) "C1"
 4) "C8"
 5) "C2"
 6) "CQ"
 7) "C4"
 8) "C9"
 9) "C3"
10) "C6"
11) "C5"
> sunionstore game:1:deck deck
(integer) 11

```
- 有序集合
```bash
# zadd key [NX|XX] [CH] [INCR] score member [score member ...]
# 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。

#　添加 
> zadd hacker 1994 "jack" 
(integer) 1
> zadd hacker 1988 "tom"
(integer) 1
> zadd hacker 1990 "mack"
(integer) 1
> zadd hacker 1990 "mack2"
(integer) 1

# 查询
> zrange hacker 0 -1
1) "tom"
2) "mack"
3) "mack2"
4) "jack"

# 反序
> zrevrange hacker 0 -1
1) "jack"
2) "mack2"
3) "mack"
4) "tom"

# 带有  scores
> zrange hacker 0 -1 withscores
1) "tom"
2) "1988"
3) "mack"
4) "1990"
5) "mack2"
6) "1990"
7) "jack"
8) "1994"

# 数据筛选
# zrangebyscore key min max [WITHSCORES] [LIMIT offset count]
> zrangebyscore hacker  1990 1994
1) "mack"
2) "mack2"
3) "jack"

# 删除成员
> zrem hacker tom
(integer) 1
> zremrangebyscore hacker 1990 1994 　# 删除符合条件成员
(integer) 3

# 常用指令
# zrank key member #获取指定成员索引
# zscore key member 返回有序集中，成员的分数值
```
### HyperLogLog 结构(Redis 2.8.9 版本)
```bash
# 基数统计的算法
# 什么是基数?
# 比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(不重复元素)为5。
# 基数估计就是在误差可接受的范围内，快速计算基数。
> pfadd mykey "go"　# 添加基数
(integer) 1
> pfadd mykey "java"
(integer) 1
> pfadd mykey "mysql"
(integer) 1
> pfadd mykey "mysql"
(integer) 0
> pfcount mykey　　　# 基数估算值
(integer) 3
> pfadd mykey2 "java"
(integer) 1
> pfadd mykey2 "web"
(integer) 1
> pfmerge newkey  mykey mykey2 　# 多个基数合并
OK
> pfcount newkey
(integer) 4
```
### 地理空间
```bash
# 有效的经度从-180度到180度。
# 有效的纬度从-85.05112878度到85.05112878度。
> geoadd sicily  10 20 "step1" 20 30 "step2"  #定义两点坐标
(integer) 1
> geodist sicily step1 step2　# 坐标距离
"1499522.1215"

```
### 磁盘持久化
```bash
# 两种方式
# １. RDB持久化方式能够在指定的时间间隔能对你的数据进行快照存储.
# ２. AOF持久化方式记录每次对服务器写的操作,当服务器重启的时候会重新执行这些命令来恢复原始的数据,
#    AOF命令以redis协议追加保存每次写的操作到文件末尾.Redis还能对AOF文件进行后台重写,使得AOF文件的体积不至于过大.

# 快照
# Redis 将数据库快照保存在名字为 dump.rdb的二进制文件中。
# 你可以对 Redis 进行设置， 让它在“ N 秒内数据集至少有 M 个改动”这一条件被满足时， 自动保存一次数据集。
# 你也可以通过调用 SAVE或者 BGSAVE ， 手动让 Redis 进行数据集保存操作。

# 配置
# 只追加操作的文件（Append-only file，AOF）
> appendonly yes
# 每当 Redis 执行一个改变数据集的命令时（比如 SET）， 这个命令就会被追加到 AOF 文件的末尾
```
### 数据备份和恢复
- 备份
```bash
> SAVE # redis 安装目录中创建dump.rdb文件
OK
> bgsave #　备份在后台进行
Background saving started
> config get dir # 获取安装目录
1) "dir"
2) "/data"
```
- 恢复
```
需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可
```
### 发布订阅
```bash
> subscribe redischat  # 订阅一个频道
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "redischat"
3) (integer) 1

# 再启动一个客户端
> publish redischat "this is msg"  #　发布一个消息　不存在则返回　０　成功为　１
(integer) 0
127.0.0.1:6379> publish redischat "this is msg"　
(integer) 1
# 接收端
> subscribe redischat
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "redischat"
3) (integer) 1
1) "message"
2) "redischat"
3) "this is msg"
```
### 服务器
```bash
# redis　服务信息
> info
# Server
redis_version:5.0.4
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:fb75b7389a142ac3
redis_mode:standalone
os:Linux 4.18.0-18-generic x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:6.3.0
process_id:1
run_id:f3be84feb461996139e316453a477595e550eabf
tcp_port:6379
uptime_in_seconds:18247
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:14306454
executable:/data/redis-server
config_file:

# Clients
connected_clients:3
client_recent_max_input_buffer:2
client_recent_max_output_buffer:0
blocked_clients:0

# Memory
used_memory:898384
used_memory_human:877.33K
used_memory_rss:6402048
used_memory_rss_human:6.11M
used_memory_peak:898384
used_memory_peak_human:877.33K
used_memory_peak_perc:100.10%
used_memory_overhead:875438
used_memory_startup:790992
used_memory_dataset:22946
used_memory_dataset_perc:21.37%
allocator_allocated:1356408
allocator_active:1642496
allocator_resident:10403840
total_system_memory:8268042240
total_system_memory_human:7.70G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.21
allocator_frag_bytes:286088
allocator_rss_ratio:6.33
allocator_rss_bytes:8761344
rss_overhead_ratio:0.62
rss_overhead_bytes:-4001792
mem_fragmentation_ratio:7.48
mem_fragmentation_bytes:5545664
mem_not_counted_for_evict:260
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:83538
mem_aof_buffer:260
mem_allocator:jemalloc-5.1.0
active_defrag_running:0
lazyfree_pending_objects:0

# Persistence
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1557809096
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:565248
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
aof_current_size:1903
aof_base_size:0
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0

# Stats
total_connections_received:8
total_commands_processed:98
instantaneous_ops_per_sec:0
total_net_input_bytes:4280
total_net_output_bytes:70846
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
evicted_keys:0
keyspace_hits:41
keyspace_misses:5
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:444
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0

# Replication
role:master
connected_slaves:0
master_replid:13c2489da0b55e56ff99f7f2794f5ec4f4750bf9
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:21.297019
used_cpu_user:22.253124
used_cpu_sys_children:0.005200
used_cpu_user_children:0.003641

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=13,expires=0,avg_ttl=0
```
### 事务
```bash
127.0.0.1:6379> multi   # 开启事务
OK
127.0.0.1:6379> set book  "Go杰出教程"　　# 执行操作
QUEUED
127.0.0.1:6379> sadd tag "go" "web"
QUEUED
127.0.0.1:6379> smembers tag
QUEUED
127.0.0.1:6379> exec　　# 提交事务
1) OK
2) (integer) 0
3) 1) "web"
   2) "go"
127.0.0.1:6379> multi
OK
127.0.0.1:6379> discard # 取消事务
OK
```
### 其他
```bash
# 查看所有配置信息
> config get *

# lua脚本
# 脚本使用 Lua 解释器来执行脚本
```