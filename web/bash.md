### 上传文件scp
scp [参数] [原路径] [目标路径]
//上传文件到远程
```bash
# 参数 -r遍历整个目录
scp  /opt/soft/nginx-0.5.38.tar.gz  root@192.168.120.204:/opt/soft/scptest
```
//下载文件到本地
```bash
# 参数 -r遍历整个目录
scp  -r  root@192.168.120.204:/opt/soft/mongodb  /opt/soft/
```


