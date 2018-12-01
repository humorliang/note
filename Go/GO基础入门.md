# GO基础入门
## 前言
### linux安装Go
* 设置Go环境变量
```bash

在环境配置文件 $HOME/.bashrc 或 $HOME/.profile 文件
export GOROOT=$HOME/go  # go安装目录
export PATH=$PATH:$GOROOT/bin # 系统全局环境变量
export GOPATH=$HOME/Applications/Go # go的工作空间可包含多个工作空间

# 激活环境变量
source .bashrc
```
* ubuntu安装C工具
```bash
 sudo apt-get install bison ed gawk gcc libc6-dev make
```
* 查看环境
```bash
go env
```
### Go的简单使用
* go 命令使用
```bash
go build  编译并安装自身包和依赖包
go install 安装自身包和依赖包
go get url  下载安装包

```
* gofmt格式化代码
```bash
gofmt -w program.go # 格式化源代码覆盖原始内容
gofmt -w *.go # 格式化并重写所有Go源文件
gofmt map1 # 格式化该目录下所有Go源文件
gofmt -r '(a)->a' -w *.go # 简单代码重构
```
* go代码文档
```bash
go doc package # 获取包文档注释
```

## 1. 语言的核心结构与技术
### 1.1 基础结构与基础数据类型
#### 1.1.1 文件名、关键字、标识符
1. 文件名
    - 文件名小写字母组成 scanner.go，文件名多个部分用 _ 进行分割 scanner_test.go
    - 源文件无大小限制
2. 标识符
   - 字母、数字、下划线_ 组成，且开头只能为 字母或_ 
   - _ 本身就是一个特殊字符 称为空白标识符  任何赋予它的值都被抛弃，所以不能在后续使用
   - 不能使用关键字
   - 36个内置预定义标识符
    ```go
    append	bool	byte	cap	close	complex	complex64	complex128	uint16
    copy	false	float32	float64	imag	int	int8	int16	uint32
    int32	int64	iota	len	make	new	nil	panic	uint64
    print	println	real	recover	string	true	uint	uint8	uintptr
    ```
3. 关键字
   - 25个关键字
    ```go
    break	default	func	interface	select
    case	defer	go	map	struct
    chan	else	goto	package	switch
    const	fallthrough	if	range	type
    continue	for	import	return	var
    ```
### 1.2 Go程序的基本结构和要素
#### 1.2.1 包的概念、导入与可见性
1. 包
   - 包是结构化代码的一种方式：每个程序都由包（通常简称为 pkg）的概念组成，可以使用自身的包或者从其它包中导入内容。
   - 每个Go文件都属于一个包  一个包多个 .go源文件
   - go源文件第一行指明所属包 `package packagename`  package main表示一个独立可执行的程序，每个go应用都包含一个mian包
   - 包名使用`小写`字母
   - 非mian的源文件,编译为`pack1.a`而不是可执行程序 
   - 除了符号 _，包中所有代码对象的标识符必须是`唯一`的，以避免名称冲突
   - 导入包即等同于包含了这个包的所有的代码对象。
  
2. 标准库
   - 标准包会存放在 `$GOROOT/pkg/$GOOS_$GOARCH/` 目录下
3. 编译
   - 属于同一个包的源文件必须全部被一起编译，一个包即是编译时的一个单元，因此根据惯例，每个目录都只包含一个包
   - 如果对一个包进行更改或重新编译，所有引用了这个包的客户端程序都必须全部重新编译
   - 依赖关系编译
   - 每段代码只会编译一次
4. 导包
   - 使用 `import` 关键字  
    ```go 
    //1. 形式
        import  “fmt”
    //2. 包组  多个包名最好按字母排序
        import (
            "fmt"
            "os"
        )
    ```
    - 包中的可见性原则
        导出（public）: 标识符（包括常量、变量、类型、函数名、结构字段等等）以一个`大写字母`开头
        私有（private）: 标识符如果以`小写字母`开头
        * 注：导入外包只能访问 `导出` 标识符 
    - 冲突： 包也可以作为命名空间使用，帮助避免命名冲突（名称冲突）
    - 注意： 包导入必须使用否则报错
    - 包的分级声明和初始化
        使用 import 导入包之后定义或声明 0 个或多个常量（const）、变量（var）和类型（type），
        这些对象的作用域都是`全局的（在本包范围内）`，所以可以被本包中所有的函数调用
#### 1.2.2 函数
1. `func关键字`命名
   
   ```go
    //简单格式
    func fanctionName(){
        //代码块
    }
   ```
2. `init 函数`和 `main 函数`
   ```go
   //可执行程序第一个执行函数 可以定义多个  也可省略
    func init(){

    }

    //1. main包必须包含 main()函数否则会构建错误
    //2. main()函数没有参数 也没有返回值
    //3. 程序初始化以后第一个调用 main.main()函数  入口函数
    func main(){

    }
   ```
3. 格式声明
   左大括号 { 必须与方法的声明放在同一行，这是编译器的强制规定，否则编译报错
4. 通用格式
   ```go
    func functionName(parameter_list) (return_value_list) {
                //代码块
    }
    /*
    其中：
        parameter_list 的形式为 (param1 type1, param2 type2, …)
        return_value_list 的形式为 (ret1 type1, ret2 type2, …)
    */
   ```
#### 1.2.3 注释