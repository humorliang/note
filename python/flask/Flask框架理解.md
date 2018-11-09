### Flask框架的理解

#### 请求钩子函数
```python
'''@app.before_request或者 @app.after_request  装饰器在请求前或请求后执行的函数即可'''

@app.before_request
def before_request_fun():
    '''在全局请求之前都会执行此函数'''
    print('过滤IP等拦截器功能')

@app.after_request
def after_request_fun():
    '''在全局请求之后，还未返回信息前都会执行此函数'''
    print('可用于压缩相应数据等功能')

````
#### 请求二次封装
```python
'''flask 中的request是全局对象我们可以对其进行自定义操作，配合钩子函数实现全局处理'''
@app.before_request
def request_data_type():
    '''返回统一的数据格式
    :return dict类型参数
    '''
    # 定义一个_dict属性进行自定义操作
    request._dict = None
    if request.form:
        request._dict = dict(request.form)
    elif request.get_json():
        request._dict = dict(request.get_json())
    elif request.values:
        request._dict = dict(request.values)
    else:
        abort(400, {'success': False, 'data': '请求有误！请求的数据为form或json类型数据不能为空！'})
```
#### 自定义全局异常处理和捕获
```python
from flask import request, json
from werkzeug.exceptions import HTTPException
class ApiException(HTTPException):
    '''
    API请求异常基类，
    code: 服务器错误状态码
    msg : 错误内容
    error：错误编码
    '''
    code = 500
    msg = '服务器错误'

    def __init__(self, code=None, msg=None, error_code=None, header=None):
        if code:
            self.code = code
        if msg:
            self.msg = msg
        # 继承HttpException然后再重构 HttpException 构造函数参数：description=None, response=None
        super().__init__(msg, None)

    # 重写父类get_body方法 返回特定的body 信息
    def get_body(self, environ=None):
        """Get the HTML body."""
        body = {
            'success': False,
            'data': {
                'code': self.code,
                'msg': self.msg,
                'path': request.full_path,
            }
        }
        return json.dumps(body)

    # 重写父类的get_headers方法 返回特定的头信息
    def get_headers(self, environ=None):
        """Get a list of headers."""
        return [('Content-Type', 'application/json')]

```