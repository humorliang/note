### kafka笔记
#### 名词解释
- `producer`：生产者，就是它来生产“车辆”的。
- `consumer`：消费者，产出的“车辆”它来消费。
- `topic`：你把它理解为标签，生产者每生产出来一个车辆就贴上一个标签（topic），消费者可不是谁生产的“车辆”都能买的，这样不同的生产者生产出来的“车辆”，消费者就可以选择性的“买”了。
- `broker`：就是车辆管理仓库了。
> 从技术角度，topic标签实际就是队列，生产者把所有“车辆（消息）”都放到对应的队列里了，消费者到指定的队列里取。
#### 常见名词查询
##### kafka中涉及的名词：
- 消息记录(record): 
    由一个key，一个value和一个时间戳构成，消息最终存储在主题下的分区中, 记录在生产者中称为生产者记录(ProducerRecord), 在消费者中称为消费者记录(ConsumerRecord)，Kafka集群保持所有的消息，直到它们过期， 无论消息是否被消费了，在一个可配置的时间段内，Kafka集群保留所有发布的消息，不管这些消息有没有被消费。比如，如果消息的保存策略被设置为2天，那么在一个消息被发布的两天时间内，它都是可以被消费的。之后它将被丢弃以释放空间。Kafka的性能是和数据量无关的常量级的，所以保留太多的数据并不是问题。
- 生产者(producer): 
    生产者用于发布(send)消息
- 消费者(consumer): 
    消费者用于订阅(subscribe)消息
- 消费者组(consumer group): 
    相同的group.id的消费者将视为同一个消费者组, 每个消费者都需要设置一个组id, 每条消息只能被 consumer group 中的一个 Consumer 消费,但可以被多个 consumer group 消费
- 主题(topic): 
    消息的一种逻辑分组，用于对消息分门别类，每一类消息称之为一个主题，相同主题的消息放在一个队列中
- 分区(partition):
     消息的一种物理分组， 一个主题被拆成多个分区，每一个分区就是一个顺序的、不可变的消息队列，并且可以持续添加，分区中的每个消息都被分配了一个唯一的id，称之为偏移量(offset),在每个分区中偏移量都是唯一的。每个分区对应一个逻辑log，有多个segment组成。
- 偏移量(offset): 
    分区中的每个消息都一个一个唯一id，称之为偏移量，它代表已经消费的位置。可以自动或者手动提交偏移量(即自动或者手动控制一条消息是否已经被成功消费)
- 代理(broker): 
    一台kafka服务器称之为一个broker
- 副本(replica)：
    副本只是一个分区(partition)的备份。 副本从不读取或写入数据。 它们用于防止数据丢失。
- 领导者(leader)：
    Leader 是负责给定分区的所有读取和写入的节点。 每个分区都有一个服务器充当Leader， producer 和 consumer 只跟 leader 交互
- 追随者(follower)：
    跟随领导者指令的节点被称为Follower。 如果领导失败，一个追随者将自动成为新的领导者。 跟随者作为正常消费者，拉取消息并更新其自己的数据存储。replica 中的一个角色，从 leader 中复制数据。
- zookeeper：
    Kafka代理是无状态的，所以他们使用ZooKeeper来维护它们的集群状态。ZooKeeper用于管理和协调Kafka代理
##### kafka功能

- 发布订阅：
    生产者(producer)生产消息(数据流), 将消息发送到到kafka指定的主题队列(topic)中，也可以发送到topic中的指定分区(partition)中，消费者(consumer)从kafka的指定队列中获取消息，然后来处理消息。
- 流处理(Stream Process): 
    将输入topic转换数据流到输出topic
- 连接器(Connector) : 
    将数据从应用程序(源系统)中导入到kafka，或者从kafka导出数据到应用程序(宿主系统sink system), 例如：将文件中的数据导入到kafka，从kafka中将数据导出到文件中
##### kafka中的消息模型
队列：同名的消费者组员瓜分消息
发布订阅：广播消息给多个消费者组(不同名)

#### 学习考验
```
    1. kafka节点之间如何复制备份的？
    2. kafka消息是否会丢失？为什么？
    3. kafka最合理的配置是什么？
    4. kafka的leader选举机制是什么？
    5. kafka对硬件的配置有什么要求？
    6. kafka的消息保证有几种方式？
```
#### 常用命令
##### 管理
```bash
## 创建主题（4个分区，2个副本）
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 4 --topic test
```
##### 查询
```bash
## 查询集群描述
bin/kafka-topics.sh --describe --zookeeper 

## 消费者列表查询
bin/kafka-topics.sh --zookeeper 127.0.0.1:2181 --list

## 新消费者列表查询（支持0.9版本+）
bin/kafka-consumer-groups.sh --new-consumer --bootstrap-server localhost:9092 --list

## 显示某个消费组的消费详情（仅支持offset存储在zookeeper上的）
bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --zookeeper localhost:2181 --group test

## 显示某个消费组的消费详情（支持0.9版本+）
bin/kafka-consumer-groups.sh --new-consumer --bootstrap-server localhost:9092 --describe --group test-consumer-group
```
##### 发送和消费
```bash
## 生产者
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test

## 消费者
bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test

## 新生产者（支持0.9版本+）
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test --producer.config config/producer.properties

## 新消费者（支持0.9版本+）
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --new-consumer --from-beginning --consumer.config config/consumer.properties

## 高级点的用法
bin/kafka-simple-consumer-shell.sh --brist localhost:9092 --topic test --partition 0 --offset 1234  --max-messages 10

```
##### 平衡leader
```bash
bin/kafka-preferred-replica-election.sh --zookeeper zk_host:port/chroot
```
##### kafka自带压测命令
```bash
bin/kafka-producer-perf-test.sh --topic test --num-records 100 --record-size 1 --throughput 100  --producer-props bootstrap.servers=localhost:9092
```
##### 管理
```bash
## 创建主题（4个分区，2个副本）
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 4 --topic test
```

### kafka的安装
#### mac版安装
```bash
brew install kafka
```
##### 安装位置
```
安装kafka是需要依赖于zookeeper的，所以安装kafka的时候也会包含zookeeper:
    它是分布式系统中的协调系统，可提供的服务主要有：配置服务、名字服务、分布式同步、组服务等。
kafka的安装目录：/usr/local/Cellar/kafka 
kafka的配置文件目录：/usr/local/etc/kafka 
kafka服务的配置文件：/usr/local/etc/kafka/server.properties 
zookeeper配置文件： /usr/local/etc/kafka/zookeeper.properties
```
##### 服务启动
```bash
# 切换到kafka的脚本目录
cd /usr/local/Cellar/kafka/2.1.0/bin
# 1.运行zookeeper   载入配置文件
zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties
# 2.运行kafka 载入配置文件
kafka-server-start /usr/local/etc/kafka/server.properties
# 3.创建topic
kafka-topics --create 
    --zookeeper localhost:2181  # 
    --partitions 1  # 创建分区
    --replication-factor 1 # 创建备份分区
    --topic test # 创建主题
# 查看topic列表
kafka-topics --list --zookeeper localhost:2181
# 查看topic详细信息
kafka-topics --describe --zookeeper localhost:2181 --topic test

#Topic:test	PartitionCount:1	ReplicationFactor:1	
# Configs:
#	Topic: test	Partition: 0	Leader: 0	Replicas: 0	Isr: 0

# 4. 生产消息
kafka-console-producer  --broker-list localhost:909-topic test 

# 5. 消费消息
kafka-console-consumer --bootstrap-server localhost:9092 --topic test --from-beginning
```
#### go操作kafka
```go 
/* kafka操作库 */
go get github.com/Shopify/sarama
/* kakfa cluster群管理 */
go get github.com/bsm/sarama-cluster
```