<template>
<div id="list">
    <h2>
        <Breadcrumb>
            <BreadcrumbItem to="/" style="font-size:20px; color:green;">首页</BreadcrumbItem>
            <BreadcrumbItem to="/list" style="font-size:20px; color:green;">精品推荐</BreadcrumbItem>
        </Breadcrumb>
    </h2>
    <!-- item项 -->
    <Item></Item>
</div>
</template>

<script>
import Item from "@/components/Item.vue";
export default {
    components: {
        Item
    }
}
</script>

<style lang="stylus" scoped>
#list {
    margin: 20px 10px;
    padding 10px;
}

#list {
    h2 {
        margin: 10px 0;
        padding-left :20px;
        text-align: left;
    }
}
</style>
