### 管理进程工具
#### supervisor
* `理解`
supervisord服务端程序。它负责在自己的调用中启动子程序，响应客户端的命令，重新启动崩溃或退出的子进程，记录其子进程stdout和stderr 输出，以及生成和处理对应于子进程生命周期中的“事件”。
supervisord（supervisor 是一个 C/S 模型的程序，这是 server 端，对应的有 client 端：supervisorctl）和应用程序（要管理的程序）。
* `supervisord 配置`
```bash
1. echo_supervisord_conf 命令输出默认的配置项
# 重定向到某一个配置文件
echo_supervisord_conf > /etc/supervisord.conf
```
* `配置文件内容`
```conf
[unix_http_server]
file=/tmp/supervisor.sock   ; the path to the socket file

[supervisord]
logfile=/tmp/supervisord.log ; main log file; default $CWD/supervisord.log
logfile_maxbytes=50MB        ; max main logfile bytes b4 rotation; default 50MB
logfile_backups=10           ; # of main logfile backups; 0 means none, default 10
loglevel=info                ; log level; default info; others: debug,warn,trace
pidfile=/tmp/supervisord.pid ; supervisord pidfile; default supervisord.pid
nodaemon=false               ; start in foreground if true; default false
minfds=1024                  ; min. avail startup file descriptors; default 1024
minprocs=200                 ; min. avail process descriptors;default 200

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket
;username=chris              ; should be same as in [*_http_server] if set
;password=123                ; should be same as in [*_http_server] if set
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")
;history_file=~/.sc_history  ; use readline history if available

[include] ;包含其他的配置文件
;files = relative/directory/*.ini  ;可以是 *.conf 或 *.ini
```
`* 启动supervisor并指定配置文件`
```bash
# 启动如果不指定配置文件会按照$CWD/supervisord.conf, $CWD/etc/supervisord.conf, /etc/supervisord.conf）进行查找
supervisord -c /etc/supervisord.conf
# 查看进程
ps -aux | grep supervisord
```
`* 包含program配置文件`
1. 新建一个目录（存储其他配置文件）
```bash
mkdir /etc/supervisor/
```
2. 修改supervisor.conf文件
```ini
[include]
files = /etc/supervisor/*.conf
```
3. 新建web.conf文件
```bash
vim /etc/supervisor/web.conf
```
4. 文件内容
```ini
[program:flask_app]
directory = /home/www/app ; 程序的启动目录
; wsgi.py是一个包含实例app的入口文件
command = /home/www/py36env/bin/gunicorn -w 8 -b 0.0.0.0:17510 wsgi:app  ; 启动命令 wsgi.py 入口文件
autostart = true     ; 在 supervisord 启动的时候也自动启动
startsecs = 5        ; 启动 5 秒后没有异常退出，就当作已经正常启动了
autorestart = true   ; 程序异常退出后自动重启
startretries = 3     ; 启动失败自动重试次数，默认是 3
user = root          ; 用哪个用户启动
redirect_stderr = true  ; 把 stderr 重定向到 stdout，默认 false
stdout_logfile_maxbytes = 20MB  ; stdout 日志文件大小，默认 50MB
stdout_logfile_backups = 20     ; stdout 日志文件备份数
; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
stdout_logfile = /data/logs/flask_app_stdout.log
```
##### 注意点
```ini
[program:flask_app]中的flask_app是应用唯一标识符，不能重复。后面supervisorctl对程序的操作（restart，start）都是通过这个名字来的
```
* web管理界面
```
可以配置 supervisrod 启动 web 管理界面，这个 web 后台使用 Basic Auth 的方式进行身份认证
```

#### supervisorctl(命令行客户端工具)
* 理解
```bash
supervisor的命令行客户端名为 supervisorctl。
```
* 启动（需要指定与supervisor配置的同一份文件）
```bash
supervisorctl -c /etc/supervisord.conf
```
* 操作
```bash
supervisorctl status # 查看程序状态
supervisorctl stop flask_app # 关闭
supervisorctl start flask_app # 启动
supervisorctl restart flask_app # 重启
supervisorctl reread # 读取有配置文件更新的文件，不会启动新添加程序
supervisorctl update # 重启配置文件修改过的文件
```

