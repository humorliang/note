<template>
  <Menu mode="horizontal" active-name="1" style="margin-bottom:20px;">
    <MenuItem name="1" to="/">首页</MenuItem>
    <MenuItem name="2" to="/post">极力推荐</MenuItem>
    <Submenu name="3">
      <template slot="title">文章分类</template>
      <MenuItem name="3-1" to="/list">Web前端</MenuItem>
      <MenuItem name="3-2" to="/list">Python</MenuItem>
      <MenuItem name="3-3" to="/list">Go系列</MenuItem>
    </Submenu>
    <MenuItem name="4" to="/levcots">
      留言板
    </MenuItem>
    <MenuItem name="5" to="/about">
      关于
    </MenuItem>
  </Menu>
</template>
<script>
export default {
  name:"Nav",
  props:{
    msg:String
  }
}
</script>
<style lang="stylus">
ul.ivu-menu.ivu-menu-light.ivu-menu-horizontal{
  padding-left :50px;
}
</style>

