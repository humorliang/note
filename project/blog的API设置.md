### 博客API设置
### 全局API
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
        "user_login":"user",
        "user_nicename":"三毛",
        "user_email":"123@163.com",
        "token":"daqweopfdsuascak.ajofaf.foafowfe-sdfs"
    }
}
```
##### 上传文件
post请求：http://www.test.com/v1/upload
参数：表单
```
filename:文件名
```
```json
{
    "code":0,
    "msg":"success",
    "data":"上传成功"
}
```
### 后台API
#### 用户
##### 1.用户列表
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
##### 2.用户删除
delete请求：http://www.test.com/v1/admin/user （头部携带token）
参数：json
```json
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
#### 文章
##### 1.获取所有文章列表
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
                "post_author":"三毛", // user_nicename
                "post_date":"2018-10-10 12:00:00",
                "post_title":"文章标题",
                // "term_id":"分类ID",
                // "term_name":"分类名",
                "post_excerpt":"文章描述",
                "post_status" :0, //0，1发表/不发表
                "comment_status":0, //0，1允许/不允许
                "post_modified":"2018-10-10 12:00:00",//最后修改时间
                "comment_count":"评论数"
            },{
                "post_id":2,
                "post_author":"三毛",
                "post_date":"2018-10-10 12:00:00",//发布时间
                "post_title":"文章标题",
                // "term_id":"分类ID",
                // "term_name":"分类名",
                "post_excerpt":"文章描述",
                "post_status" :0, //0，1发表/不发表
                "comment_status":0, //0，1允许/不允许
                "post_modified":"2018-10-10 12:00:00",//最后修改时间
                "comment_count":"评论数"
            }]
        }
}
```
##### 2.添加文章
post请求：http://www.test.com/v1/admin/post
参数：json
```json
{
    "post_title":"标题",
    "post_excerpt":"描述",
    "post_content":"内容"
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"添加成功"
}
```
##### 3.编辑文章
put请求：http://www.test.com/v1/admin/post/title
参数：json
```json
{
    "post_id":1,
    "post_title":"标题",
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"编辑成功"
}
```
put请求：http://www.test.com/v1/admin/post/status 
参数：json
```json
{
    "post_id":1,
    "post_status":1,
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"编辑成功"
}
```
put请求：http://www.test.com/v1/admin/post/comment/status
参数：json
```json
{
    "post_id":1,
    "comment_status":1,
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"编辑成功"
}
```
##### 4.删除文章
delete请求：http://www.test.com/v1/admin/post
参数：json
```json
{
    "post_id":1 //文章Id
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"编辑成功"
}
```
#### 分类
##### 1.添加分类法和分类并关联
post请求：http://www.test.com/v1/admin/taxonomy/term
参数:json
```json
{
    //分类名
    "term_name":"GO",
    //所属分类方法  文章标签：posttag  菜单：menu
    "taxonomy":"posttag",  
    //对这个分类法的详细说明
    "description":"这是文章分类法", 
    //这个分类名的父级
    "term_parent_id":1 //父类ID
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "term_id":1,  //分类ID
        "taxonomy_id":1 //分类法ID
    }
}
```
##### 2.获取相关分类组
get请求：http://www.test.com/v1/admin/taxonomy/term
参数:json
```json
{
    "taxonomy":"posttag",  
}
```
响应：
```json
{
    "code": 0,
    "data": [
        {
            "description": "这是文章标签分类法",
            "taxonomy": "posttag",
            "term_id": 2,
            "term_name": "Java",
            "term_parent_id": 0,
            "term_taxonomy_id": 2
        },
        {
            "description": "这是文章标签分类法",
            "taxonomy": "posttag",
            "term_id": 6,
            "term_name": "web",
            "term_parent_id": 0,
            "term_taxonomy_id": 6
        }
    ],
    "msg": "success"
}
```
##### 3.获取全部分类
get请求：http://www.test.com/v1/admin/taxonomys/term
参数：无
响应：
```json
{
    "code": 0,
    "data": [
        {
            "description": "这是文章标签分类法",
            "taxonomy": "posttag",
            "term_id": 6,
            "term_name": "web",
            "term_parent_id": 0,
            "term_taxonomy_id": 6
        },
        {
            "description": "这是文章标签分类法",
            "taxonomy": "menu",
            "term_id": 7,
            "term_name": "web",
            "term_parent_id": 0,
            "term_taxonomy_id": 7
        },
    ],
    "msg": "success"
}
```
##### 4.删除相关分类
delete请求：http://www.test.com/v1/admin/taxonomy/term
参数：json
```json
{
    term_id:分类名
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"删除成功"
}
```
##### 5.分类关联相关文章
post请求：http://www.test.com/v1/admin/taxonomy/term/post
参数：json
```json
    "term_id":1,
    "post_id":1
```
响应：
```json

```
#### 评论
##### 1.全部评论列表
get请求：http://www.test.com/v1/admin/comments?page_num=1
参数：query
```
page_num:页码
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":[
        {
            "comment_id":1,
            "comment_post_id":1,
            "post_title":"文章标题",
            "comment_author":"评论作者",
            "comment_author_IP":"176.26.66.92",
            "comment_content":"内容",
            "comment_date":"2018-10-10",
            "comment_approved":0 ,//是否被允许
        },{
            "comment_id":2,
            "comment_post_id":1,
            "post_title":"文章标题",
            "comment_author":"评论作者",
            "comment_author_IP":"176.26.66.92",
            "comment_content":"内容",
            "comment_date":"2018-10-10",
            "comment_approved":0 ,//是否被允许
        }
    ]
}
```
##### 2.编辑评论
put请求：http://www.test.com/v1/admin/comment/
参数：json
```json
{
    "comment_id":1,
    "comment_approved":0
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"删除成功"
}
```
##### 3.删除评论
put请求：http://www.test.com/v1/admin/comment/
参数：json
```json
{
    "comment_id":1,
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":"删除成功"
}
```
#### 友链
##### 1.添加友链
post 请求：http://www.test.com/v1/admin/link
参数：json
```json
{
	"link_name":"QQ",
	"link_url":"www.qq.com",
	"link_description":"这是百度链接",
	"link_image_url":""
}
```
响应：
```json
{
    "code": 0,
    "data": "添加成功",
    "msg": "success"
}
```
##### 2.获取链接列表
get 请求：http://www.test.com/v1/admin/links?page_num=1
参数：query
```
page_num:页码
```
响应：
```json
{
    "code": 0,
    "msg": "success",
    "data": {
        "link_total": 3,
        "page_num": 1,
        "link_list": [
            {
                "link_description": "这是百度链接",
                "link_id": 1,
                "link_name": "百度",
                "link_url": "www.baidu.com",
                "link_visible": 0,
                "user_nicename": "山猫"
            },
            {
                "link_description": "这是百度链接",
                "link_id": 2,
                "link_name": "QQ",
                "link_url": "www.qq.com",
                "link_visible": 0,
                "user_nicename": "山猫"
            },
            {
                "link_description": "这是百度链接",
                "link_id": 3,
                "link_name": "邮箱",
                "link_url": "www.mail.qq.com",
                "link_visible": 0,
                "user_nicename": "山猫"
            }
        ]
    }
}
```
##### 3.删除友链
delete 请求：http://www.test.com/v1/admin/link
参数：json
```json
{
	"link_id":1,
}
```
响应：
```json
{
    "code": 0,
    "data": "删除成功",
    "msg": "success"
}
```
##### 4.编辑友链
put 请求：http://www.test.com/v1/admin/link
参数：json
```json
{
	"link_id":1,
    "link_visible":1,
}
```
响应：
```json
{
    "code": 0,
    "data": "编辑成功",
    "msg": "success"
}
```

### 界面API
##### 1.获取文章详细信息
get请求：http://www.test.com/v1/post?post_id=1
参数：query
```
post_id:文章ID
```
响应：
```json
{
    "code": 0,
    "msg": "success",
    "data": {
        "comment_count": 5,
        "post_author": "山猫",
        "post_content": "内容",
        "post_date": "2019-01-18 16:35:20",
        "post_excerpt": "描述",
        "post_title": "标题"
        "comment_list": [
            {
                "comment_author": "三毛",
                "comment_content": "这是文章评论内容",
                "comment_date": "2019-01-18 16:41:45",
                "comment_id": 1,
                "comment_parent": 0
            },
            {
                "comment_author": "三毛",
                "comment_content": "这是文章评论内容",
                "comment_date": "2019-01-18 16:42:12",
                "comment_id": 2,
                "comment_parent": 0
            },
            {
                "comment_author": "三毛",
                "comment_content": "这是文章评论内容",
                "comment_date": "2019-01-18 16:42:22",
                "comment_id": 3,
                "comment_parent": 1
            },
            {
                "comment_author": "三毛",
                "comment_content": "这是文章评论内容",
                "comment_date": "2019-01-18 16:42:42",
                "comment_id": 4,
                "comment_parent": 1
            }
        ]  
    }
}
```
##### 2.获取所选分类文章列表
get请求：http://www.test.com/v1/term/posts?term_id=1&page_num=1
参数：query
```
term_id：分类ID
page_num:页码
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data":{
        "post_total":10,
        "page_num":1,
        "post_list":[
            {
                "post_id":1,
                "post_author":"作者",
                "post_date":"2018-10-10",
                "post_content":"内容",
                "post_title":"标题",
                "post_excerpt":"摘要",
                "post_pre_img_url":"预览图",
                "comment_count":10,
            },{
                "post_id":2,
                "post_author":"作者",
                "post_date":"2018-10-10",
                "post_content":"内容",
                "post_title":"标题",
                "post_excerpt":"摘要",
                "post_pre_img_url":"预览图",
                "comment_count":10,
            }
        ]
    }
}
```
##### 3.发表评论
post请求：http://www.test.com/v1/comment 
参数：json
```json
{
    "comment_post_id":1,
    "comment_author":"",
    "comment_author_email":"",
    "comment_content":"", 
    "comment_parent_id":0, //父级留言评论Id
}
```
响应：
```json
{
    "code":0,
    "msg":"success",
    "data"："评论审核中"
}
```