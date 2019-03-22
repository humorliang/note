### etcd配置参数
先来说明下 etcd 各个配置参数的意思（参考自 etcd 使用入门）：

    –name：节点名称，默认为 default。
    –data-dir：服务运行数据保存的路径，默认为${name}.etcd。
    –snapshot-count：指定有多少事务（transaction）被提交时，触发截取快照保存到磁盘。
    –heartbeat-interval：leader 多久发送一次心跳到 followers。默认值是 100ms。
    –eletion-timeout：重新投票的超时时间，如果 follow 在该时间间隔没有收到心跳包，会触发重新投票，默认为 1000 ms。
    –listen-peer-urls：和同伴通信的地址，比如http://ip:2380，如果有多个，使用逗号分隔。需要所有节点都能够访问，所以不要使用 localhost！
    –listen-client-urls：对外提供服务的地址：比如http://ip:2379,http://127.0.0.1:2379，客户端会连接到这里和 etcd 交互。
    –advertise-client-urls：对外公告的该节点客户端监听地址，这个值会告诉集群中其他节点。
    –initial-advertise-peer-urls：该节点同伴监听地址，这个值会告诉集群中其他节点。
    –initial-cluster：集群中所有节点的信息，格式为node1=http://ip1:2380,node2=http://ip2:2380,…，注意：这里的 node1 是节点的 –name 指定的名字；后面的 ip1:2380 是 –initial-advertise-peer-urls 指定的值。
    –initial-cluster-state：新建集群的时候，这个值为 new；假如已经存在的集群，这个值为 existing。
    –initial-cluster-token：创建集群的 token，这个值每个集群保持唯一。这样的话，如果你要重新创建集群，即使配置和之前一样，也会再次生成新的集群和节点 uuid；否则会导致多个集群之间的冲突，造成未知的错误。

上述配置也可以设置配置文件，默认为/etc/etcd/etcd.conf。
## dockerfile制作
```dockerfile
FROM alpine:latest

ADD etcd /usr/local/bin/
ADD etcdctl /usr/local/bin/
RUN mkdir -p /var/etcd/
RUN mkdir -p /var/lib/etcd/

# Alpine Linux doesn't use pam, which means that there is no /etc/nsswitch.conf,
# but Golang relies on /etc/nsswitch.conf to check the order of DNS resolving
# (see https://github.com/golang/go/commit/9dee7771f561cf6aee081c0af6658cc81fac3918)
# To fix this we just create /etc/nsswitch.conf and add the following line:
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 2379 2380

# Define default command.
CMD ["/usr/local/bin/etcd"]
```

### docker 运行etcd
```bash
rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp && \
  docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data \
  --name etcd-gcr-v3.3.12 \
  etcd:latest \
  /usr/local/bin/etcd \
  --name s1 \
  --data-dir /etcd-data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster s1=http://0.0.0.0:2380 \
  --initial-cluster-token tkn \
  --initial-cluster-state new

docker exec etcd-gcr-v3.3.12 /bin/sh -c "/usr/local/bin/etcd --version"
docker exec etcd-gcr-v3.3.12 /bin/sh -c "ETCDCTL_API=3 /usr/local/bin/etcdctl version"
docker exec etcd-gcr-v3.3.12 /bin/sh -c "ETCDCTL_API=3 /usr/local/bin/etcdctl endpoint health"
docker exec etcd-gcr-v3.3.12 /bin/sh -c "ETCDCTL_API=3 /usr/local/bin/etcdctl put foo bar"
docker exec etcd-gcr-v3.3.12 /bin/sh -c "ETCDCTL_API=3 /usr/local/bin/etcdctl get foo"
```