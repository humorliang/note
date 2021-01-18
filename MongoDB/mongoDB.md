### 简介
```bash
Mongo是Nosql数据库
文档存储一般用类似json的格式存储，存储的内容是文档型的。
这样也就有有机会对某些字段建立索引，实现关系数据库的某些功能。
```
### 使用
- 安装
```sh
# 1. 使用docker搭建mongoDB
docker run --name some-mongo -p 27017:27017 -d mongo

## 设置账号密码以及网络
docker run -d --network some-network --name some-mongo \
    -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
    -e MONGO_INITDB_ROOT_PASSWORD=secret \
    mongo

## 进入mongo 
docker exec -it some-mongo bash

## 安装mongo客户端
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN sudo apt-get install -y mongodb-org-shell
RUN sudo apt-get install -y mongodb-org-tools
```
### 数据库操作
### 数据增删
```
1. 
```
### 高级查询
### 聚合
### 数据模型
### 分片
### 复本集
### 安全
### 存储