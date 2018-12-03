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