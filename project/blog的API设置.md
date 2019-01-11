### bolg的后台服务框架基于

#### 用户路由
##### 登录
post请求：http://www.test.com/v1/user/login
参数：表单提交
```
user_login:"user"
user_pass:"123456"
authcode:"1234" //待定
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "user_id":1,
        "user_nicename":"三毛",
        "user_email":"123@163.com",
        "user_registered":"2018-10-10",
        "user_status":0, // 0 正常 1 异常
        "token":"daqweopfdsuascak.ajofaf.foafowfe-sdfs"
    }
}
```
##### 注册
post请求：http://www.test.com/v1/user/register
参数：表单提交
```
user_login:"" //用户名
user_pass:"" //密码 
user_nicename:"" //昵称
user_email:"" //邮箱
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "user_id":1,
        "user_nicename":"三毛",
        "user_email":"123@163.com",
        "user_registered":"2018-10-10",
        "user_status":0, // 0 正常 1 异常
        "token":"daqweopfdsuascak.ajofaf.foafowfe-sdfs"
    }
}
```
##### 用户列表
get请求：http://www.test.com/v1/admin/users?page_num=1
参数：query
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "user_total":10,
        "page_num":1,
        "user_list":[{
            "user_id":1,
            "user_nicename":"三毛",
            "user_email":"123@163.com",
            "user_registered":"2018-10-10",
            "user_status":0, // 0 正常 1 异常
        },{
            "user_id":2,
            "user_nicename":"三毛",
            "user_email":"123@163.com",
            "user_registered":"2018-10-10",
            "user_status":0, // 0 正常 1 异常    
        }]
}
```
##### 冻结用户（或删除）
delete请求：http://www.test.com/v1/admin/user?user_id=1 （头部携带token）
参数：param 
```
user_id:1  //用户ID
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"删除成功"
}
```
#### 文章路由
##### 获取所有文章列表
get请求：http://www.test.com/v1/admin/posts?page_num=1
参数：query
```
page_num 页码数
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "post_total":100,
        "page_num":1,
        "post_list":[{
                "post_id":1,
                "post_author":"三毛",
                "post_date":"2018-10-10 12:00:00",
                "post_title":"文章标题",
                "post_excerpt":"文章描述",
                "post_status" :"文章状态",
                "comment_status":"open",
                "comment_count":"评论数"
            },{
                "post_id":2,
                "post_author":"三毛",
                "post_date":"2018-10-10 12:00:00",//发布时间
                "post_title":"文章标题",
                "post_excerpt":"文章描述",
                "post_status" :"publish", //publish  libsave
                "comment_status":"open", //open close
                "post_modified":"2018-10-10 12:00:00",//最后修改时间
                "comment_count":"评论数"
            }]
        }
}
```
##### 分类全部文章列表
get请求：http://www.test.com/v1/admin/term/posts?term_id=1&page_num=1
参数：query
```
term_id:分类ID
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "post_total":100,
        "page_num":1,
        "post_list":[{
                "post_id":1,
                "post_author":"三毛",
                "post_date":"2018-10-10 12:00:00",
                "post_title":"文章标题",
                "post_excerpt":"文章描述",
                "post_status" :"文章状态",
                "comment_status":"open",
                "comment_count":"评论数"
            },{
                "post_id":2,
                "post_author":"三毛",
                "post_date":"2018-10-10 12:00:00",//发布时间
                "post_title":"文章标题",
                "post_excerpt":"文章描述",
                "post_status" :"publish", //publish  libsave
                "comment_status":"open", //open close
                "post_modified":"2018-10-10 12:00:00",//最后修改时间
                "comment_count":"评论数"
            }]
        }
}
```

##### 获取文章详细信息
get请求：http://www.test.com/v1/post?post_id=1
参数：query
```
post_id:文章ID
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "post_id":1,
        "post_author":"三毛",
        "post_date":"2018-10-10 12:00:00",
        "post_content":"文章内容",
        "post_title":"文章标题",
        "post_excerpt":"文章描述",
        "post_status" :"文章状态",
        "comment_status":"open",
        "comment_count":"评论数"
        "comment_list":[
            {   
                "comment_id":1,
                "comment_author":"李四",
                "comment_content":"",
                "comment_date":"",
                "comment_child_list":[
                    {
                        "comment_id":1,
                        "comment_author":"王五",
                        "comment_content":"",
                        "comment_date":"",
                    }
                ]
            }
        ]
    }
}
```
