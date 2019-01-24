#### NSQ文档
> 官方文档：https://nsq.io/overview/quick_start.html
> 中文文档：http://wiki.jikexueyuan.com/project/nsq-guide/nsqlookupd.html
#### NSQ理解
1. 整个Nsq服务包含三个主要部分
##### nsqlookupd（中心管理服务）
> nsqlookupd是守护进程负责管理拓扑信息(结构信息)。
```
有两个接口：TCP 接口，nsqd 用它来广播。HTTP 接口，客户端用它来发现和管理。


客户端通过查询 nsqlookupd 来发现指定话题（topic）的生产者，并且 nsqd 节点广播话题（topic）和通道（channel）信息
简单的说nsqlookupd就是 中心管理服务，它使用tcp(默认端口4160)管理nsqd服务，使用http(默认端口4161)管理nsqadmin服务。
同时为客户端提供查询功能

nsqlookupd具有以下功能或特性:
    1. 唯一性，在一个Nsq服务中只有一个nsqlookupd服务。当然也可以在集群中部署多个nsqlookupd，但它们之间是没有关联的
    2. 去中心化，即使nsqlookupd崩溃，也会不影响正在运行的nsqd服务
    3. 充当nsqd和naqadmin信息交互的中间件
    4. 提供一个http查询服务，给客户端定时更新nsqd的地址目录 
```
##### nsqadmin(web界面)
> 是一套 WEB UI，用来汇集集群的实时统计，并执行不同的管理任务
```
    1. 提供一个对topic和channel统一管理的操作界面以及各种实时监控数据的展示，界面设计的很简洁，操作也很简单
    2. 展示所有message的数量
    3. 能够在后台创建topic和channel，这个应该不常用到
    4. nsqadmin的所有功能都必须依赖于nsqlookupd，nsqadmin只是向nsqlookupd传递用户操作并展示来自nsqlookupd的数据

nsqadmin默认的访问地址是http://127.0.0.1:4171/ 
```

#### nsqd（管理服务）
> nsqd 是一个守护进程，负责接收，排队，投递消息给客户端
```
它主要负责message的收发，队列的维护。nsqd会默认监听一个tcp端口(4150)和一个http端口(4151)以及一个可选的https端口
    1. 对订阅了同一个topic，同一个channel的消费者使用负载均衡策略（不是轮询）
    2. 只要channel存在，即使没有该channel的消费者，也会将生产者的message缓存到队列中（注意消息的过期处理）
    3. 保证队列中的message至少会被消费一次，即使nsqd退出，也会将队列中的消息暂存磁盘上(结束进程等意外情况除外)
    4. 限定内存占用，能够配置nsqd中每个channel队列在内存中缓存的message数量，一旦超出，message将被缓存到磁盘中
    5. topic，channel一旦建立，将会一直存在，要及时在管理台或者用代码清除无效的topic和channel，避免资源的浪费
```
