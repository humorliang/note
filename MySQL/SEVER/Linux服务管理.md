### systemctl管理服务
Centos7自定义服务
每个服务都存在 /usr/lib/systemd/system/ 里都是以 .service结尾
```ini
[Unit]   部分主要是对这个服务的说明，内容包括Description和After，Description 用于描述服务，After用于描述服务类别
[Service]   部分是服务的关键，是服务的一些具体运行参数的设置.
Type=forking   是后台运行的形式，
User=users   是设置服务运行的用户,
Group=users   是设置服务运行的用户组,
PIDFile    为存放PID的文件路径，# linux里每一个进程都是一个.pid文件
ExecStart为    服务的具体运行命令,
ExecReload   为重启命令，
ExecStop   为停止命令，
PrivateTmp=True   表示给服务分配独立的临时空间
注意：[Service]部分的启动、重启、停止命令全部要求使用绝对路径，使用相对路径则会报错！
```
##### 示例
```ini
# vim /usr/lib/systemd/system/nginx.service 
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID

[Install]
WantedBy=multi-user.target
```
##### 服务使用
```bash
1. 开机自动启动服务
systemctl enable nginx.service

2. 开启服务
systemctl start nginx.service

3. 停止服务
systemctl stop nginx.service

4. 重启服务
systemctl restart nginx.service

5. 开机不自动启动服务
systemctl disable nginx.service

6. 服务状态
systemctl status nginx.service

6. 显示已启动的服务
systemctl  list-units --type=service
```