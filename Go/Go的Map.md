## Map
### 声明、初始化和make
#### 概念
* map 是引用类型，内存用make来分配
    - map初始化：`var map1 = make(map[keytype]valuetype)`
    - 简写方式：`map1 := make(map[keytype]valuetype)`
* value 可以是任意类型的

#### map初始容量
- map可以动态伸缩`make(map[keytype]valuetype, cap)`

#### 用切片作为map的值
```go
    mp1 := make(map[int][]int)
    mp2 := make(map[int]*[]int)
```
### 判断键值对和删除元素
#### 判断键值对
```go
    _, ok := map1[key1] // 如果key1存在则ok == true，否则ok为false
```
#### 删除
```go
    delete(map1, key1) 
```

### for-range的配套用法
```go
    for key, value := range map1 {
        ...
    }
```

### map类型的切片
```go
    items := make([]map[int]int, 5)
	for i:= range items {
		items[i] = make(map[int]int, 1)
		items[i][1] = 2
	}
```

### map排序
- `sort`包
```go
 map 排序，需要将 key（或者 value）拷贝到一个切片，再对切片排序（使用 sort 包），然后可以使用切片的 for-range 方法打印出所有的 key 和 value。
```