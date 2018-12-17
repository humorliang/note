## 
### 数据库表结构设置
1. 用户表
    - 用户名，密码，邮箱
2. 权限表
    - 权限(00只读  01只写 10可读可写 11不可读不可写)，用户ID
3. 文章表
    - 标题，内容，作者，日期，用户ID，分类ID
4. 评论表
    - 内容，文章ID，用户ID
5. 回复表
    - 内容，评论ID，用户ID
6. 留言表
    - 内容，用户ID
7. 分类表
    - 名称
* 表关系映射
```
    用户 --- 1 : 1 --> 权限
    用户 --- 1 : n --> 文章 -- 1:n --> 评论 
                          `-- m:n --> 分类
    用户 --- 1 : n --> 评论 -- 1:n -->  回复
    用户 --- 1 : n --> 回复 
    用户 --- 1 : n --> 留言 -- 1:n --> 回复
    用户 --- 1 : 1 --> 权限
```
* 数据表SQL
```sql
/*mysql8.0 版本*/
/*在使用varchar字段类型时 必须指定大小 否则会报错*/

```
### REST API设计
- 用户注册
> http://www.example.com/v1/register
```json
<!-- post请求 -->
{   
    "data"：{
        "username":"user",
        "password":"123456",
        "email":"" //选填
    }，
}
<!-- response响应 -->
{
    "code":0,
    "msg":"success",//异常信息
    "data":{
        "userId":1,
        "email":"superuser@163.com"
    }
}
```
- 用户登录
> http://www.example.com/v1/login
```json
<!-- post请求 -->
{   
    "data":{
        "username":"user",
        "password":"123456"
    }
}
<!-- response响应 -->
{
    "code":0,
    "msg":"success",
    "data":{
        "userId":1,
        "sessionId":"",//加密后的cookie
        "ruleId":1  //用户权限id
    }
}
```
- 用户权限
    - 获取权限
    > http://www.example.com/v1/rule
    ```json
    <!-- get -->
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":{
            "rule_name":0,
            "userId":1
        }
    }
    ```
    - 添加权限
    > http://www.example.com/v1/rule
    ```json
    <!-- post -->
    {
        "data":{
            "userId":1,
            "ruleName":1
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":{
            "rule_name":0,
            "userId":1
        }
    }
    ```
    - 修改权限
    > http://www.example.com/v1/rule
    ```json
    <!-- update -->
    {
        "data":{
            "ruleId":1,
            "ruleId":1
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"修改成功"
    }
    ```
- 文章
    - 获取不同分类的文章列表（默认时间排序分页）10篇一分页
    > http://www.example.com/v1/post/list/tag
    ```json
        <!-- get请求 -->
        {
            "data":{
                "userId":1, //用户id
                "tagId":1,  //分类id
                "pageNum":1, //分页
            }
        }
        <!-- response响应 -->
        {
            "code":0,
            "msg":"success",
            "data":{
                "postList":[
                    {
                        "postId":1,
                        "title":"标题",
                        "content":"文章内容",
                        "date":"2018-10-2",
                        "previewImgUrl":"http://www.baidu.comh/img?1.jpg",
                    },
                    {
                        "postId":2,
                        "title":"标题",
                        "content":"文章内容",
                        "date":"2018-10-2",
                        "previewImgUrl":"http://www.baidu.comh/img?2.jpg",
                    }
                ]
            }
        }
    ```
    - 获取推荐文章列表 (返回最新5条数据)
    > http://www.example.com/v1/post/list/recommend
    ```json
        <!-- get请求 -->
        {
            "data":{
                
            }
        }
        <!-- response响应 -->
        {
            "code":0,
            "msg":"success",
            "data":{
                "postList":[
                    {
                        "postId":1,
                        "title":"标题",
                        "content":"文章内容",
                        "date":"2018-10-2",
                        "previewImgUrl":"http://www.baidu.comh/img?1.jpg",
                    },
                    {
                        "postId":2,
                        "title":"标题",
                        "content":"文章内容",
                        "date":"2018-10-2",
                        "previewImgUrl":"http://www.baidu.comh/img?1.jpg",
                    }
                ]
            }
        }
    ```
    - 获取文章详情
    > http://www.example.com/v1/post/desc
    ```json
        <!-- get请求 -->
        {
            "data":{
                "userId":1,
                "postId":1
            }
        }
        <!-- response响应 -->
        {
            "code":0,
            "msg":"success",
            "data":{
                "postId":1,
                "title":"标题",
                "content":"文章内容",
                "author":"三毛",
                "date":"2018-2-16",
            }
        }
    ```
    - 增加文章
    > http://www.example.com/v1/post
    ```json
    <!-- post请求 -->
    {
        "data":{
            "userId":1,
            "tagId":1,
            "title":"标题",
            "desp":"描述",
            "content":"内容",
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"添加成功"
    }
    ```
    - 删除文章
    > http://www.example.com/v1/post
    ```json
    <!-- delete -->
    {
        "data":{
            "psotId":1
        }
    }
    <!-- responese响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"删除成功"
    }
    ```
- 评论
    - 获取评论
    > http://www.example.com/v1/comment
    ```json
    <!-- get -->
    {
        "data":{
            "postId":1
        }
    }
    <!-- responses响应 -->
    {
        "code":0,
        "msg":"success",
        "data":[
            {   
                "commentId":1,
                "userName":"user1",
                "data":"2018-01-03",
                "content":"评论内容"
            },
            {   
                "commentId":2,
                "userName":"user2",
                "data":"2018-01-05",
                "content":"评论内容"
            }
        ]
    }
    ```
    - 发表评论
    > http://www.example.com/v1/comment
    ```json
    <!-- post -->
    {
        "data":{
            "userId":1,
            "postId":2,
            "content":"发表评论",
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"评论成功"
    }
    ```
- 回复评论
> http://www.example.com/v1/reply
```json
<!-- post -->
{
    "data":{
        "commentId":1,
        "content":"回复内容"
    }
}
<!-- response响应 -->
{
    "code":0,
    "msg":"success",
    "data":"回复成功"
}
```
- 分类
    - 获取分类
    > http://www.example.com/v1/tag
    ```json
    <!-- get -->
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":[
            {
                "tagId":1,
                "tagName":"Go"
            },
            {
                "tagId":1,
                "tagName":"Go"
            }
        ]
    }
    ```
    - 添加分类
    > http://www.example.com/v1/tag
    ```json
    <!-- post -->
    {
        "data":{
            "tagName":"服务器"
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"添加成功"
    }
    ```
    - 修改分类
    > http://www.example.com/v1/tag
    ```json
    <!-- update -->
    {
        "data":{
            "tagId":1,
            "tagName":"Java"
        }
    }
    <!-- responses响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"修改成功"
    }
    ```
    - 删除分类
    > http://www.example.com/v1/tag
    ```json
    <!-- delete -->
    {
        "data":{
            "tagId":1
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"删除成功"
    }
    ```
- 留言
    - 获取留言(15条一页)
    > http://www.example.com/v1/msg/list
    ```json
    <!-- get -->
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":[
            {
                "userName":"张三",
                "content":"留言内容",
                "date":"2018-02-15"
            },
        ]
    }
    ```
    - 添加留言
    > http://www.example.com/v1/msg
    ```json
    <!-- post -->
    {
        "data":{
            "content":"留言内容"
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"留言成功"
    }
    ```
    - 删除留言
    > http://www.example.com/v1/msg
    ```json
    <!-- delete -->
    {
        "data":{
            "msgId":1
        }
    }
    <!-- response响应 -->
    {
        "code":0,
        "msg":"success",
        "data":"删除成功"
    }
    ```
