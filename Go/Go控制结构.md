## 控制结构
### if-else结构
- 结构形式
```go 
// 只有if没有else
if condition {
	// do something	
}
// if else
if condition {
	// do something	
} else {
	// do something	
}
```
- 注意事项
    - 不能同时在if-else结构都使用 return语句，否则编译错误
- 常用操作
    - 判断字符是否为空
        ```go
        if str == "" { ... }
        if len(str) == 0 {...}
        ```
    - 判断操作系统类型
        ```go
        if runtime.GOOS == "windows"	 {
            .  ..
        } else { // Unix-like
            .	..
        }
        ```
    - if结构声明的作用域
        ```
        使用简短方式 := 声明的变量的作用域只存在于 if 结构中（在 if 结构的大括号之间，如果使用 if-else 结构则在 else 代码块中变量也会存在）
        ```
- if 可以包含一个初始化语句（如：给一个变量赋值）
    ```go
    if initialization; condition {
	// do something
    }
    ```
### 测试多返回值函数的错误
- go函数使用两个返回值来表示是否成功
    ```
        返回某个值以及 true 表示成功；返回零值（或 nil）和 false 表示失败。当不使用 true 或 false 的时候，也可以使用一个 error 类型的变量来代替作为第二个返回值：成功执行的话，error 的值为 nil，否则就会包含相应的错误信息（error: var err error）。这样一来，就很明显需要用一个 if 语句来测试执行结果；由于其符号的原因，这样的形式又称之为 comma,ok 模式（pattern）。
    ```
    - if判断错误
    ```go
        an, err := strconv.Atoi(orig)
        if err != nil {
            fmt.Printf("orig %s is not an integer - exiting with error\n", orig)
            return
        } 
    ```

### switch结构
- 接受任意形式表达式
    ```go
        switch var1 {
        case val1:
            ...
        case val2:
            ...
        default:
            ...
        }
    ```
- 表达式要求
    ```
    变量 var1 可以是任何类型，而 val1 和 val2 则可以是同类型的任意值。类型不被局限于常量或整数，但必须是相同的类型；或者最终结果为相同类型的表达式。
    ```
- 从上至下逐一测试，直到匹配为止,匹配到退出，不需要特别使用 break 语句来表示结束。
- fallthrough关键字
    - 如果在执行完每个分支的代码后，继续执行后续分支的代码
- 常见几种形式
```go
package main

import (
    "fmt"
    "time"
)

func main() {

    i := 2
    fmt.Print("Write ", i, " as ")
    //常见形式
    switch i {
    case 1:
        fmt.Println("one")
    case 2:
        fmt.Println("two")
    case 3:
        fmt.Println("three")
    }
    //case 多个判断,用分割符分割  两者之间是 或 的关系
    switch time.Now().Weekday() {
    case time.Saturday, time.Sunday:
        fmt.Println("It's the weekend")
    default:
        fmt.Println("It's a weekday")
    }

    t := time.Now()
    //没有表达式的 switch 可以代替 if else 的功能
    switch {
    case t.Hour() < 12:
        fmt.Println("It's before noon")
    default:
        fmt.Println("It's after noon")
    }

    whatAmI := func(i interface{}) {
        // 起类型判断的作用 对接口进行类型判断
        switch t := i.(type) {
        case bool:
            fmt.Println("I'm a bool")
        case int:
            fmt.Println("I'm an int")
        default:
            fmt.Printf("Don't know type %T\n", t)
        }
    }
    whatAmI(true)
    whatAmI(1)
    whatAmI("hey")
}
```
### for结构
1. 基于计数器的迭代
```go
for 初始化语句; 条件语句; 修饰语句 {}
```
2. 多个计数器
```go
for i, j := 0, N; i < j; i, j = i+1, j-1 {}
```
3. 基于条件判断的迭代
```go
for 条件语句 {}
// 示例
for i >= 0 {
		i = i - 1
		fmt.Printf("The variable i is now: %d\n", i)
	}
```
4. 无限循环
```go
//形式
for { }
// 退出想要直接退出循环体，可以使用 break 语句或 return 语句直接返回。

// 但这两者之间有所区别，break 只是退出当前的循环体，而 return 语句提前对函数进行返回，不会执行后续的代码。
```
```go
// 应用：无限循环的经典应用是服务器，用于不断等待和接受新的请求
for t, err = p.Token(); err == nil; t, err = p.Token() {
	...
}
```
5. for-range结构
```go
//它可以迭代任何一个集合（包括数组和 map)
for ix, val := range coll { 
    //do something
}
//如果 val 为指针，则会产生指针的拷贝，依旧可以修改集合中的原值）。
//一个字符串是 Unicode 编码的字符（或称之为 rune）集合，因此您也可以用它迭代字符串
```
### break与continue
- break关键字
```
一个 break 的作用范围为该语句出现后的最内部的结构，它可以被用于任何形式的 for 循环（计数器、条件判断等）。
但在 switch 或 select 语句中，break 语句的作用结果是跳过整个代码块，执行后续的代码。
```
- continue关键字
```
关键字 continue 忽略剩余的循环体而直接进入下一次循环的过程，但不是无条件执行下一次循环，执行之前依旧需要满足循环的判断条件。
```
### 标签与go
- or、switch 或 select 语句都可以配合标签（label）形式的标识符使用
```go
//标签
LABEL1:
	for i := 0; i <= 5; i++ {
		for j := 0; j <= 5; j++ {
			if j == 4 {
				continue LABEL1
			}
			fmt.Printf("i is: %d, and j is: %d\n", i, j)
		}
	}
```
- 还可以使用 goto 语句和标签配合使用来模拟循环
```go
i:=0
HERE:
    print(i)
    i++
    if i==5 {
        return
    }
    goto HERE
```