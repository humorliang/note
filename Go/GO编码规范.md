#### 指导原则
- 指向 interface 的指针
```
1. 不需要要接口类型的指针，将指针作为值传递，传递过程中，实质上传递的底层数据仍然可以是指针。
接口实质上在底层用两个字段表示：
    一个指向某些特定类型信息的指针。您可以将其视为"type."
    数据指针。如果存储的数据是指针，则直接存储。如果存储的数据是一个值，则存储指向该值的指针
２．如果希望接口方法　修改　基础数据，则必须使用　指针　传递。
```
- 接收器 (receiver) 与接口
```go
// １．使用值接收器的方法既可以通过值调用，也可以通过指针调用。(值方法　值和指针都能使用)
// ２．使用指针的方法只能通过指针调用。(指针方法　只能指针调用)
type S struct {
  data string
}
func (s S) Read() string {
  return s.data
}
func (s *S) Write(str string) {
  s.data = str
}

sVals := map[int]S{1: {"A"}}
// 你只能通过值调用 Read
sVals[1].Read()

// 这不能编译通过：
//  sVals[1].Write("test")

sPtrs := map[int]*S{1: {"A"}}

// 通过指针既可以调用 Read，也可以调用 Write 方法
sPtrs[1].Read()
sPtrs[1].Write("test")
```
- 零值 Mutex 是有效的
```go
// sync.Mutex 和 sync.RWMutex 是有效的。因此你几乎不需要一个指向 mutex 的指针

// Bad　
mu := new(sync.Mutex)
mu.Lock()
// Good
var mu sync.Mutex
mu.Lock()

// 为私有类型或需要实现互斥接口的类型嵌入。
type smap struct {
  sync.Mutex // only for unexported types（仅适用于非导出类型）

  data map[string]string
}
func newSMap() *smap {
  return &smap{
    data: make(map[string]string),
  }
}
func (m *smap) Get(k string) string {
  m.Lock()
  defer m.Unlock()

  return m.data[k]
}

// 对于导出的类型，请使用专用字段。
type SMap struct {
  mu sync.Mutex // 对于导出类型，请使用私有锁

  data map[string]string
}
func NewSMap() *SMap {
  return &SMap{
    data: make(map[string]string),
  }
}
func (m *SMap) Get(k string) string {
  m.mu.Lock()
  defer m.mu.Unlock()
  return m.data[k]
}
```
- 在边界处拷贝 Slices 和 Maps
```go
// slices 和 maps 包含了指向底层数据的指针，因此在需要复制它们时要特别注意。
// 接收 Slices 和 Maps
// 请记住，当 map 或 slice 作为函数参数传入时，如果您存储了对它们的引用，则用户可以对其进行修改。
// Bad	
func (d *Driver) SetTrips(trips []Trip) {
  d.trips = trips
}
trips := ...
d1.SetTrips(trips)
// 你是要修改 d1.trips 吗？
trips[0] = ...

// Good
func (d *Driver) SetTrips(trips []Trip) {
  d.trips = make([]Trip, len(trips))
  copy(d.trips, trips)
}
trips := ...
d1.SetTrips(trips)
// 这里我们修改 trips[0]，但不会影响到 d1.trips
trips[0] = ...

// 返回 slices 或 maps
// 同样，请注意用户对暴露内部状态的 map 或 slice 的修改。

// Bad
type Stats struct {
  mu sync.Mutex

  counters map[string]int
}
// Snapshot 返回当前状态。
func (s *Stats) Snapshot() map[string]int {
  s.mu.Lock()
  defer s.mu.Unlock()

  return s.counters
}
// snapshot 不再受互斥锁保护
// 因此对 snapshot 的任何访问都将受到数据竞争的影响
// 影响 stats.counters
snapshot := stats.Snapshot()

// Good
type Stats struct {
  mu sync.Mutex
  counters map[string]int
}
func (s *Stats) Snapshot() map[string]int {
  s.mu.Lock()
  defer s.mu.Unlock()

  result := make(map[string]int, len(s.counters))
  for k, v := range s.counters {
    result[k] = v
  }
  return result
}
// snapshot 现在是一个拷贝
snapshot := stats.Snapshot()
```
- 使用 defer 做清理
```go
// 使用 defer 释放资源，诸如文件和锁。
```
- Channel 的 size 要么是 1，要么是无缓冲的
```go
// hannel 通常 size 应为 1 或是无缓冲的。默认情况下，channel 是无缓冲的，其 size 为零。
// 大小：1
c := make(chan int, 1) // 或者
// 无缓冲 channel，大小为 0
c := make(chan int)
```
- 枚举从 1 开始
```go
// 在 Go 中引入枚举的标准方法是声明一个自定义类型和一个使用了 iota 的 const 组。
// 由于变量的默认值为 0，因此通常应以非零值开头枚举。
type Operation int
const (
  Add Operation = iota + 1
  Subtract
  Multiply
)
// Add=1, Subtract=2, Multiply=3
```
- 错误类型
```go
// Go 中有多种声明错误（Error) 的选项：
//   errors.New 对于简单静态字符串的错误
//   fmt.Errorf 用于格式化的错误字符串
//   实现 Error() 方法的自定义类型
//   用 "pkg/errors".Wrap 的 Wrapped errors
// 返回错误时，请考虑以下因素以确定最佳选择：
//   这是一个不需要额外信息的简单错误吗？如果是这样，errors.New 足够了。
//   客户需要检测并处理此错误吗？如果是这样，则应使用自定义类型并实现该 Error() 方法。
//   您是否正在传播下游函数返回的错误？如果是这样，请查看本文后面有关错误包装 section on error wrapping 部分的内容。
//   否则 fmt.Errorf 就可以了。
//   如果客户端需要检测错误，并且您已使用创建了一个简单的错误 errors.New，请使用一个错误变量。
```
- 错误包装 (Error Wrapping)
```go
// 一个（函数/方法）调用失败时，有三种主要的错误传播方式：
    // 如果没有要添加的其他上下文，并且您想要维护原始错误类型，则返回原始错误。
    // 添加上下文，使用 "pkg/errors".Wrap 以便错误消息提供更多上下文 ,"pkg/errors".Cause 可用于提取原始错误。 Use fmt.Errorf if the callers do not need to detect or handle that specific error case.
    // 如果调用者不需要检测或处理的特定错误情况，使用 fmt.Errorf
```
- 处理类型断言失败
```go
// type assertion 的单个返回值形式针对不正确的类型将产生 panic。因此，请始终使用“comma ok”的惯用法。

//对接口进行类型断言
t, ok := i.(string)
if !ok {
  // 优雅地处理错误
}
```
- 不要 panic
```go
// 在生产环境中运行的代码必须避免出现 panic。panic 是 cascading failures 级联失败的主要根源 。如果发生错误，该函数必须返回错误，并允许调用方决定如何处理它。
func foo(bar string) error {
  if len(bar) == 0 {
    return errors.New("bar must not be empty")
  }
  // ...
  return nil
}
func main() {
  if len(os.Args) != 2 {
    fmt.Println("USAGE: foo <bar>")
    os.Exit(1)
  }
  if err := foo(os.Args[1]); err != nil {
    panic(err)
  }
}
```
- 使用 go.uber.org/atomic
```go
// 使用 sync/atomic 包的原子操作对原始类型 (int32, int64等）进行操作，因为很容易忘记使用原子操作来读取或修改变量。
// go.uber.org/atomic 通过隐藏基础类型为这些操作增加了类型安全性
type foo struct {
  running atomic.Bool
}
func (f *foo) start() {
  if f.running.Swap(true) {
     // already running…
     return
  }
  // start the Foo
}
func (f *foo) isRunning() bool {
  return f.running.Load()
}
```
#### 性能
- 优先使用 strconv 而不是 fmt
```go
// 将原语转换为字符串或从字符串转换时，strconv速度比fmt快。
for i := 0; i < b.N; i++ {
  s := strconv.Itoa(rand.Int())
}
```
- 避免字符串到字节的转换
```go
// 不要反复从固定字符串创建字节 slice。相反，请执行一次转换并捕获结果
// Bad	
for i := 0; i < b.N; i++ {
  w.Write([]byte("Hello world"))
}
// Good
data := []byte("Hello world")
for i := 0; i < b.N; i++ {
  w.Write(data)
}
```
- 尽量初始化时指定 Map 容量
```go
// 在尽可能的情况下，在使用 make() 初始化的时候提供容量信息
make(map[T1]T2, hint)
// 为 make() 提供容量信息（hint）尝试在初始化时调整 map 大小， 这减少了在将元素添加到 map 时增长和分配的开销。 
// 注意，map 不能保证分配 hint 个容量。因此，即使提供了容量，添加元素仍然可以进行分配。
var mp = make(map[string]int, 1)
mp["a"]=1
mp["b"]=2
mp["c"]=3
fmt.Println(mp)//map[a:1 b:1 c:1]
```
#### 规范
- 一致性
```
本文中概述的一些标准都是客观性的评估，是根据场景、上下文、或者主观性的判断；

但是最重要的是，保持一致.
一致性的代码更容易维护、是更合理的、需要更少的学习成本、并且随着新的约定出现或者出现错误后更容易迁移、更新、修复 bug

相反，一个单一的代码库会导致维护成本开销、不确定性和认知偏差。所有这些都会直接导致速度降低、 代码审查痛苦、而且增加 bug 数量

将这些标准应用于代码库时，建议在 package（或更大）级别进行更改，子包级别的应用程序通过将多个样式引入到同一代码中，违反了上述关注点。
```
- 相似的声明放在一组
```go
// Go 语言支持将相似的声明放在一个组内。
import (
  "a"
  "b"
)
// 这同样适用于常量、变量和类型声明：
const (
  a = 1
  b = 2
)
var (
  a = 1
  b = 2
)
type (
  Area float64
  Volume float64
)
// 分组使用的位置没有限制，例如：你可以在函数内部使用它们：
func f() string {
  var (
    red   = color.New(0xff0000)
    green = color.New(0x00ff00)
    blue  = color.New(0x0000ff)
  )
}
```
- import 组内的包导入顺序
```go
// 导入应该分为两组：
// 标准库
// 其他库
import (
  "fmt"
  "os"

  "go.uber.org/atomic"
  "golang.org/x/sync/errgroup"
)
```
- 包名
[包名指南](https://studygolang.com/articles/11823)
```go
// 当命名包时，请按下面规则选择一个名称：
//   全部小写。没有大写或下划线。
//   大多数使用命名导入的情况下，不需要重命名。
//   简短而简洁。请记住，在每个使用的地方都完整标识了该名称。
//   不用复数。例如net/url，而不是net/urls。
//   不要用“common”，“util”，“shared”或“lib”。这些是不好的，信息量不足的名称。
```
- 函数名
```go
// 我们遵循 Go 社区关于使用 MixedCaps 作为函数名 的约定。有一个例外，为了对相关的测试用例进行分组，函数名可能包含下划线，
//驼峰命名法
```
- 导入别名
```go
// 如果程序包名称与导入路径的最后一个元素不匹配，则必须使用导入别名。
import (
  "net/http"

  client "example.com/client-go"
  trace "example.com/trace/v2"
)
```
- 函数分组与顺序
```go
//     函数应按粗略的调用顺序排序。
//     同一文件中的函数应按接收者分组。
// 因此，导出的函数应先出现在文件中，放在struct, const, var定义的后面。

// 在定义类型之后，但在接收者的其余方法之前，可能会出现一个 newXYZ()/NewXYZ()
// 由于函数是按接收者分组的，因此普通工具函数应在文件末尾出现。

type something struct{ ... }

func newSomething() *something {
    return &something{}
}

func (s *something) Cost() {
  return calcCost(s.weights)
}

func (s *something) Stop() {...}
//工具函数
func calcCost(n []int) int {...}
```
- 减少嵌套
```go
// 代码应通过尽可能先处理错误情况/特殊情况并尽早返回或继续循环来减少嵌套。减少嵌套多个级别的代码的代码量。
for _, v := range data {
  if v.F1 != 1 {
    log.Printf("Invalid v: %v", v)
    continue
  }
  v = process(v)
  if err := v.Call(); err != nil {
    return err
  }
  v.Send()
}
```
- 不必要的 else
```go
// 如果在 if 的两个分支中都设置了变量，则可以将其替换为单个 if。
a := 10
if b {
  a = 100
}
```
- 顶层变量声明
```go
// 在顶层，使用标准var关键字。请勿指定类型，除非它与表达式的类型不同。
var _s = F()
// 由于 F 已经明确了返回一个字符串类型，因此我们没有必要显式指定_s 的类型
// 还是那种类型

func F() string { return "A" }
```
- 对于未导出的顶层常量和变量,使用_作为前缀
```go
// 在未导出的顶级vars和consts， 前面加上前缀_，以使它们在使用时明确表示它们是全局符号
const (
  _defaultPort = 8080
  _defaultUser = "user"
)
```
- 结构体中的嵌入
```go
// 嵌入式类型（例如 mutex）应位于结构体内的字段列表的顶部，并且必须有一个空行将嵌入式字段与常规字段分隔开。

type Client struct {
  http.Client

  version int
}
```
- 使用字段名初始化结构体
```go
// 初始化结构体时，几乎始终应该指定字段名称。
k := User{
    FirstName: "John",
    LastName: "Doe",
    Admin: true,
}
```
- 本地变量声明
```go
// 如果将变量明确设置为某个值，则应使用短变量声明形式 (:=)
s := "foo"
```
- nil 是一个有效的 slice
```go
// nil 是一个有效的长度为 0 的 slice，这意味着，

// 您不应明确返回长度为零的切片。应该返回nil 来代替
```
- 小变量作用域
```go
// 如果有可能，尽量缩小变量作用范围。除非它与 减少嵌套的规则冲突。
if err := ioutil.WriteFile(name, data, 0644); err != nil {
 return err
}
```
- 避免参数语义不明确（Avoid Naked Parameters）
```go
// 函数调用中的意义不明确的参数可能会损害可读性。当参数名称的含义不明显时，请为参数添加 C 样式注释 (/* ... */)
// func printInfo(name string, isLocal, done bool)

printInfo("foo", true /* isLocal */, true /* done */)
```
- 使用原始字符串字面值,避免转义
```go
// Go 支持使用 原始字符串字面值，也就是 " ` " 来表示原生字符串，在需要转义的场景下，我们应该尽量使用这种方案来替换。

// 可以跨越多行并包含引号。使用这些字符串可以避免更难阅读的手工转义的字符串。
wantError := `unknown error:"test"`
```
- 初始化 Struct 引用
```go
// 在初始化结构引用时，请使用&T{}代替new(T)，以使其与结构体初始化一致。
sval := T{Name: "foo"}

sptr := &T{Name: "bar"}
```
- 字符串 string format
```go
// 如果你为Printf-style 函数声明格式字符串，请将格式化字符串放在外面，并将其设置为const常量。
const msg = "unexpected values %v, %v\n"
fmt.Printf(msg, 1, 2)
```
- 命名 Printf 样式的函数
```go

```
#### 编程模式
- 表驱动测试
- 功能选项
```go
// 功能选项是一种模式，您可以在其中声明一个不透明 Option 类型，该类型在某些内部结构中记录信息。您接受这些选项的可变编号，并根据内部结构上的选项记录的全部信息采取行动。
// 将此模式用于您需要扩展的构造函数和其他公共 API 中的可选参数，尤其是在这些功能上已经具有三个或更多参数的情况下
// package db

type Option interface {
  // ...
}

func WithCache(c bool) Option {
  // ...
}

func WithLogger(log *zap.Logger) Option {
  // ...
}

// Open creates a connection.
func Open(
  addr string,
  opts ...Option,
) (*Connection, error) {
  // ...
}
```