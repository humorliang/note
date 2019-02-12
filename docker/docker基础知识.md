### docker资源
Docker官方英文资源：
docker官网：http://www.docker.com
Docker windows入门：https://docs.docker.com/windows/
Docker Linux 入门：https://docs.docker.com/linux/
Docker mac 入门：https://docs.docker.com/mac/
Docker 用户指引：https://docs.docker.com/engine/userguide/
Docker 官方博客：http://blog.docker.com/
Docker Hub: https://hub.docker.com/
Docker开源： https://www.docker.com/open-source

Docker中文资源：
Docker中文网站：http://www.docker.org.cn
Docker入门教程: http://www.docker.org.cn/book/docker.html
Docker安装手册：http://www.docker.org.cn/book/install.html
一小时Docker教程 ：https://blog.csphere.cn/archives/22
Docker纸质书：http://www.docker.org.cn/dockershuji.html
DockerPPT：http://www.docker.org.cn/dockerppt.html

### docker知识点
#### docker技术基础
- namespace，容器隔离的基础，保证A容器看不到B容器. 6个名空间：User,Mnt,Network,UTS,IPC,Pid
- cgroups，容器资源统计和隔离。主要用到的cgroups子系统：cpu,blkio,device,freezer,memory
- unionfs，典型：aufs/overlayfs，分层镜像实现的基础

#### docker组件
- docker Client客户端————>向docker服务器进程发起请求，如:创建、停止、销毁容器等操作
- docker Server服务器进程—–>处理所有docker的请求，管理所有容器
- docker Registry镜像仓库——>镜像存放的中央仓库，可看作是存放二进制的scm

#### Docker常见命令
##### 容器相关操作
```bash
docker create # 创建一个容器但是不启动它
docker run # 创建并启动一个容器
docker stop # 停止容器运行，发送信号SIGTERM
docker start # 启动一个停止状态的容器
docker restart # 重启一个容器
docker rm # 删除一个容器
docker kill # 发送信号给容器，默认SIGKILL
docker attach # 连接(进入)到一个正在运行的容器
docker wait # 阻塞到一个容器，直到容器停止运行
```
##### 获取容器相关信息
```bash
docker ps # 显示状态为运行（Up）的容器
docker ps -a # 显示所有容器,包括运行中（Up）的和退出的(Exited)
docker inspect # 深入容器内部获取容器所有信息
docker logs # 查看容器的日志(stdout/stderr)
docker events # 得到docker服务器的实时的事件
docker port # 显示容器的端口映射
docker top # 显示容器的进程信息
docker diff # 显示容器文件系统的前后变化
````
##### 导出容器
```bash
docker cp # 从容器里向外拷贝文件或目录
docker export # 将容器整个文件系统导出为一个tar包，不带layers、tag等信息
```
##### 执行
```bash
docker exec # 在容器里执行一个命令，可以执行bash进入交互式
```
##### 镜像操作
```bash
docker images # 显示本地所有的镜像列表
docker import # 从一个tar包创建一个镜像，往往和export结合使用
docker build # 使用Dockerfile创建镜像（推荐）
docker commit # 从容器创建镜像
docker rmi # 删除一个镜像
docker load # 从一个tar包创建一个镜像，和save配合使用
docker save # 将一个镜像保存为一个tar包，带layers和tag信息
docker history # 显示生成一个镜像的历史命令
docker tag # 为镜像起一个别名
```
##### 镜像仓库(registry)操作
```bash
docker login # 登录到一个registry
docker search # 从registry仓库搜索镜像
docker pull # 从仓库下载镜像到本地
docker push # 将一个镜像push到registry仓库中
```
##### 获取Container IP地址（Container状态必须是Up）
```bash
docker inspect id | grep IPAddress | cut -d '"' -f 4
```
##### 获取端口映射
```bash
docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' id
```
##### 获取环境变量
```bash
docker exec container_id env
```
##### 杀掉所有正在运行的容器
```bash
docker kill $(docker ps -q)
```
##### 删除老的(一周前创建)容器
```bash
docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
```
##### 删除已经停止的容器
```bash
docker rm `docker ps -a -q`
```
##### 删除所有镜像，小心
```bash
docker rmi $(docker images -q)
```
##### Dockerfile
Dockerfile是docker构建镜像的基础，也是docker区别于其他容器的重要特征，正是有了Dockerfile，docker的自动化和可移植性才成为可能。
不论是开发还是运维，学会编写Dockerfile几乎是必备的，这有助于你理解整个容器的运行。
```profile
FROM , 从一个基础镜像构建新的镜像
FROM ubuntu 
MAINTAINER , 维护者信息
MAINTAINER William <wlj@nicescale.com>
ENV , 设置环境变量
ENV TEST 1
RUN , 非交互式运行shell命令
RUN apt-get -y update 
RUN apt-get -y install nginx
ADD , 将外部文件拷贝到镜像里,src可以为url
ADD http://nicescale.com/  /data/nicescale.tgz
WORKDIR /path/to/workdir, 设置工作目录
WORKDIR /var/www
USER , 设置用户ID
USER nginx
VULUME <#dir>, 设置volume
VOLUME [‘/data’]
EXPOSE , 暴露哪些端口
EXPOSE 80 443 
ENTRYPOINT [‘executable’, ‘param1’,’param2’]执行命令
ENTRYPOINT ["/usr/sbin/nginx"]
CMD [“param1”,”param2”]
CMD ["start"]
docker创建、启动container时执行的命令，如果设置了ENTRYPOINT，则CMD将作为参数
``` 
#### Dockerfile最佳实践
##### 尽量将一些常用不变的指令放到前面
```
CMD和ENTRYPOINT尽量使用json数组方式
```
##### 通过Dockerfile构建image
```
docker build csphere/nginx:1.7 .
```
#### 镜像仓库Registry
##### 镜像从Dockerfile build生成后，需要将镜像推送(push)到镜像仓库。企业内部都需要构建一个私有docker registry，这个registry可以看作二进制的scm，CI/CD也需要围绕registry进行。

#### 部署registry
```bash
mkdir /registry
docker run  -p 80:5000  -e STORAGE_PATH=/registry  -v /registry:/registry  registry:2.0
```
#### 推送镜像保存到仓库
假设192.168.1.2是registry仓库的地址：
```bash
docker tag  csphere/nginx:1.7 192.168.1.2/csphere/nginx:1.7
docker push 192.168.1.2/csphere/nginx:1.7
```
### docker简单示例
#### 容器操作
1.创建并拉取busybox
```bash
1. docker run -it --name con01 busybox:latest   # 运行一个容器 并打开终端
# docker run 运行容器
# -t - 分配一个（伪）tty (link is external)
# -i - 交互模式 (so we can interact with it)
# --name con01 容器名
2. ip addr  # 容器内执行
3. exit   # 容器退出
# 退出时，使用[ctrl + D]，这样会结束docker当前线程，容器结束，可以使用[ctrl + P][ctrl + Q]退出而不终止容器运行
```
2.创建测试容器
```bash
docker run -d --name con03 ubuntu
# -d daemon 模式 (守护进程)
```
3.登陆到con03中
```bash
docker exec -it con03 /bin/bash
[root@efc9bda4a2ff /]# exit
```
4.停止con03
```bash
docker stop con03
```
5.开启con03
```bash
docker start con03
```
6.删除con02
```bash
docker ps -a
docker rm con02     #容器停止的状态
docker rm -f con02  #容器开启的状态
```
#### 镜像操作
1.从docker hub官方镜像仓库拉取镜像
```bash
docker pull busybox:latest
```
2.从本地上传镜像到镜像仓库
```bash
docker push 192.168.1.2/csphere/nginx:1.7
```
3.查找镜像仓库的某个镜像
```bash
docker search centos/nginx
```
4.查看本地镜像列表
```bash
docker images
```
5.删除镜像
```bash
docker rmi busybox:latest # 有容器使用会报错
docker rmi -f busybox:latest # 强制将容器变为Exited
```
6.查看构建镜像所用过的命令
```bash
docker history busybox:latest
```
#### 搭建mysql服务
1. 拉取mysql镜像
```bash
sudo docker pull mysql:5.6
```
2. 创建容器
```bash
sudo docker run --name testMysql -e MYSQL_ROOT_PASSWORD=123456 -p 6666:3306 -d mysql:5.6
##### 
–name：给新创建的容器命名，此处命名为 testMysql
-e：配置信息，此处配置mysql的root用户的登陆密码
-p：端口映射，此处映射主机6666端口到容器testMysql的3306端口
-d：成功启动容器后输出容器的完整ID，
最后一个mysql指的是mysql镜像名字

# 查看容器状态
docker ps -a
```
3. 测试mysql容器
```
1. 查看自己IP
ifconfig  
# inet 192.168.199.192

2. 使用自己电脑已经安装的mysql连接docker的mysql
mysql -u root -p -h 192.168.199.192 -P 6666

```
