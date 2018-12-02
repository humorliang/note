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
```go
//单行注释

/*
快注释
*/
```
#### 1.2.4 类型
1. 类型
   - 变量（或常量）包含数据，这些数据可以有不同的数据类型，简称 类型
   - var 声明的变量 自动初始化为该类型的零值
2. 分类
   - 基本数据类型：
        `int`   `float`   `bool`  `string`
   - 结构化的（复合的）：
        `struct`  `array`  `slice`  `map`  `channel`
        - 结构类型没有值，默认值为：`nil`
   - 描述类型的行为：
        `interface`
   - 函数也是特殊类型作为返回值
    ```go
        func FunctionName (a typea, b typeb) typeFunc
    ```
3. `type`关键字
   type关键字可以定义自己的类型

#### 1.2.5 Go程序的一般结构
Go程序一般结构总体思路如下：
- 在完成包的 import 之后，开始对常量、变量和类型的定义或声明。
- 如果存在 init 函数的话，则对该函数进行定义（这是一个特殊的函数，每个含有该函数的包都会首先执行这个函数）。
- 如果当前包是 main 包，则定义 main 函数。
- 然后定义其余的函数，首先是类型的方法，接着是按照 main 函数中先后调用的顺序来定义相关函数，如果有很多函数，则可以按照字母顺序来进行排序。

示例程序：
```go
//1. 包声明
    package main
//2. 导包
    import (
    "fmt"
    )
//3. 定义变量和结构
    const c = "C"
    var v int = 5
    type T struct{}
//4. 初始化函数
    func init() { 
    }
//5.主函数
    func main() {
        var a int
        Func1()
        // ...
        fmt.Println(a)
    }
//6. 方法
    func (t T) Method1() {
        //...
    }
//7. 函数
    func Func1() { 
        //...
    }

```
* Go 程序的执行（程序启动）顺序如下：
  1. 按顺序导入所有被 main 包引用的其它包，然后在每个包中执行如下流程：
  2. 如果该包又导入了其它的包，则从第一步开始递归执行，但是每个包只会被导入一次。
  3. 然后以相反的顺序在每个包中初始化常量和变量，如果该包含有 init 函数的话，则调用该函数。
  4. 在完成这一切之后，main 也执行同样的过程，最后调用 main 函数开始执行程序
#### 1.2.6 类型转换
* 转换
   - Go语言不存在隐式转换
   - 显式转换：
    ```go
    //类型B的值 = 类型B(类型A的值)
    valueOfTypeB = typeB(valueOfTypeA)
    ````
#### 1.2.7 Go命名规范
1. 简洁明了
2. 驼峰命名
### 1.3 常量
1. `const`关键字
   - 存储不会改变的关键字
   - 布尔型、数字型、字符串型
   - 格式：
   ```go
    const identifier [type]=value
   ```
   - 定义：
        - 显式定义： `const b string = "abc"`
        - 隐式定义： `const b="abc"`
   - 常量的值在编译时必须是确定的
2. `iota`标识符
   - `iota`用作枚举值
        * 第一个 iota 等于 0，每当 iota 在新的一行被使用时，它的值都会自动加 1
        * 简单地讲，每遇到一次 const 关键字，iota 就重置为 0
### 1.4 变量
#### 1.4.1 简介
1. `var`关键字
```go
//声明变量将变量类型放在变量之后
var idetifier type
//定义变量组  因式分解关键字
var (
    a int
    b bool
    str string
)
```
2. 指针类型
```go
var a,b *int
```
3. 命名
   - 变量的命名规则遵循`骆驼命名法`，即首个单词小写，每个新单词的首字母大写，例如：numShips 和 startDate
4. 作用域
   - 全局变量
        - 函数体外定义（若要外包也能访问，首字母大写）
   - 局部变量
        - 函数体内定义
5. 声明并初始化
```go
var identifer [type]=value
var a int =5
```
6. 类型自动推断
* 编译器在编译时自动推断类型
```go
//自动推断类型
var a=19
var b=false
var str="abc"
//或
var (
    a=18
    b=false
    str="abs"
)
```
* 在运行时自动推断类型
```go
var (
    HOME=os.Getenv("HOME")
    USER=os.Getenv("USER")
)
```
7. 简短声明 `:=`
```go
 a:=1
```
#### 1.4.2 值类型和引用类型
程序中所用到的内存在计算机中使用一堆箱子来表示（这也是人们在讲解它的时候的画法），这些箱子被称为 `字`。
根据不同的处理器以及操作系统类型，所有的字都具有 32 位（4 字节）或 64 位（8 字节）的相同长度；
所有的字都使用相关的内存地址来进行表示（以`十六进制`数表示）。
* 值类型：
    * `int` `float` `bool` `string` 值类型，使用这些类型指向内存中的值
    * 数组`array`和结构`struct`也是值类型
    * `=`赋值是值的拷贝
* 引用类型：
    * `指针` `slice` `map` `channel`
    * 保存的为内存地址
    * `&`进行变量的内存地址获取，内存地址也称之为 指针，指针也被另外保存在一个字中
    * `r1=r2`当赋值为地址时，改变一个变量的指向另一个也改变
#### 1.4.3 打印
```go
func Printf(format string, list of variables to be printed)
//格式化字符串
这个格式化字符串可以含有一个或多个的格式化标识符
例如：%..，其中 .. 可以被不同类型所对应的标识符替换，
如 %s 代表字符串标识符、%v 代表使用类型的默认输出格式的标识符。
```
#### 1.4.4 简短形式
* :=赋值操作符
#### 1.4.5 init函数
* 每个源文件值包含一个 `init（）` 函数
* 变量除了可以在全局声明中初始化，也可以在 init 函数中初始化。
* 完成初始化后自动执行，按照包的依赖关系自动执行
### 1.5 基本类型和运算符
#### 1.5.1 布尔类型bool
* 