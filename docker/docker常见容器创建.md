###　创建mysql数据库
```bash
# 开启一个mysql服务器
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

# 用mysql命令行客户端连接mysql服务器
docker run -it --network some-network --rm mysql mysql -hsome-mysql -uexample-user -p　#（some-network 服务器地址　some-mysql容器名）

# shell连接
docker exec -it some-mysql bash

# 自定义　mysql服务器的配置
docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

# 配置
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

# 数据备份
docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

### 创建nginx
```bash
# 简单实例
docker run --name some-nginx -v /some/content:/usr/share/nginx/html:ro -d nginx
# dockerfile实例
# －－－－－－－－
FROM nginx
COPY static-html-directory /usr/share/nginx/html
# －－－－－－－－
docker build -t some-content-nginx 
docker run --name some-nginx -d some-content-nginx


# 暴露端口　主机端口：容器端口
docker run --name some-nginx -d -p 8080:80 some-content-nginx

# 配置
docker run --name my-custom-nginx-container -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx
# －－－－－－－－－
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
# －－－－－－－－－
docker build -t custom-nginx
docker run --name my-custom-nginx-container -d custom-nginx

# docker-commpose.yml
# -------
web:
  image: nginx
  volumes:
   - ./mysite.template:/etc/nginx/conf.d/mysite.template
  ports:
   - "8080:80"
  environment:
   - NGINX_HOST=foobar.com
   - NGINX_PORT=80
  command: /bin/bash -c "envsubst < /etc/nginx/conf.d/mysite.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"
# -------
```
### docker 创建es

- docker操作
```bash
# 拉去镜像
docker pull elasticsearch
# 运行容器
docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch

# 进入容器
docker exec -it es /bin/bash

# 进行配置
－－－－－－－－－－－－－
# 显示文件
ls
结果如下：
LICENSE.txt  README.textile  config  lib   modules
NOTICE.txt   bin             data    logs  plugins
# 进入配置文件夹
cd config
# 显示文件
ls
结果如下：
elasticsearch.keystore  ingest-geoip  log4j2.properties  roles.yml  users_roles
elasticsearch.yml       jvm.options   role_mapping.yml   users
# 修改配置文件
vi elasticsearch.yml
# 加入跨域配置
http.cors.enabled: true
http.cors.allow-origin: "*"
－－－－－－－－－－－－－

# 重启容器
docker restart es

# es可视化客户端
# 拉取镜像
docker pull mobz/elasticsearch-head:5
# 启动容器
docker run -d -p 9100:9100 --name es-manager  mobz/elasticsearch-head:5
```
- 访问地址
```bash
# 查看节点信息
http://127.0.0.1:9200/_cat/nodes?pretty

# 客户端访问地址
http://127.0.0.1:9100/

# es状态
http://127.0.0.1:9200/_cluster/state
```
- es客户端未连接问题
```bash
# 修改配置文件 跨域问题
1. 本机创建配置文件
vim elasticsearch.yml
```
http.host: 0.0.0.0
http.cors.enabled: true
http.cors.allow-origin: "*"
```
2. 复制本机文件　到容器
docker cp elasticsearch.yml es:/usr/share/elasticsearch/config
```
#### docker 创建Kafka
1. 拉取镜像
```bash
docker pull wurstmeister/kafka
(而外相关镜像拉取)
zookeeper(wurstmeister/zookeeper:latest)
kafka-manager(sheepkiller/kafka-manager:latest)
```
2. 创建服务（docker-compose.yml文件）
```dockerfile
version: '2'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    ports:
      - "9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 192.168.45.20  # 修改为本机地址
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/localtime:/etc/localtime
  kafka-manager:  
    image: sheepkiller/kafka-manager # 镜像：开源的web管理kafka集群的界面
    environment:
        ZK_HOSTS: 192.168.45.20 # 修改为本机地址
    ports:  
      - "9000:9000"
```
3. 启动服务
docker-compose up -d

4. kafka 扩展和缩容
docker-compose scale kafka=3
