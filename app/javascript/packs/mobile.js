/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import VueRouter from 'vue-router'

import MobileApp from '../MobileApp.vue'
import HomePage from '../pages/mobile/HomePage.vue'
// import PostVoteBtn from '../components/PostVoteBtn.vue'

Vue.use(VueRouter)

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


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import VueResource from 'vue-resource'
// import VueEventHub from 'vue-event-hub'

// import 'moment/locale/pl'
// import VueMoment from 'vue-moment'

// import PostVoteBtn from '../components/PostVoteBtn.vue'
// import PostBookmarkBtn from '../components/PostBookmarkBtn.vue'
// import PostPreviewMediaBtn from '../components/PostPreviewMediaBtn.vue'
// import PostPreviewMedia from '../components/PostPreviewMedia.vue'
// import NewPostForm from '../components/NewPostForm.vue'
// import HumanDateTime from '../components/HumanDateTime.vue'
// import EventBeginningAt from '../components/EventBeginningAt.vue'

// Vue.use(VueResource)
// Vue.use(VueEventHub)
// Vue.use(VueMoment)

// Vue-resource settings
// Vue.http.options.root = '/'
// Vue.http.interceptors.push(function(request, next) {
//   request.headers.set('X-CSRF-TOKEN', $('[name="csrf-token"]').attr('content'))
//   next()
// })

// Initialize

// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#app',
//     components: {
//       // PostVoteBtn,
//       // PostBookmarkBtn,
//       // PostPreviewMediaBtn,
//       // PostPreviewMedia,
//       // NewPostForm,
//       // HumanDateTime,
//       // EventBeginningAt
//     }
//   })
// })
