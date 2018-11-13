## python3+Centos7.3+nginx+Gunicorn+Flask
#### 1. 搭建python3环境
- 更新常见依赖包
```linux
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make 
```
- 下载python3源码包
```bash
<!-- 下载 -->
wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz 
```
```bash
<!-- 解压 -->
tar xf Python-3.6.4.tgz
```
* 编译创建软连接生成 python3 pip3命令
```bash
<!-- 配置编译路径 -->
./configure --prefix=/user/local/python3.6

<!-- 编译安装 -->
make && make install

<!-- 生成软连接 创建python3和pip3命令 -->
ln -s /user/local/python3.6/bin/python3 /usr/bin/python3
ln -s /user/local/python3.6/bin/pip3 /usr/bin/pip3
```
#### 3. 安装NGINX
##### yum进行安装

Pre-Built Packages for Stable version
* `设置repo源地址文件`

To set up the yum repository for RHEL/CentOS, create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:
```ini
[nginx]
name=nginx repo
# OS  OSRELEASE 需要替换对应的系统和版本号
baseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/
gpgcheck=0
enabled=1
```
`Replace` “OS” with `“rhel”` or `“centos”`, depending on the distribution used, and “OSRELEASE” with `“6”` or `“7”`, for 6.x or 7.x versions, respectively.
* `下载安装`
```bash
yum install nginx -y 
```
* `设置开机启动服务`
```bash
# 设置服务开机启动
systemctl enable nginx 
# 开启服务
systemctl start nginx 
# 停止服务
systemctl stop nginx 
```
