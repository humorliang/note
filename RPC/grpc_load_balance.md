#### 自定义的命名解析器
１．实现解析器的生成接口
```go
// scheme://authority/endpoint
type Builder interface {
	// Build creates a new resolver for the given target.
	//
	// gRPC dial calls Build synchronously, and fails if the returned error is
	// not nil.
	Build(target Target, cc ClientConn, opts BuildOption) (Resolver, error)
	// Scheme returns the scheme supported by this resolver.
	// Scheme is defined at https://github.com/grpc/grpc/blob/master/doc/naming.md.
	Scheme() string
}
//Build 方法
根据grpc.Dial(addr,...opt)传入的addr 进行同步绑定到解析器。
build 主要职责：
将Dail的信息传入　绑定到自定义的　Resolver(解析器)
//Scheme 协议解析
返回解析协议string
```
2. 实现解析规则接口
```go
type Resolver interface {
	// ResolveNow will be called by gRPC to try to resolve the target name
	// again. It's just a hint, resolver can ignore this if it's not necessary.
	//
	// It could be called multiple times concurrently.
	ResolveNow(ResolveNowOption)
	// Close closes the resolver.
	Close()
}
//ResolveNow 和　Close　不需要具体实现

resolver包的resolver文件有一个map 去维护你注册的　自定义解析器
// m is a map from scheme to resolver builder.
	m = make(map[string]Builder)
```
