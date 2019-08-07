#### go range 踩坑
```go
type student struct {
	Name string
	Age  int
}

func demo() {
	m := make(map[string]*student)
	stus := []student{
		{Name: "zhou", Age: 24},
		{Name: "li", Age: 23},
		{Name: "wang", Age: 22},
	}

	for _, stu := range stus {
		fmt.Printf("%p %v\n" ,&stu)
		m[stu.Name] = &stu
	}
	fmt.Println(m["zhou"],m["li"],m["wang"])
}
// 结果
0xc00000c080 &{zhou 24}
0xc00000c080 &{li 23}
0xc00000c080 &{wang 22}
&{wang 22} &{wang 22} &{wang 22}
//当range 遍历的时候　变量的内存地址不会改变　
//改变的是内存地址的数据
```
#### go 变量理解
```go
    var a, b int
	c := 3
	a = 1
	fmt.Printf("a:%p b:%p c:%p a:%v b:%v c:%v\n ", &a, &b, &c, a, b, c)
	b = 2
	c = 4
	fmt.Printf("a:%p b:%p c:%p a:%v b:%v c:%v\n ", &a, &b, &c, a, b, c)
	a = b
	c = a
	fmt.Printf("a:%p b:%p c:%p a:%v b:%v c:%v\n ", &a, &b, &c, a, b, c)
//结果
a:0xc00001e0c8 b:0xc00001e0e0 c:0xc00001e0e8 a:1 b:0 c:3
 a:0xc00001e0c8 b:0xc00001e0e0 c:0xc00001e0e8 a:1 b:2 c:4
 a:0xc00001e0c8 b:0xc00001e0e0 c:0xc00001e0e8 a:2 b:2 c:2
//变量名代表是一个内存地址，在变量声明好之后，地址就不会改变
//改变的只有内存地址上的数据
```
#### go 接口
```go
//接口类型
type People interface {
	Speak(string) string
}

type Student struct{}
//student　的指针类型实现了Speak方法
func (stu *Student) Speak(think string) (talk string) {
	if think == "bitch" {
		talk = "You are a good boy"
	} else {
		talk = "hi"
	}
	return
}
//修改为下列实现过程 
//指针类型　默认是实现了非指针类型的方法　
// var peo People = &Student{}
// var peo People = Student{}
//student　实现了Speak方法
func (stu Student) Speak(think string) (talk string) {
	if think == "bitch" {
		talk = "You are a good boy"
	} else {
		talk = "hi"
	}
	return
}
func main() {
	var peo People = &Student{}　//编译通过
	var peo People = Student{}　//编译不通过　因为 Student{}没有实现Speak()方法　只是&Student{}实现了接口
	think := "bitch"
	fmt.Println(peo.Speak(think))
}
```
