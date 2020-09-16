### grpc 配合grpc-gateway 网关
- 1. 问题 
```
当系统运行两个服务时 且服务名 和字段 名称相同时
会出现字段缺失现象，有可能是服务名称覆盖照成的
```

- proto 文件服务名相同问题
```
使用谷歌的protobuf 文件时会出现 相同包名注册问题

原因： 生成好的proto包名都会有 init 函数  init 函数会向 github.com/golang/protobuf/proto 中进行服务名称以及消息类型的注册
在protobuf/proto的包中是一个map 全局变量 这个变量的生命周期是整个程序的生命周器，如果message 存在相同的服务名 和 message 名
那么可能会出出现覆盖问题。
```
```go
// source: demo.pb.go
// 有init 函数
func init() {
	proto.RegisterType((*Hello)(nil), "demo.Hello")
}
```
```go
// A registry of all linked message types.
// The string is a fully-qualified proto name ("pkg.Message").
var (
	protoTypedNils = make(map[string]Message)      // a map from proto names to typed nil pointers
	protoMapTypes  = make(map[string]reflect.Type) // a map from proto names to map types
	revProtoTypes  = make(map[reflect.Type]string)
)

// RegisterType is called from generated code and maps from the fully qualified
// proto name to the type (pointer to struct) of the protocol buffer.
func RegisterType(x Message, name string) {
	if _, ok := protoTypedNils[name]; ok {
		// TODO: Some day, make this a panic.
		log.Printf("proto: duplicate proto type registered: %s", name)
		return
	}
	t := reflect.TypeOf(x)
	if v := reflect.ValueOf(x); v.Kind() == reflect.Ptr && v.Pointer() == 0 {
		// Generated code always calls RegisterType with nil x.
		// This check is just for extra safety.
		protoTypedNils[name] = x
	} else {
		protoTypedNils[name] = reflect.Zero(t).Interface().(Message)
	}
	revProtoTypes[t] = name
}
```