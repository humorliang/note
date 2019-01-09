<template>
  <div id="app">
    <header>
      <div id="nav">
        <Nav msg="nav"></Nav>
      </div>
    </header>
    <div id="content">
      <Row>
        <!-- 当屏幕再小的时候就会换行，如果不设置比例 -->
        <Col :md="16" :lg="18">
          <router-view/>
        </Col>
        <Col :md="8" :lg="6">
          <RightSider msg="右侧边栏"></RightSider>
        </Col>
      </Row>
    </div>
    <div id="footer">底部</div>
  </div>
</template>
<script>
import RightSider from "@/components/RightSider.vue";
import Nav from "@/components/Nav.vue";
export default {
  // 组件注册
  components: {
    RightSider,
    Nav
  }
};
</script>

<style lang="stylus">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

</style>
