<template>
    <!-- <div>{{msg}}</div> -->
    <div id="sider" >
        <Card>
            <p slot="title">鸡汤一下</p>
            <p>Content of no border type. Content of no border type. Content of no border type. Content of no border type. </p>
        </Card>
        <Card style="margin-top:30px;">
            <p slot="title">交流社区</p>
            <p>Content of no border type. Content of no border type. Content of no border type. Content of no border type. </p>
        </Card>
        <Card style="margin-top:30px;">
            <p slot="title">广告时间</p>
            <p>Content of no border type. Content of no border type. Content of no border type. Content of no border type. </p>
        </Card>
    </div>
</template>
<script>
export default {
    name:"RightSider",
    props: {
    msg: String
  }
}
</script>
