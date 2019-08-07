## 结构(struct)与方法(method)
- Go 通过类型别名（alias types）和结构体的形式支持用户自定义类型，或者叫定制类型。
- 组成结构体类型的那些数据称为 字段（fields）
### 结构体定义
1. 定义
```go 
type identifier struct {
    field1 type1
    field2 type2
}
```
- 类型：结构体的字段可以是任何类型，甚至是结构体本身，也可以是函数或者接口
- 点号符：`structname.fieldname`
2. 选择器
```
无论变量是一个结构体类型还是一个结构体类型指针，都使用同样的 选择器符（selector-notation） 来引用结构体的字段
```
```go
type myStruct struct { i int }
var v myStruct    // v是结构体类型变量
var p *myStruct   // p是指向一个结构体类型变量的指针
v.i
p.i
```
3. 初始化
```go
//第一种
ms := &struct1{10, 15.5, "Chris"}
// 此时ms的类型是 *struct1

//第二种
var ms struct1
ms = struct1{10, 15.5, "Chris"}

//第三种 混合字面
intr := Interval{0, 3}            
intr := Interval{end:5, start:1}  
intr := Interval{end:5}           
```
#### 结构体的内存布局
```go
type Rect1 struct {Min, Max Point }
type Rect2 struct {Min, Max *Point }
```
#### 递归结构体
- 单向链表
```go
type Node struct {
    data    float64
    su      *Node
}
```
- 双向链表
```go
type Node struct {
    pr      *Node
    data    float64
    su      *Node
}
```
- 二叉树
```go
type Tree strcut {
    le      *Tree
    data    float64
    ri      *Tree
}
```
### 带标签的结构体
结构体中的字段除了有名字和类型外，还可以有一个可选的`标签（tag）`：它是一个附属于字段的字符串，可以是文档或其他的重要标记。标签的内容不可以在一般的编程中使用，只有包 `reflect` 能获取它。
```go
type TagType struct { 
    // tags
	field1 bool   "bool tages"
	field2 string "string tages"
	field3 int    "int tages"
}
```

### 匿名字段内嵌结构体
结构体可以包含一个或多个 `匿名（或内嵌）字段`，即这些字段没有显式的名字，只有字段的类型是必须的，此时类型就是字段的名字。匿名字段本身可以是一个结构体类型，即 `结构体可以包含内嵌结构体`。
```go
type innerS struct {
	in1 int
	in2 int
}

type outerS struct {
	b    int
	c    float32
	int  // anonymous field
	innerS //anonymous field
}
```
### 方法
Go 方法是作用在`接收者（receiver）`上的一个函数，接收者是某种类型的变量。因此方法是一种特殊类型的函数。
- 一个类型加上它的`方法`等价于面向对象中的一个类。
- 类型 T（或 *T）上的所有方法的集合叫做类型 T（或 *T）的方法集。
```go
func (a *denseMatrix) Add(b Matrix) Matrix
func (a *sparseMatrix) Add(b Matrix) Matrix
```
####  定义方法的一般格式
```go
func (recv receiver_type) methodName(parameter_list) (return_value_list) { ... }
```
```
如果 recv 是 receiver 的实例，Method1 是它的方法名，那么方法调用遵循传统的 object.name 选择器符号：recv.Method1()。
如果 recv 是一个指针，Go 会 自动解引用
```
#### 函数和方法区别
```
函数将变量作为参数：Function1(recv)
方法在变量上被调用：recv.Method1()
```

#### 接收者为指针或值
`recv` 最常见的是一个指向 `receiver_type` 的指针（因为我们不想要一个实例的拷贝，如果按值调用的话就会是这样），特别是在 `receiver` 类型是结构体时，就更是如此了。
如果想要方法`改变` `接收者`的数据，就在接收者的`指针类型`上定义该方法。否则，就在普通的值类型上定义方法。
```go
type B struct {
	thing int
}

func (b *B) change() { b.thing = 1 } //接受者为指针可以改变数据类型
func (b B) write() string { return fmt.Sprint(b) }

func main() {
	var b1 B   // b1是值  有一点对象实例化的意味
	b1.change()  //相当于对象实例化后操作
	fmt.Println(b1.write())

	b2 := new(B) // b2是指针
	b2.change()
	fmt.Println(b2.write())
}
```
- 指针方法和值方法都可以在指针或非指针上被调用。
- 方法的理解
```
如果命名类型T(译注：用type xxx定义的类型)的所有方法都是用T类型自己来做接收器(而不是*T)，那么拷贝这种类型的实例就是安全的；调用他的任何一个方法也就会产生一个值的拷贝。比如time.Duration的这个类型，在调用其方法时就会被全部拷贝一份，包括在作为参数传入函数的时候。但是如果一个方法使用指针作为接收器，你需要避免对其进行拷贝，因为这样可能会破坏掉该类型内部的不变性。比如你对bytes.Buffer对象进行了拷贝，那么可能会引起原始对象和拷贝对象只是别名而已，但实际上其指向的对象是一致的。紧接着对拷贝后的变量进行修改可能会有让你意外的结果。

其实有两点：

不管你的method的receiver是指针类型还是非指针类型，都是可以通过指针/非指针类型进行调用的，编译器会帮你做类型转换。
在声明一个method的receiver该是指针还是非指针类型时，你需要考虑两方面的内部，第一方面是这个对象本身是不是特别大，如果声明为非指针变量时，调用会产生一次拷贝；第二方面是如果你用指针类型作为receiver，那么你一定要注意，这种指针类型指向的始终是一块内存地址，就算你对其进行了拷贝。熟悉C或者C艹的人这里应该很快能明白
```

#### 多重继承
```go
type Camera struct{}
type Phone struct{}
type CameraPhone struct {
	Camera
	Phone
}
```