### GO语言
> 教程： https://www.kancloud.cn/liupengjie/go/570011
#### 起步
* 安装
> 下载地址：https://studygolang.com/dl
* 配置环境
```ini
# ~/.bash_profile

# go的安装路径
export GOROOT=/usr/local/go
# go install/go get和 go的工具等会用到GOPATH环境变量.
# 最好不要跟安装目录一个路径，可以在用户目录下新建一个目录
export GOPATH=/Users/datatist001/gopath
export GOBIN=$GOPATH/bin
# 添加到系统path中
export PATH=$PATH:$GOROOT/bin:$GOBIN


# source ~/.bash_profile  激活环境
```
* 理解
```ini
# 理解为工作空间
GOPATH是作为编译后二进制的存放目的地和import包时的搜索路径 
(也是你的工作目录, 在src下可以创建你自己的go源文件)
GOPATH之下主要包含三个目录: bin、pkg、src
bin目录主要存放可执行文件;
pkg目录存放编译好的库文件, 主要是*.a文件;
src目录下主要存放go的源文件；
```

#### 入门
##### 工作空间、包
`GO 初始化函数`
```go
• 每个源文件都可以定义一个或多个初始化函数。 
• 编译器不保证多个初始化函数执行次序。
• 初始化函数在单一线程被调 ，仅执行一次。 
• 初始化函数在包所有全局变量初始化后执行。 
• 在所有初始化函数结束后才执行 main.main()。 
• 无法调用初始化函数。
```
`Golang 工作空间 ：`
编译工具对源码目录有严格要求，每个工作空间 (workspace) 必须由 bin、pkg、src 三个目录组成。
```bash
workspace
    |
	+--- bin     			// go install 安装目录。
	|	|
	| 	+--- learn
	|
	+--- pkg。             // go build 生成静态库 (.a) 存放目录。
	|	  |
	| 	  +--- darwin_amd64 
	|				|
	| 				+--- mylib.a 
	|				|
	| 				+--- mylib 
	|					   |
	| 					   +--- sublib.a
	|	
	+--- src 			// 项目源码目录。
	|
	+--- learn
	|	   |
	| 	   +--- main.go
	|  
	+--- mylib
		   |		
		   +--- mylib.go
		   |		
		   +--- sublib
				   |
				   +--- sublib.go
# 可在 GOPATH 环境变量列表中添加多个工作空间，但不能和 GOROOT 相同。
# export GOPATH=$HOME/projects/golib:$HOME/projects/go
# 通常 go get使用第一个工作空间保存下载的第三方库
```
`Golang 源文件`
```go
编码:源码文件必须是 UTF-8 格式，否则会导致编译器出错。
结束:语句以 ";" 结束，多数时候可以省略。
注释: 持 "//"、"/**/" 两种注释方式，不能嵌套。
命名:采用 camelCasing 风格（驼峰命名法），不建议使用下划线。
```
`Golang 包结构`
所有代码都必须组织在 package 中。
```go
源文件头部以 "package <name>" 声明包名称。
• 包由同一目录下的多个源码文件组成。
• 包名类似 namespace，与包所在目录名、编译文件名无关。 
• 目录名最好不用 main、all、std 这三个保留名称。
• 可执行文件必须包含 package main，入口函数 main。
```
`编码特点`
```go
1. 导入包 ：

使用包成员前，必须先用 import 关键字导入，但不能形成导入循环。
import "相对目录/包主文件名"
相对目录是指从<workspace>/pkg/<os_arch>开始的子目录，以标准库为例:
import "fmt"      ->  /usr/local/go/pkg/darwin_amd64/fmt.a
import "os/exec"  -> /usr/local/go/pkg/darwin_amd64/os/exec.a
2. 命名规则
该规则适用于全局变量、全局常量、类型、结构字段、函数、方法等。
GO大小写敏感
包中成员以名称 首字母大小写 决定访问权限。
首字母大写的名称是被导出的。
在导入包之后，你只能访问包所导出的名字，任何未导出的名字是不能被包外的代码访问的。Foo 和 FOO 都是被导出的名称。名称 foo 是不会被导出的。
```
`import用法`
```go
import "fmt"		//最常用的一种形式（系统包）
import "./test"		//导入同一目录下test包中的内容（相对路径）
import "shorturl/model 	//加载gopath/src/shorturl/model模块（绝对路径）
import f "fmt"		//导入fmt，并给他启别名ｆ
import . "fmt" 		//将fmt启用别名"."，这样就可以直接使用其内容，而不用再添加fmt。如fmt.Println可以直接写成Println
import  _ "fmt" 	//表示不使用该包，而是只是使用该包的init函数，并不显示的使用该包的其他内容。
//注意：这种形式的import，当import时就执行了fmt包中的init函数，而不能够使用该包的其他函数。

// import 导入只会调用init()函数  不会调用其他函数
```
`"_" 标识符`
```go
“_”是特殊标识符，用来忽略结果。
占位符，意思是那个位置本应赋给某个值，但是咱们不需要这个值。
那另一个就用 "_" 占位，而如果用变量的话，不使用，编译器是会报错的。
```


