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
```go
panic: kafka server: Offset's topic has not yet been created.
在docker-compose.yml 的配置文件中　KAFKA_ADVERTISED_HOST_NAME: 192.168.45.11 # docker-machine ip
确保IP地址为本机地址．
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
- Ring Buffer理解
环形缓冲区：
```
含义：
  环形缓冲区(ring buffer), 又称圆形队列（circular queue), 循环缓冲区(cyclic buffer), 圆形缓冲区(circular buffer)。
解释：
  它适合于实现明确大小的FIFO缓冲区，通常由一个数组实现，start和end两个索引来表示数据的开始和结束，length表示当前元素个数，capacity表示缓冲区容量。当有元素删除或插入时只需要移动start和end，其他元素不需要移动存储位置。
工作过程：
  缓冲区数据结构为一个capacity长度的数组，初始start、end、length为0，有新元素插入时，插入到end索引的位置，end后移，length增加，当end在超过数组的最大索引时，end为0，当length等于capacity时表示缓冲区满.读取元素时，从start开始读取，start增加，length减少，当start超过数组索引最大值时，start为0,当length为0是表示已经全部读出
```
示例：
```go
package ringbuffer

import "errors"

var (
	ErrRingEmpty = errors.New("Ring is empty! ")
	ErrRingFull  = errors.New("Ring is Full! ")
)

type Proto struct {
}

type RingBuf struct {
	rp   int
	wp   int
	mask int
	num  int
	data []Proto
}

func Init(num int) *RingBuf {
	r := new(RingBuf)
	r.init(num)
	return r
}

func (r *RingBuf) init(num int) {
	//确保num为2n
	if num&(num-1) != 0 {
		for num&(num-1) != 0 {
			num &= (num - 1)
		}
		//左移
		num = num << 1
	}
	//初始化为零值
	r.data = make([]Proto, num)
	r.num = num
	//用于取余计算
	r.mask = r.num - 1
}

//Get 读取一块buf item
func (r *RingBuf) Get() (proto *Proto, err error) {
	if r.rp == r.wp {
		return nil, ErrRingEmpty
	}
	proto = &r.data[r.rp&r.mask]
	return
}

//GetAdv 移动游标位置
func (r *RingBuf) GetAdv() {
	r.rp++
}

//Set　获取一块buf item 进行写
func (r *RingBuf) Set() (proto *Proto, err error) {
	if r.wp-r.rp >= r.num {
		return nil, ErrRingFull
	}
	proto = &r.data[r.wp&r.mask]
	return
}

func (r *RingBuf) SetAdv() {
	r.wp++
}
```
- 按位取余操作
```go
%运算: a%b （此公式只适用b=2n)
由于我们知道位运算比较高效，在某些情况下，当b为2的n次方时，有如下替换公式：
a % b = a & (b-1)(b=2n)
即：a % 2n = a & (2n-1)

例如：14%8，取余数，相当于取出低位，而余数最大为7，14二进制为1110，8的二进制1000，8-1 = 7的二进制为0111，由于现在低位全为1，让其跟14做&运算，正好取出的是其低位上的余数。1110&0111=110即6=14%8；（此公式只适用b=2n，是因为可以保证b始终只有最高位为1，其他二进制位全部为0，减去1，之后，可以把高位1消除，其他位都为1，而与1做&运算，会保留原来的数。）
```
- goim 的gRPC服务重启导致的连接丢失
```go
// 出现的错误
error: read tcp 127.0.0.1:45454->127.0.0.1:3101: read: connection reset by peer
// 解决方法
1. 当服务重启后过一段时间进行请求.
2. 由于服务没有完全注册成功,导致服务之间不可用,导致连接重置.
```
### goim protobuf定义
- comet服务的 proto 定义
```go
// Ping Service 
rpc Ping (Empty) returns (Empty);
// Close Service 
rpc Close (Empty) returns (Empty);
//PushMsg push by key or mid
rpc PushMsg (PushMsgReq) returns (PushMsgReply);
// Broadcast send to every enrity
rpc Broadcast (BroadcastReq) returns (BroadcastReply);
// BroadcastRoom broadcast to one room
rpc BroadcastRoom (BroadcastRoomReq) returns (BroadcastRoomReply);
// Rooms get all rooms
rpc Rooms (RoomsReq) returns (RoomsReply);
```

- logic服务　proto 定义
```go
// Ping Service 
rpc Ping (PingReq) returns (PingReply);
// Close Service 
rpc Close (CloseReq) returns (CloseReply);
// Connect
rpc Connect (ConnectReq) returns (ConnectReply);
// Disconnect
rpc Disconnect (DisconnectReq) returns (DisconnectReply);
// Heartbeat
rpc Heartbeat (HeartbeatReq) returns (HeartbeatReply);
// RenewOnline
rpc RenewOnline (OnlineReq) returns (OnlineReply);
// Receive
rpc Receive (ReceiveReq) returns (ReceiveReply);
//ServerList
rpc Nodes (NodesReq) returns (NodesReply);
//last message
rpc LastMsg (LastMsgReq) returns (LastMsgReply);
```
### goim - comet服务
```go
// cmd/comet/main.go
1. 服务注册到bilibil discovery服务注册中心 初始化server,建立logic.rpcClient
// internal/comet/server_tcp.go
2. 建立tcp,websocket服务监听(tcp ,websocket init)
3.1. eg: 具体tcp　服务 AcceptTCP()　设置相关连接的基本设置。
3.2. 其中所需的数据结构：
// internal/comet/round.go　读写缓存buffio  定时器timer (对定时器,和系统buf进行复用)
// internal/comet/channel.go 管理相关连接(Room Ring,双链表Channel,writer,reader,watchOps)
// 管理连接对象的房间信息，读写信息，订阅的消息类型
// internal/comet/bucket.go　整个comet服务 对象的管理中心
// (map[string]*Channel,map[string]*Room,[]chan *grpc.BroadcastRoomReq)
```
