<template>
<div id="post">
    <div id="post-content" style="text-align:center;margin:0 10px;">
        <Card >
            <div style="border-bottom:1px solid #ccc;">
                <h2>文章标题</h2>
                <p>作者：<span style="color:green; padding-right:20px;">三毛</span>时间：<span style="color:green;">2017-10-02</span></p>
            </div>
            <p>Content of no border type. Content of no border type. Content of no border type. Content of no border type. </p>
        </Card>
    </div>
    <Comment></Comment>
</div>
</template>

<script>
import Comment from '@/components/Comment.vue';
export default {
    name: "post",
    components: {
        Comment
    }
}
</script>
