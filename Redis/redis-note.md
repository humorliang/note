## redis 使用
### redis安装（ubuntu）
```bash
$ wget http://download.redis.io/releases/redis-5.0.3.tar.gz
$ tar xzf redis-5.0.3.tar.gz
$ cd redis-5.0.3
$ make
```
### docker安装redis
```bash
docker pull redis
```
### 使用

```bash
# 开启服务端
$ src/redis-server
# 开启客户端
$ src/redis-cli
```

### docker 环境下
```bash
# 创建镜像
docker run --name myRedis -p 6379:6379 redis
# 开启镜像
docker start ac83b4bf5fc0
# 进入镜像redis-cli客户端  --raw避免中文乱码
docker exec -it ac83b4bf5fc0 redis-cli --raw
127.0.0.1:6379> 
```
