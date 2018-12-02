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
* 布尔类型的值只能是 常量 `true` 和 `false`
* `==`、`！=`、非`!`、与`&&`、或`||`获取布尔值

#### 1.5.2 数字类型
1. 整数和浮点型
* Go基于架构的类型（由操作系统决定32位和64位） ：
    * `int` : 32位 4字节  64位 8字节
    * `uint` : 无符号位 32位 4字节  64位 8字节
    * `uintptr` : 长度足够存放一个指针
* 与系统架构无关的系统类型，固定大小
    - 整数：
        int8（-128 -> 127）
        int16（-32768 -> 32767）
        int32（-2,147,483,648 -> 2,147,483,647）
        int64（-9,223,372,036,854,775,808 -> 9,223,372,036,854,775,807）
    - 无符号整数：
        uint8（0 -> 255）
        uint16（0 -> 65,535）
        uint32（0 -> 4,294,967,295）
        uint64（0 -> 18,446,744,073,709,551,615）
    - 浮点型（IEEE-754 标准）：
        float32（+- 1e-45 -> +- 3.4 * 1e38） //小数点后7位
        float64（+- 5 * 1e-324 -> 107 * 1e308 //小数点后15位
* 精度丢失
    - 大范围转化为小范围
2. 复数
* 复数类型
    ```go
    complex64 (32位实数和虚数)
    complex128 (64位实数和虚数)
    ```
3. 位运算
   - 按位与`&`
        ```
        1 & 1 -> 1
        1 & 0 -> 0
        0 & 1 -> 0
        0 & 0 -> 0
        ```
   - 按位或`|`
        ```
        1 | 1 -> 1
        1 | 0 -> 1
        0 | 1 -> 1
        0 | 0 -> 0
        ```
   - 按位异或`^`
        ```
        1 ^ 1 -> 0
        1 ^ 0 -> 1
        0 ^ 1 -> 1
        0 ^ 0 -> 0
        ```
   - 位清除 `&^`
        ```
        将指定位置上的值设置为 0
        ```
   - 左移`<<`
        ```
            1 << 10 // 等于 1 KB
            1 << 20 // 等于 1 MB
            1 << 30 // 等于 1 GB
        ```
   - 右移`>>`
        ```
        bitP 的位向右移动 n 位，左侧空白部分使用 0 填充；如果 n 等于 2，则结果是当前值除以 2 的 n 次方
        ```
4. 逻辑运算符
    `==`、`!=`、`<`、`<=`、`>`、`>=`
5. 算术运算符
   `+`、`-`、`*`、`/`
6. 随机数
   - `rand`包实现伪随机数 [0,n)
#### 1.5.3 运算符优先级
- 由上到下，由高到低
    ```go
    优先级 	        运算符
    7 		^ !
    6 		* / % << >> & &^
    5 		+ - | ^
    4 		== != < <= >= >
    3 		<-
    2 		&&
    1 		||
    ```
#### 1.5.4 类型别名
* `type TZ int` int新的名称
#### 1.5.5 字符类型
* 理解：
    严格来说，这并不是 Go 语言的一个类型，字符只是整数的特殊用例。
    byte 类型是 uint8 的别名，对于只占用 1 个字节的传统 ASCII 编码的字符来说，完全没有问题。
    `var ch byte='A'`
* ASCII码（占用一个字节）
    ```go
    var ch byte=65或 var ch byte='\x41' //（\x 总是紧跟着长度为 2 的 16 进制数）
    var ch byte='\377'
    //\ 后面紧跟着长度为 3 的八进制数，例如：\377
    ```
* Unicode（utf-8）编码（\u 加上四位十六进制）
    ```go
    var ch int = '\u0041'
    var ch2 int = '\u03B2'
    var ch3 int = '\U00101234'
    fmt.Printf("%d - %d - %d\n", ch, ch2, ch3) // integer
    fmt.Printf("%c - %c - %c\n", ch, ch2, ch3) // character
    fmt.Printf("%X - %X - %X\n", ch, ch2, ch3) // UTF-8 bytes
    fmt.Printf("%U - %U - %U", ch, ch2, ch3) // UTF-8 code point
    ```

### 1.6 字符串

#### 大小
- 字符串是 UTF-8 字符的一个序列（当字符为 ASCII 码时则占用 1 个字节，其它字符根据需要占用 2-4 个字节）
#### 字面值
- 解释字符串：
    该类字符串使用双引号`""`括起来，其中的相关的转义字符将被替换，这些转义字符包括：
    \n：换行符
    \r：回车符
    \t：tab 键
    \u 或 \U：Unicode 字符
    \\：反斜杠自身
- 非解释字符串：
    该类字符串使用反引号 `` 括起来，支持换行，例如：
    \`This is a raw string \n\` 中的 \`\n\` 会被原样输出。
#### 字符串内容获取
```
字符串的内容（纯字节）可以通过标准索引法来获取，在中括号 [] 内写入索引，索引从 0 开始计数：
    字符串 str 的第 1 个字节：str[0]
    第 i 个字节：str[i - 1]
    最后 1 个字节：str[len(str)-1]
需要注意的是，这种转换方案只对纯 ASCII 码的字符串有效。
```
#### 字符串拼接符 `+`
- 两个字符串 s1 和 s2 可以通过 s := s1 + s2 拼接在一起。

### 1.7 strings和strconv包

#### 1.7.1 前缀和后缀
```go
//HasPrefix 判断字符串 s 是否以 prefix 开头
strings.HasPrefix(s, prefix string) bool
//HasSuffix 判断字符串 s 是否以 suffix 结尾
strings.HasSuffix(s, suffix string) bool
```
#### 1.7.2 字符串包含关系
```go
//Contains 判断字符串 s 是否包含 substr
strings.Contains(s, substr string) bool
```
#### 1.7.3 子字符或字串在父字符串的位置
```go
//返回字符串 str 在字符串 s 中的索引（str 的第一个字符的索引），-1 表示字符串 s 不包含字符串 str
strings.Index(s, str string) int
//返回字符串 str 在字符串 s 中最后出现位置的索引（str 的第一个字符的索引），-1 表示字符串 s 不包含字符串 str
strings.LastIndex(s, str string) int
//非 ASCII 编码的字符在父字符串中的位置
strings.IndexRune(s string, r rune) int
```
#### 1.7.4 字符串替换
```go
//用于将字符串 str 中的前 n 个字符串 old 替换为字符串 new，并返回一个新的字符串，
//如果 n = -1 则替换所有字符串 old 为字符串 new
strings.Replace(str, old, new, n) string
```
#### 1.7.5 统计字符串出现次数
```go
//str 在字符串 s 中出现的非重叠次数
strings.Count(s, str string) int
```
#### 1.7.6 重复字符串
```go
//重复 count 次字符串 s 并返回一个新的字符串
strings.Repeat(s, count int) string
```
#### 1.7.7 改字符串大小写
```go
//全部转为小写
strings.ToLower(s) string
//全部转为大写
strings.ToUpper(s) string
```
#### 1.7.8 修剪字符串
```go
//剔除字符串开头和结尾的空白符号
strings.TrimSpace(s)
//将开头和结尾的 cut 去除掉
strings.Trim(s, "cut")
//剔除开头或者结尾的字符串
strings.TrimLeft()
strings.TrimRight()
```
#### 1.7.9 分割字符串
```go
//将会利用 1 个或多个空白符号来作为动态长度的分隔符将字符串分割成若干小块，并返回一个 slice
strings.Fields(s)
//自定义分割符号来对指定字符串进行分割，返回 slice
strings.Split(s, sep)
```
#### 1.7.10 拼接slice到字符串
```go
//将元素类型为 string 的 slice 使用分割符号来拼接组成一个字符串
strings.Join(sl []string, sep string) string
```
#### 1.7.11 字符串中读取内容
```go
//生成一个 Reader 并读取字符串中的内容，然后返回指向该 Reader 的指针，
strings.NewReader(str)
//从其它类型读取内容的函数
//从 []byte 中读取内容
strings.Read()
//从字符串中读取下一个 byte 或者 rune
strings.ReadByte()和strings.ReadRune()

```
#### 1.7.12 字符串与其他类型转换
```go
//返回数字 i 所表示的字符串类型的十进制数。
strconv.Itoa(i int) string
//将 64 位浮点型的数字转换为字符串，其中 fmt 表示格式（其值可以是 'b'、'e'、'f' 或 'g'），
//prec 表示精度，bitSize 则使用 32 表示 float32，用 64 表示 float64。
strconv.FormatFloat(f float64, fmt byte, prec int, bitSize int) string
```
### 1.8 时间和日期
- `time` 包为我们提供了一个数据类型 `time.Time`（作为值使用）以及显示和测量时间和日期的功能函数
- 当前时间
  ```go
    time.Now()
  ```
- 获取时间一部分
  ```go
    t.Day()
    t.Minute()
  ```
- 时间差
  ```go
    week = 60 * 60 * 24 * 7 * 1e9 // must be in nanosec
    t.Add(time.Duration(week))
  ```
- 自定义时间字符串
  ```go
    //预定义的格式，如：time.ANSIC 或 time.RFC822
    func (t Time) Format(layout string) string
  ```
### 1.9 指针
#### 定义
- 内存：程序在内存中存储它的值，每个内存块（或字）有一个地址，通常用十六进制数表示，如：0x6b0820 或 0xf84001d7f0
- Go 语言的取地址符是 `&`，放到一个变量前使用就会返回相应变量的内存地址
- 这个地址可以存储在一个叫做`指针`的`特殊数据类型`
- 调用指针 intP，我们可以这样声明它：`var intP *int`
- 指针的格式化标识符为` %p`
- 一个`指针变量`可以指向任何一个值的`内存地址`它指向那个值的内存地址，
  在 32 位机器上占用 4 个字节，在 64 位机器上占用 8 个字节，并且与它所指向的值的`大小无关`
  ```go
    var i=5  //定义一个变量并初始化
    var intP *int  //定义一个int类型指针
    intp=&i //intP指向i内存地址，引用i变量
  ```
- 一个指针被定义后没有分配到任何变量时，它的值为 `nil`
#### 注意事项
- 符号 * 可以放在一个指针前，如 *intP，得到这个指针指向地址上所存储的值；这被称为反引用（或者内容或者间接引用）操作符；另一种说法是指针转移
- 指针变量*ptr赋新值
    ```go
        s := "good bye"
        var p *string = &s  //定义一个p指针 并将其指向 s的内存地址
        *p = "ciao" //将p指针指向的值变为 “cicao”
        fmt.Printf("Here is the pointer p: %p\n", p) // prints address
        fmt.Printf("Here is the string *p: %s\n", *p) // prints string  cicao
        fmt.Printf("Here is the string s: %s\n", s) // prints same string cicao
    ```
- 不能获取文字或常量地址
- Go不能进行指针运算 `c=*p++`
- 不能使用空指针的反向引用
    ```go
        var p *int = nil
	    *p = 0
    ```