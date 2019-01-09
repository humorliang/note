<template>
<div id="item">
    <Card :bordered="false" class="item-card">
        <!-- {{data}} -->
        <Row>
            <Col :sm="4" :md="6" :lg="8">
            <img src="@/assets/a.jpg" alt="文章预览图" style="width: 90%;">
            </Col>
            <Col :sm="20" :md="18" :lg="16">
            <p style="font-size:20px;border-bottom:1px solid #ccc;padding-bottom:10px;">
                <Button type="dashed" style="color:green;margin-right:100px;">标签</Button>
                文章标题
            </p>
            <p>Content of no border type. Content of no border type. Content of no border type. Content of no border type.</p>
            <p>
                <Row>
                    <Col span="8">
                    <Button type="success" ghost>阅读全文                   
                     <Icon type="ios-arrow-round-forward" size="20" color="green"/>
                    </Button>
                    </Col>
                    <Col span="4" offset="12">
                    <Button type="info" ghost>评论                   
                    <Icon type="ios-create-outline" size="20" />
                    </Button>
                    </Col>
                </Row>
            </p>
            </Col>
        </Row>
    </Card>
</div>
</template>

<script>
export default {
    name: "Item",
    props: [
        'data'
    ]
};
</script>

<style lang="stylus" scoped>
#item .item-card .ivu-card-body {
    padding-left: 0;
}

#item .item-card p {
    text-align: left;
    padding: 5px 5px;
    height: 50px;
}

#item .item-card .ivu-card-head {
    padding: 0 10px;
}
</style>
