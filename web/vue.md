### vue理解
#### vue 实例
```javascript
// １．　创建　每一个组件都是一个实例
var vm = new Vue({
  // 选项
})

// ２．　数据与方法
var data = { a: 1 }
var vm = new Vue({
  el: '#example',
  data: data
})
vm.$data === data // => true
vm.$el === document.getElementById('example') // => true
// $watch 是一个实例方法
vm.$watch('a', function (newValue, oldValue) {
  // 这个回调将在 `vm.a` 改变后调用
})

// 3. 实例生命周期　
//钩子函数　比如 created 钩子　mounted、updated 和 destroyed
new Vue({
  data: {
    a: 1
  },
  created: function () {
    // `this` 指向 vm 实例
    console.log('a is: ' + this.a)
  }
})
```
####　模板语法
```javascript
// 1. 插值　
// 大括号内会被转义 
//文本内使用　“Mustache”语法 (双大括号)
<span>Message: {{ msg }}</span>
//　输出原始html 　v-html指令
<p>Using v-html directive: <span v-html="rawHtml"></span></p>
// 标签内使用指令　绑定数据　v-bind　将属性　id 与　数据 data的dynamicId 绑定
<div v-bind:id="dynamicId"></div>

// 2. 指令　(指令 (Directives) 是带有 v- 前缀的特殊特性)
<p v-if="seen">现在你看到我了</p>
//参数　(一些指令能够接收一个“参数”，在指令名称之后以冒号表示.)
<a v-bind:href="url">...</a>//　href则是参数
// v-on 指令，它用于监听 DOM 事件：　
<a v-on:click="doSomething">...</a>　//参数是监听的事件名 click

// 3. 缩写
// v-bind 缩写
// <!-- 完整语法 -->
<a v-bind:href="url">...</a>
// <!-- 缩写 -->
<a :href="url">...</a>

// v-on 缩写
// <!-- 完整语法 -->
<a v-on:click="doSomething">...</a>
// <!-- 缩写 -->
<a @click="doSomething">...</a>
```

#### 组件基础
```javascript
//1 组件注册　（通过全局　Vue对象注册的对象　可以在任意一个　vue实例中使用）
// 定义一个名为 button-counter 的新组件
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})
//新实例使用
<div id="components-demo">
  <button-counter></button-counter>
</div>
new Vue({ el: '#components-demo' })
/* 因为组件是可复用的 Vue 实例，所以它们与 new Vue 接收相同的选项，
例如 data、computed、watch、methods 以及生命周期钩子等。
仅有的例外是像 el 这样　根实例　特有的选项。 */

//2 组件复用
// data 必须是一个函数
data: function () {
  return {
    count: 0
  }
}

//３　父组件向子组件传递数据
//子组件用 props进行接收属性
Vue.component('blog-post', {
  props: ['title'],//子组件接收　title属性
  template: '<h3>{{ title }}</h3>'//title属性 使用
})
//父组件中　
<blog-post title="My journey with Vue"></blog-post>//title传递到子组件
<blog-post title="Blogging with Vue"></blog-post>
new Vue({
  el: '#blog-post-demo',
  data: {
    posts: [
      { id: 1, title: 'My journey with Vue' },
      { id: 2, title: 'Blogging with Vue' },
      { id: 3, title: 'Why Vue is so fun' }
    ]
  }
})
<blog-post
  v-for="post in posts"
  v-bind:key="post.id"
  v-bind:title="post.title"　//子组件接收
></blog-post>

// 4 监听子组件的事件
//父组件
<blog-post
  v-on:enlarge-text="postFontSize += 0.1"　//监听子组件的　enlarge-text事件
></blog-post>
<blog-post
  ...
  v-on:enlarge-text="postFontSize += $event"//$event 接收值
></blog-post>
<blog-post
  ...
  v-on:enlarge-text="onEnlargeText"//onEnlargeText　函数处理
></blog-post>
methods: {
  onEnlargeText: function (enlargeAmount) {
    this.postFontSize += enlargeAmount
  }
}
//子组件可以通过调用内建的 $emit 方法 并传入事件名称来触发一个事件
<button v-on:click="$emit('enlarge-text')">
  Enlarge text
</button>
// 使用 $emit 的第二个参数来传值：
<button v-on:click="$emit('enlarge-text', 0.1)">
  Enlarge text
</button>

// 5 插槽
<div class="container">
  <header>
    <slot name="header"></slot>　//具名插槽
  </header>
  <main>
    <slot></slot>//一个不带 name 的 <slot> 出口会带有隐含的名字“default”
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>
// 第一不同的插槽
<base-layout>
// v-slot 只能添加在一个 <template> 上
  <template v-slot:header>
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <template v-slot:footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>
```
