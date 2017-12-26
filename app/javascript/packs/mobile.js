/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import VueRouter from 'vue-router'
import Vux from 'vux'
import Vuex from 'vuex'

import MobileApp from '../MobileApp.vue'
import HomePage from '../pages/mobile/HomePage.vue'
// import PostVoteBtn from '../components/PostVoteBtn.vue'

Vue.use(VueRouter)
// Vue.use(Vuex)

// Vux components
// Vue.component('vux-header', Vux.XHeader)

const routes = [{
  path: '/',
  component: HomePage
}]

const router = new VueRouter({
  routes
})

document.addEventListener('DOMContentLoaded', () => {
  // document.body.appendChild(document.createElement('hello'))
  const app = new Vue({
    router,
    render: h => h(MobileApp)
  }).$mount('#app')
})
