### dockerfile编写基础
#### 用法
```bash

docker build -f /path/to/a/Dockerfile .
docker build -t test/myapp .
```
#### 格式
```dockerfile
# Comment
INSTRUCTION arguments  # 指令 参数

# A Dockerfile must start with a `FROM` instruction.  
```
#### docker run用法
```bash
docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]
OPTIONS说明：

-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
-d: 后台运行容器，并返回容器ID；
-i: 以交互模式运行容器，通常与 -t 同时使用；
-p: 端口映射，格式为：主机(宿主)端口:容器端口
-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
--name="nginx-lb": 为容器指定一个名称；
--dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致；
--dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；
-h "mars": 指定容器的hostname；
-e username="ritchie": 设置环境变量；
--env-file=[]: 从指定文件读入环境变量；
--cpuset="0-2" or --cpuset="0,1,2": 绑定容器到指定CPU运行；
-m :设置容器使用内存最大值；
--net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
--link=[]: 添加链接到另一个容器；
--expose=[]: 开放一个端口或一组端口；
-v：　在容器中设置了一个挂载点 /data（就是容器中的一个目录），并将主机上的 /home/demo/myimage 目录中的内容关联到 /data下。
```
#### 常见指令
- FROM
```dockerfile

# FROM <image>[@<digest>] [AS <name>] # 设置一个基础镜像  dockerfile必须以这个指令开头
# 配合ARG指令　　
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}
```
- RUN
```dockerfile
# 用默认的shell解释器　执行一个shell命令

# 两种形式
# RUN <command> (shell form, the command is run in a shell, which by default is /bin/sh -c on Linux or cmd /S /C on Windows)
# RUN ["executable", "param1", "param2"] (exec form)

RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME'
RUN ["/bin/bash", "-c", "echo hello"]
# 换行执行
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'

```
- CMD
```dockerfile
# 执行命令

# 三种形式
# CMD ["executable","param1","param2"] (exec form, this is the preferred form)
# CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
# CMD command param1 param2 (shell form)

CMD [ "echo", "$HOME" ]
CMD [ "sh", "-c", "echo $HOME" ]
CMD echo "This is a test." | wc -
```
- RUN CMD 区别
```dockerfile
RUN 执行命令并创建新的镜像层，RUN 经常用于安装软件包。
CMD 设置容器启动后默认执行的命令及其参数，但 CMD 能够被 docker run 后面跟的命令行参数替换。

RUN apt-get install python3  
CMD echo "Hello world"  
```
- LABEL
```dockerfile
# 将数据添加到镜像
# LABEL <key>=<value> <key>=<value> <key>=<value> ...
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
```
- MAINTAINER
```dockerfile
#
# MAINTAINER <name>
LABEL maintainer="SvenDowideit@home.org.au"
```
- EXPOSE
```dockerfile
# 端口映射  
# EXPOSE <port> [<port>/<protocol>...]
EXPOSE 80/tcp
EXPOSE 80/udp
docker run -p 80:80/tcp -p 80:80/udp #本机端口与镜像端口绑定
```
- ENV
```dockerfile
# 设置环境变量
# ENV <key> <value>
# ENV <key>=<value> 
ENV myName="John Doe" myDog=Rex\ The\ Dog \
    myCat=fluffy

ENV myName John Doe
ENV myDog Rex The Dog
ENV myCat fluffy
```
- ADD
```dockerfile
# 文件或文件夹挂载
# ADD [--chown=<user>:<group>] <src>... <dest>
# ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]

ADD hom* /mydir/        # adds all files starting with "hom"
ADD hom?.txt /mydir/    # ? is replaced with any single character, e.g., "home.txt"

ADD test relativeDir/          # adds "test" to `WORKDIR`/relativeDir/
ADD test /absoluteDir/         # adds "test" to /absoluteDir/
```
- COPY
```dockerfile
# 复制资源
# COPY [--chown=<user>:<group>] <src>... <dest>
# COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]

COPY hom* /mydir/        # adds all files starting with "hom"
COPY hom?.txt /mydir/    # ? is replaced with any single character, e.g., "home.txt"

COPY test relativeDir/   # adds "test" to `WORKDIR`/relativeDir/
COPY test /absoluteDir/  # adds "test" to /absoluteDir/
```
- ENTRYPOINT
```dockerfile
# ENTRYPOINT ["executable", "param1", "param2"] (exec form, preferred)
# ENTRYPOINT command param1 param2 (shell form)

ENTRYPOINT ["top", "-b"]
```
- VOLUME
```dockerfile
# 容器中的目录挂载点
# VOLUME ["/data"]　　
FROM ubuntu
RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting
# 这种形式默认挂载到本机的　/var/lib/docker/volumes/d411f6b8f17f4418629d4e5a1ab69679dee369b39e13bb68bed77aa4a0d12d21/_data　　
# docker inspect 查看容器的信息
VOLUME /myvol 


docker run -it --name container-test -h CONTAINER -v /my/data:/data debian /bin/bash
```
- USER
```dockerfile
# 指定用户身份
# USER <user>[:<group>] or
# USER <UID>[:<GID>]

FROM microsoft/windowsservercore
# Create Windows user in the container
RUN net user /add patrick
# Set it for subsequent commands
USER patrick
```
- WORKDIR
```dockerfile
# RUN, CMD, ENTRYPOINT, COPY and ADD 执行的基础目录
# WORKDIR /path/to/workdir
ENV DIRPATH /path
WORKDIR $DIRPATH/$DIRNAME
RUN pwd
```
- ARG
```dockerfile
# 定义参数
# ARG <name>[=<default value>]
FROM busybox
ARG user1
ARG buildno
```
- RUN
```dockerfile

```
