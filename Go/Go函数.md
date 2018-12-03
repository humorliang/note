## 函数
### 简介

* 函数分类
    - 普通的带有名字的函数
    - 匿名函数
    - 方法（Methods）
    - main()、init()函数不能有参数和返回值

### 函数参数与返回值
- 在函数块里面，return 之后的语句都不会执行。如果一个函数需要返回值，那么这个函数里面的每一个代码分支（code-path）都要有 return 语句。
1. 按值传递、按引用传递
    - 使用按值传递来传递参数，也就是传递参数的副本。
    - 将参数的地址（变量名前面添加&符号，比如 &variable）传递给函数，这就是按引用传递
- 指针也是变量类型，有自己的地址和值，通常指针的值指向一个变量的地址。所以，按引用传递也是按值传递
2. 默认作为引用类型
    `切片（slice）`、`字典（map）`、`接口（interface）`、`通道（channel）`
3. 空白符
- 空白符 `_` 用来匹配一些不需要的值，然后丢弃掉
4. 改变外部变量
- 传递指针给函数不但可以节省内存（因为没有复制变量的值），而且赋予了函数直接修改外部变量的能力，所以被修改的变量不再需要使用 return 返回。
### 变长参数
函数的最后一个参数是采用 `...type` 的形式，那么这个函数就可以处理一个变长的参数，这个长度可以为 0，这样的函数称为变参函数。
```go
//接受一个类似某个类型的 slice 的参数
func myFunc(a, b, arg ...int) {
    fmt.Println(arg...)//使用需要带 ...
}
```
- 不同类型多个参数
1. 使用结构
```go
//结构体
type Options struct {
	par1 type1,
	par2 type2,
	...
}
//没有初始化
F1(a, b, Options {})
//初始化
F1(a, b, Options {par1:val1, par2:val2})
```
2. 使用空接口
    - 如果一个变长参数的类型没有被指定，则可以使用默认的空接口 interface{}，这样就可以接受任何类型的参数
    ```go
        func typecheck(..,..,values … interface{}) {
            for _, value := range values {
                switch v := value.(type) {
                    case int: …
                    case float: …
                    case string: …
                    case bool: …
                    default: …
                }
            }
        }
    ```
### defer和追踪
#### 理解
```
    关键字 defer 允许我们推迟到函数返回之前（或任意位置执行 return 语句之后）一刻才执行某个语句或函数
```
#### 场景
1. 关闭文件流
```go
// open a file  
defer file.Close()
```
2. 解锁一个加锁的资源
```go
mu.Lock()  
defer mu.Unlock() 
```
3. 打印最终报告
```go
printHeader()  
defer printFooter()
```
4. 关闭数据库连接
```go
// open a database connection  
defer disconnectFromDB()
```
#### FILO
- 多个defer语句按照栈的形式进行调用

### 内置函数
- close
    - 关闭通道
- len、cap
    - 长度，最大容量
- new、make
    - 分配内存，new返回指针
- copy、append
- panic、recover
- print、println
- complex、real imag
### 递归函数
- 当一个函数在其函数体内调用自身，则称之为递归。
```go
func fibonacci(n int) (res int) {
	if n <= 1 {
		res = 1
	} else {
		res = fibonacci(n-1) + fibonacci(n-2)
	}
	return
}
```

### 函数作为参数
- 函数可以作为其它函数的参数进行传递，然后在其它函数内调用执行，一般称之为回调。
```go
package main
import (
	"fmt"
)
func main() {
	callback(1, Add)
}
func Add(a, b int) {
	fmt.Printf("The sum of %d and %d is: %d\n", a, b, a+b)
}
//回调
func callback(y int, f func(int, int)) {
	f(y, 2) // this becomes Add(1, 2)
}
```

### 闭包
#### 匿名函数
- 不能独立存在
- 可以赋值给某个变量
#### 闭包
```go
func f() {
	for i := 0; i < 4; i++ {
		g := func(i int) { fmt.Printf("%d ", i) } //此例子中只是为了演示匿名函数可分配不同的内存地址，在现实开发中，不应该把该部分信息放置到循环中。
		g(i)
		fmt.Printf(" - g is of type %T and has value %v\n", g, g)
	}
}()
```

### 内存缓存
- 通过在内存中缓存和重复利用相同计算的结果，称之为内存缓存
```go
func fibonacci(n int) (res uint64) {
	// memoization: check if fibonacci(n) is already known in array:
	if fibs[n] != 0 {
		res = fibs[n]
		return
	}
	if n <= 1 {
		res = 1
	} else {
		res = fibonacci(n-1) + fibonacci(n-2)
	}
	fibs[n] = res
	return
}
```





