### kafka笔记
#### 名词解释
- `producer`：生产者，就是它来生产“车辆”的。
- `consumer`：消费者，产出的“车辆”它来消费。
- `topic`：你把它理解为标签，生产者每生产出来一个车辆就贴上一个标签（topic），消费者可不是谁生产的“车辆”都能买的，这样不同的生产者生产出来的“车辆”，消费者就可以选择性的“买”了。
- `broker`：就是车辆管理仓库了。
> 从技术角度，topic标签实际就是队列，生产者把所有“车辆（消息）”都放到对应的队列里了，消费者到指定的队列里取。
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