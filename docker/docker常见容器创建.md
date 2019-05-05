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