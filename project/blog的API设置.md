### bolg的后台服务框架基于

#### 登录
post请求：http://www.test.com/v1/user/login
参数：表单提交
```
username:"user"
password:"123456"
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "user_id":
    }
}
```


#### 文章路由
- 获取文章列表
get请求：http://www.test.com/v1/posts/tag/:id
响应：
```json

```