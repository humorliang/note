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
#### 4. 创建虚拟环境
##### 下载virtualenv
```bash
pip install virtualenv
```
##### 设置虚拟环境python环境，并激活
```bash
# 创建
virtualenv  env  --python=/user/local/python3.6/bin/python3
# 激活
source env/bin/activate
# 退出
deactivate
```
#### 5. 配置gitee仓库
- 配置ssh秘钥
```bash
# 生成秘钥
ssh-keygen -t rsa -C "xxxxx@xxx.com"  
# 秘钥添加
cat /root/.ssh/id_rsa.pub
# 测试是否成功
ssh -T git@gitee.com
```
#### 6. 管理进程supervisor和gunicorn安装配置
- 下载gunicorn
```bash
# 虚拟环境下
pip install gunicron
```
##### 6.1 Centos7下安装配置supervisor
1. 下载supervisor
```bash
yum install supervisor
```
2. 设置服务
```bash
# 开启自动启动服务
systemctl enable supervisord.service
# 开启
systemctl start supervisord.service
# 重启
systemctl restart supervisord.service
# 停止
systemctl stop supervisord.service
```
3. 配置文件
```
supervisord 的配置 文件是 /etc/supervisord.conf
自定义配置文件目录是/etc/supervisord.d,该目录下文件已.ini为后缀
```
4. 配置进程
```bash
# gunicorn进程为例
vim  /etc/supervisord.d/gunicornApp.ini
``` 
```ini
[program:todo] ; todo 名字要唯一并且不能重复，后面管理进程用的到
directory = /home/www/todo ; 程序的启动目录
command = /home/www/py36env/bin/gunicorn -w 8 -b 0.0.0.0:8000 wsgi:app  ; 启动命令，可以看出与手动在命令行启动的命令是一样的
autostart = true     ; 在 supervisord 启动的时候也自动启动
startsecs = 5        ; 启动 5 秒后没有异常退出，就当作已经正常启动了
autorestart = true   ; 程序异常退出后自动重启
startretries = 3     ; 启动失败自动重试次数，默认是 3
user = root         ; 用哪个用户启动
redirect_stderr = true  ; 把 stderr 重定向到 stdout，默认 false
stdout_logfile_maxbytes = 20MB  ; stdout 日志文件大小，默认 50MB
stdout_logfile_backups = 20     ; stdout 日志文件备份数
; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
stdout_logfile = /data/logs/todo_stdout.log
; 可以通过 environment 来添加需要的环境变量，一种常见的用法是修改 PYTHONPATH
; environment=PYTHONPATH=$PYTHONPATH:/path/to/somewhere
```
5.管理进程（supervisorctl）
```bash
supervisorctl status                     # 状态
supervisorctl stop [todo]                #关闭 [todo]
supervisorctl start [todo]               #启动 [todo]
supervisorctl restart [todo]             #重启 [todo]
supervisorctl reread
supervisorctl update                    #更新新的配置
```
6. 问题
* 解决unix:///tmp/supervisor.sock no such file的问题
```bash
# 杀死进程
kill -9 pidId 
# 重新开启
/usr/bin/supervisord -c /etc/supervisord.conf
systemctl restart supervisord.service
```
### MySQL 服务器安装（centos）
#### yum安装mysql8.0
```bash
# 下载rpm源
wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
# 安装源
yum -y install mysql80-community-release-el7-1.noarch.rpm 
# 安装MySQL服务器
yum install mysql-community-server
```
#### mysql初始设置
* 修改密码
```sql
/*查看原始密码*/
grep "password" /var/log/mysqld.log
/*MySQL有密码验证机制大小写字母、数字和特殊符号，并且长度不能少于8位。*/
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456WWqwe';
```
* 授权
```sql
/*授权  %代表所有IP */
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456WWqwe' WITH GRANT OPTION;
/*生效*/
mysql>FLUSH PRIVILEGES;

```
* 开机启动
```bash
systemctl enable mysqld
# 重载配置文件
systemctl daemon-reload
```



