<template>
  <div class="home" style="margin:10px 0 0 20px;">
    <!-- <img alt="Vue logo" src="../assets/logo.png"> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
    <!-- <p>home 页面</p> -->
    <h2 style="color:green;text-align:left;padding:20px;">热门推荐</h2>
    <Item></Item>
  </div>
</template>

<script>
// @ is an alias to /src
import Item from '@/components/Item.vue';
export default {
  name: 'home',
  components: {
    Item
  }
}
</script>
<style lang="stylus" scoped>

</style>

