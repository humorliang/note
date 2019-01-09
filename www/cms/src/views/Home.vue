<template>
<div class="home" style="margin:10px 0 0 20px;">
    <!-- <img alt="Vue logo" src="../assets/logo.png"> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
    <!-- <p>home 页面</p> -->
    <h2 style="color:green;text-align:left;padding:20px;">热门推荐</h2>
    <Item :data="data"></Item>
</div>
</template>

<script>
// @ is an alias to /src
import Item from '@/components/Item.vue';
export default {
    data() {
      return {
        data:[{
          postId:1
        },{
          postId:2
        }],
      }
    },
    name: 'home',
    components: {
        Item
    },
    created: function () {
        this.axios.get('/tag')
            .then(function (response) {
                console.log(response);
            })
            .catch(function (error) {
                console.log(error);
            });
    },
}
</script>

<style lang="stylus" scoped>

</style>
