<template>
<div id="comment" style="padding-top:20px;margin:0 20px;">
    <Card>
        <Row>
            <Col span="3" style="color:green;font-size:18px;text-align:right;padding-right:10px;">
            发表评论:
            </Col>
            <Col span="8" style="text-align:right;">
            <Input style="border-color:green;dispaly:inline-block;" type="textarea" :autosize="{minRows: 2,maxRows: 30}" placeholder="请输入内容" />
            <Button style="" type="success">提交</Button>
            </Col>
        </Row>
        <div id="comment-list" style="padding-left:30px;">
            <div>
                <Avatar src="https://i.loli.net/2017/08/21/599a521472424.jpg" />
                <span style="display:inline-block;padding:5px;color:blue;font-size:16px; vertical-align: bottom;">詹三</span>
                <time style="">2017-10-10</time>
                <p style="padding-left:50px;font-size:18px;">这是评论的内容</p>
            </div>
            <Page :total="20" size="small" :page-size="4" show-total />
        </div>
    </Card>
</div>
</template>

<script>
export default {
    name: "comment"
}
</script>

<style lang="stylus" scoped>
</style>
