### 运行goim2.0版
- goim系统依赖项
1. 系统组件
```Dockerfile
# 编写dockerfile 文件
version: '3'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
    hostname: zookeeper
  kafka:
    image: wurstmeister/kafka
    command: [start-kafka.sh]
    ports:
      - "9092:9092"
    hostname: kafka
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 192.168.45.11 # docker-machine ip
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_PORT: 9092
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - "zookeeper"
```
1.1 测试kafka 是否正常
```sh
docker exec -it goim_kafka_1 /bin/bash
# 创建主题
 $KAFKA_HOME/bin/kafka-topics.sh --create --topic test --zookeeper goim_zookeeper_1:2181 --replication-factor 1 --partitions 1
#  查看列表
$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper goim_zookeeper_1:2181
# 发送消息
$KAFKA_HOME/bin/kafka-console-producer.sh --topic=test --broker-list goim_kafka_1:9092
# 接受消息
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server goim_kafka_1:9092 --from-beginning --topic test
```
２. 服务管理
```sh
# 使用discovery 管理服务
git clone https://github.com/bilibili/discovery.git
# 开启服务
cd discovery/cmd/discovery
go build 
nohup ./discovery -conf discovery-example.toml  -log.stdout 2>error.log 1> discovery.log &
```
- goim 逻辑梳理
1. 数据流转
```sh
1. http 接口向logic发送数据
2. logic 从redis中取出会话数据，以protobuf序列化数据　发送给MQ 
3. job从MQ中订阅数据，取出

```