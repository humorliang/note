## 数组和切片
### 声明和初始化
#### 概念
- 数组是具有相同 `唯一类型` 的一组已编号且长度固定的数据项序列（这是一种同构的数据结构）；
- 格式声明：
```go
var identifier [len]type
```

#### 数组常量
1. 定义方式
- 第一种
```go
var arrAge = [5]int{18, 20, 15, 22, 16}
```
- 第二种不定长数组
```go
var arrLazy = [...]int{5, 6, 7, 8, 22}
```
- 第三种：`key: value syntax`
```go
var arrKeyValue = [5]string{3: "Chris", 4: "Ron"}
```
#### 多维数组
- 数组通常是一维的，但是可以用来组装成多维数组，例如：[3][5]int，[2][2][2]float64。
```go
package main
const (
	WIDTH  = 1920
	HEIGHT = 1080
)

type pixel int
var screen [WIDTH][HEIGHT]pixel

func main() {
	for y := 0; y < HEIGHT; y++ {
		for x := 0; x < WIDTH; x++ {
			screen[x][y] = 0
		}
	}
}
```

#### 数组传递给函数
- 传递数组的指针
- 使用数组的切片

### 切片
#### 概念
- 切片（slice）是对数组一个连续片段的引用（该数组我们称之为相关数组，通常是匿名的），所以切片是一个引用类型
- 格式：
    - 声明切片的格式是： `var identifier []type`（不需要说明长度）
    - 切片的初始化格式是：`var slice1 []type = arr1[start:end]`。

#### 将切片传递给函数
```go
func sum(a []int) int {
	s := 0
	for i := 0; i < len(a); i++ {
		s += a[i]
	}
	return s
}

func main() {
	var arr = [5]int{0, 1, 2, 3, 4}
	sum(arr[:])
}
```
#### 用make()创建一个切片
* 创建切片
	- `var slice1 []type = make([]type, len)`
	- `slice1 := make([]type, len)`

#### new()和make()的区别
* new函数分配内存，make函数初始化
	- new(T) 为每个新的类型T分配一片内存，初始化为 0 并且返回类型为*T的内存地址：这种方法 返回一个指向类型为 T，值为 0 的地址的指针，它适用于值类型如数组和结构体；它相当于 &T{}。
	- make(T) 返回一个类型为 T 的初始值，它只适用于3种内建的引用类型：切片、map 和 channel

#### bytes包
- 类型 []byte 的切片十分常见，Go 语言有一个`bytes包`专门用来解决这种类型的操作方法。

- 长度可变的bytes的buffer，提供Read和Write方法，
	定义：
	- `var buffer bytes.Buffer`
	- `var r *bytes.Buffer=new(bytes.Buffer)`
- 我们创建一个 buffer，通过 buffer.WriteString(s) 方法将字符串 s 追加到后面，最后再通过 buffer.String() 方法转换为 string
```go
var buffer bytes.Buffer
for {
	if s, ok := getNextString(); ok { //method getNextString() not shown here
		buffer.WriteString(s)
	} else {
		break
	}
}
fmt.Print(buffer.String(), "\n")
```
### For-range结构
* 遍历
```go
for ix, value := range slice1 {
	...
}
```
### 切片重组
- 改变切片长度的过程称之为切片重组 reslicing
	`slice1 = slice1[0:end]`

### 切片的复制和追加
```go
	sl_from := []int{1, 2, 3}
	sl_to := make([]int, 10)

	n := copy(sl_to, sl_from) //切片的复制
	fmt.Println(sl_to)
	fmt.Printf("Copied %d elements\n", n) // n == 3

	sl3 := []int{1, 2, 3}
	sl3 = append(sl3, 4, 5, 6) //切片的追加
	fmt.Println(sl3)
```

### 字符串、数组、切片的应用
#### 从字符串生成字节切片
- `c := []byte(s)` 来获取一个字节的切片 c
- `copy(dst []byte, src string)`
#### 获取字符串的某一部分
- `substr := str[start:end]`
#### 字符串和切片的内存结构
- 在内存中，一个字符串实际上是一个双字结构，即一个指向实际数据的指针和记录字符串长度的整数
#### 修改字符串中的某个字符
```go
s := "hello"
c := []byte(s)
c[0] = 'c'
s2 := string(c) // s2 == "cello"
```
#### 字节数组比较函数
```go
func Compare(a, b[]byte) int {
    for i:=0; i < len(a) && i < len(b); i++ {
        switch {
        case a[i] > b[i]:
            return 1
        case a[i] < b[i]:
            return -1
        }
    }
    // 数组的长度可能不同
    switch {
    case len(a) < len(b):
        return -1
    case len(a) > len(b):
        return 1
    }
    return 0 // 数组相等
}
```