## Go接口和反射
### 接口含义
- 一组方法的集合（只有定义没有具体实现）
- 格式：
```go
type Namer interface {
    Method1(param_list) return_type
    Method2(param_list) return_type
}
```
- 接口类型
```go
一个接口类型的变量或一个 接口值 ：var ai Namer，ai 是一个多字（multiword）数据结构，它的值是 nil。
```
- 只要类型实现了接口中的方法，它就实现了此接口。
```go
//定义一个接口
type Shaper interface {
	Area() float32
}
//定义一个类型
type Square struct {
	side float32
}
//这个类型实现了接口中的方法  也就实现了该接口
func (sq *Square) Area() float32 {
	return sq.side * sq.side
}

func main() {
    //实例化类型
	sq1 := new(Square)
	sq1.side = 5
    //声明接口变量
	var areaIntf Shaper
    //接口变量指向变量引用
	areaIntf = sq1
	fmt.Printf("The square has area: %f\n", areaIntf.Area())
}
```
### 接口嵌套接口
```go
type ReadWrite interface {
    Read(b Buffer) bool
    Write(b Buffer) bool
}

type Lock interface {
    Lock()
    Unlock()
}

type File interface {
    ReadWrite
    Lock
    Close()
}
```
### 类型断言：如何检测和转换接口变量
一个接口类型的变量 varI 中可以包含任何类型的值，必须有一种方式来检测它的 动态 类型，即运行时在变量中存储的值的实际类型。
- varI 必须是一个接口变量，否则编译器会报错
```go
v := varI.(T)       // unchecked type assertion
```
- `v` 是 `varI `转换到类型 `T` 的值，`ok `会是 `true`；否则 `v `是类型` T `的零值，`ok` 是 `false`，也没有运行时错误发生。
```go
if v, ok := varI.(T); ok {  // checked type assertion
    Process(v)
    return
}
// varI is not of type T
```
### 类型判断
```go
switch t := areaIntf.(type) {
case *Square:
	fmt.Printf("Type Square %T with value %v\n", t, t)
case *Circle:
	fmt.Printf("Type Circle %T with value %v\n", t, t)
case nil:
	fmt.Printf("nil value: nothing to check?\n")
default:
	fmt.Printf("Unexpected type %T\n", t)
}
```
### 测试是否实现了某接口
```go
// 假设 v 是一个值
type Stringer interface {
    String() string
}

if sv, ok := v.(Stringer); ok {
    fmt.Printf("v implements String(): %s\n", sv.String()) // note: sv, not v
}
```

### 方法集和接口
```
Go 语言规范定义了接口方法集的调用规则：
    类型 *T 的可调用方法集包含接受者为 *T 或 T 的所有方法集
    类型 T 的可调用方法集包含接受者为 T 的所有方法
    类型 T 的可调用方法集不包含接受者为 *T 的方法
```

### 空接口
- 任何其他类型都实现了空接口
```go
type Any interface {}
```
- 每个 interface {} 变量在内存中占据两个字长：一个用来存储它包含的类型，另一个用来存储它包含的数据或者指向数据的指针
```go
var any interface{}
//返回一个元组
any -> (type,val)
```
### 构建通用类型或包含不同类型变量的数组
```go
type Vector struct {
	a []Element
}
```
### 复制数据切片至空接口
- 显示的进行复制
```go
var dataSlice []myType = FuncReturnSlice()
var interfaceSlice []interface{} = make([]interface{}, len(dataSlice))
for i, d := range dataSlice {
    interfaceSlice[i] = d
}
```
### 通用类型的节点数据结构
- 定义中使用了一种叫节点的递归结构体类型，节点包含一个某种类型的数据字段。现在可以使用空接口作为数据字段的类型，这样我们就能写出通用的代码
```go
type Node struct {
	le   *Node
	data interface{}
	ri   *Node
}
```

### 2. 反射包
#### 方法和类型的反射
- 变量的最基本信息就是类型和值：反射包的 Type 用来表示一个 Go 类型，反射包的 Value 为 Go 值提供了反射接口
- `reflect.TypeOf` 和 `reflect.ValueOf`，返回被检查对象的类型和值

#### 通过反射设置和修改值
- 首先 `CanSet()`测试是否可设置
- `v.SetFloat()`

