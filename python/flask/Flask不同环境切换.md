### Flask不同环境设置
#### 使用不同的配置文件
* 下载环境读取库
```python
# 使用 environs==4.0.0 读取环境变量
pip install environs
```
* 在项目工程下创建 .env文件
```ini
# Environment variable overrides for local development
FLASK_APP=wsgi.py
FLASK_ENV=production
SECRET_KEY="sa!!id,}s*ha2@@#4"
DATABASE_HOST="127.0.0.1"
DATABASE_PORT=3306
DATABASE_USER="root"
DATABASE_PASSWORD="123456"
DATABASE_NAME="android_app"
```
* 编写环境变量设置模块 setting.py
```python
# coding:utf-8
from environs import Env

# 从环境中读取一个 .env的配置文件
env = Env()
env.read_env()

ENV = env.str('FLASK_ENV', default='production')
DEBUG = ENV == 'development'  # 环境比较得bool值
SECRET_KEY = env.str('SECRET_KEY')
DATABASE_HOST = env.str('DATABASE_HOST')
DATABASE_PORT = env.int('DATABASE_PORT')
DATABASE_USER = env.str('DATABASE_USER')
DATABASE_NAME = env.str('DATABASE_NAME')
DATABASE_PASSWORD = env.str('DATABASE_PASSWORD')
```
* 工厂函数里设置
```python
def create_app(config_object='app.setting'):
    '''flask工厂函数'''
    app = Flask(__name__, instance_relative_config=True)
    # app配置 from_object 可以从一个模块和包中进行读取
    # app.config.from_object('yourapplication.default_config')
    app.config.from_object(config_object)
```
