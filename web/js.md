### javascript作用域
```
1. 使用var 定义的为局部作用域
2. javascript使用从内向外查找原则，最顶层的对象可以看作为window
3. es6可以使用let const定义局部作用域和常量
```
### javascript基本语法
```javascript
// 第一变量并赋值
var va=1;//使用 ; 表示代码快结束

//　Number类型
/* 
123; // 整数123
0.456; // 浮点数0.456
1.2345e3; // 科学计数法表示1.2345x1000，等同于1234.5
-99; // 负数
NaN; // NaN表示Not a Number，当无法计算结果时用NaN表示
Infinity; // Infinity表示无限大，当数值超过了JavaScript的Number所能表示的最大值时，就表示为Infinity
*/

 // 字符串 用　'' or ""
 var s1='ww'
 var s2="www"

// 特殊类型
/* 
null和undefined
*/

// 对象
var obj = {
    name: "",
}

// 数组　包含任意类型
var a=[1,"a",obj];

// es6 map 和　set 类型
var m = new Map();
var s = new Set();
var m = new Map([['Michael', 95], ['Bob', 75], ['Tracy', 85]]);
m.get('Michael'); // 95
var m = new Map();
m.set('Adam', 67);
m.set('Adam', 88);
m.get('Adam'); // 88

var s1 = new Set(); // 空Set
var s2 = new Set([1, 2, 3]); // 含1, 2, 3
//过滤重复项
var s = new Set([1, 2, 3, 3, '3']);
s; // Set {1, 2, 3, "3"}
```
### javascript函数和方法
```javascript
// 函数
function abs(x) {
    //函数内部关键字
    /* 
    arguments：　参数数组对象　arguments.length　arguments[i]
    es6 定义　获得额外的rest参数
    function foo(a, b, ...rest) {
    console.log('a = ' + a);
    console.log('b = ' + b);
    console.log(rest);
     */
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
// 1.如果以对象的方法形式调用，比如math.abs()，该函数的this指向被调用的对象，也就是math，这是符合我们预期的。
// 2.如果单独调用函数，比如abs()，此时，该函数的this指向全局对象，也就是window。
    console.log(this);
}
//　方法
var math={
    ab:abs
}
math.ab(2);//调用
// apply,call 控制this 指向  
/* 
区别
apply()把参数打包成Array再传入；
call()把参数按顺序传入。
 */
abs.apply(math,[2])//object func args

//es6 箭头函数 =>
x => x * x
　　||等同于
function (x) {
    return x * x;
}
```
### javascript与json2
```javascript
/* 
JSON实际上是JavaScript的一个子集
number：和JavaScript的number完全一致；
boolean：就是JavaScript的true或false；
string：就是JavaScript的string；
null：就是JavaScript的null；
array：就是JavaScript的Array表示方式——[]；
object：就是JavaScript的{ ... }表示方式。
 */

 //json 序列化
 var person = {
    name: '小明',
    age: 14,
    gender: true,
    height: 1.65,
    grade: null,
    middle-school: '\"W3C\" Middle School',
    skills: ['JavaScript', 'Java', 'Python', 'Lisp']
};
var s = JSON.stringify(person,arg1,arg2);
//arg1 参数用于控制如何筛选对象的键值，如果我们只想输出指定的属性
//arg2 参数，按缩进输出
JSON.stringify(person, ['name', 'skills'], '  ');

//json 反序列化
// 参数：　json串　　自定义函数
var obj = JSON.parse('{"name":"小明","age":14}', function (key, value) {
    if (key === 'name') {
        return value + '同学';
    }
    return value;
});
```
### javascript错误处理
```javascript
/* 
在一个函数内部发生了错误，它自身没有捕获，错误就会被抛到外层调用函数，
如果外层函数也没有捕获，该错误会一直沿着函数调用链向上抛出，直到被JavaScript引擎捕获，代码终止执行
 */
try {
        foo(s);
} catch (e) {
        console.log('出错了：' + e);
}
```