### Channels
- 理解
如果说goroutine是Go语音程序的并发体的话，那么channels它们之间的通信机制。一个channels是一个通信机制，
它可以让一个goroutine通过它给另一个goroutine发送值信息。每个channel都有一个特殊的类型，也就是channels可发送数据的类型。
一个可以发送int类型数据的channel一般写为chan int。
- 创建
使用内置的make函数，我们可以创建一个channel：
`无缓存`
```go
ch := make(chan int) // ch has type 'chan int'
```
`有缓存`
```go
ch = make(chan int)    // unbuffered channel
ch = make(chan int, 0) // unbuffered channel
ch = make(chan int, 3) // buffered channel with capacity 3
```
和map类似，channel也一个对应make创建的底层数据结构的引用。当我们复制一个channel或用于函数参数传递时，我们只是拷贝了一个channel引用，因此调用者何被调用者将引用同一个channel对象。和其它的引用类型一样，channel的零值也是nil。
- 操作
一个channel有发送和接受两个主要操作，都是通信行为。一个发送语句将一个值从一个goroutine通过channel发送到另一个执行接收操作的goroutine。
发送和接收两个操作都是用<-运算符。在发送语句中，<-运算符分割channel和要发送的值。在接收语句中，<-运算符写在channel对象之前。
一个不使用接收结果的接收操作也是合法的。
```go
//写
ch <- x  // a send statement
//读
x = <-ch // a receive expression in an assignment statement
//读
<-ch     // a receive statement; result is discarded
```
使用内置的close函数就可以关闭一个channel：
```go
close(ch)
```
### 单方向的Channel
Go语言的类型系统提供了单方向的channel类型，分别用于只发送或只接收的channel。
- 只写通道
类型chan<- int表示一个只发送int的channel，只能发送不能接收。
- 只读通道
相反，类型<-chan int表示一个只接收int的channel，只能接收不能发送。
（箭头<-和关键字chan的相对位置表明了channel的方向。）这种限制将在编译期检测。
- 只写通道 进行关闭
因为关闭操作只用于断言不再向channel发送新的数据，所以只有在发送者所在的goroutine才会调用close函数，
因此对一个只接收的channel调用close将是一个编译错误。
```go
//只写 参数
func counter(out chan<- int) {
    for x := 0; x < 100; x++ {
        out <- x
    }
    //写的地方进行关闭
    close(out)
}

//读 写
func squarer(out chan<- int, in <-chan int) {
    for v := range in {
        out <- v * v
    }
    close(out)
}
//读
func printer(in <-chan int) {
    for v := range in {
        fmt.Println(v)
    }
}

func main() {
    naturals := make(chan int)
    squares := make(chan int)
    go counter(naturals)
    go squarer(squares, naturals)
    printer(squares)
}
```