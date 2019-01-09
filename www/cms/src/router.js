import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
//导入axios
import axios from 'axios'
// 注册全局函数
axios.defaults.baseURL="http://localhost:8090"
Vue.prototype.axios = axios;

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    },
    {
      path: '/list',
      name: 'list',
      component: () => import(/* webpackChunkName: "list" */ './views/List.vue')
    },
    {
      path: '/post',
      name: 'post',
      component: () => import(/* webpackChunkName: "post" */ './views/Post.vue')
    },
    {
      path: '/levcots',
      name: 'levcots',
      component: () => import(/* webpackChunkName: "levcots" */ './views/Levcots.vue')
    }
  ]
})
