import { createRouter, createWebHistory } from 'vue-router'
import CallbackView from '../views/CallbackView.vue'
import LandingView from '../views/LandingView.vue'
import ShareView from '../views/ShareView.vue'

const routes = [
  {
    path: '/callback',
    name: 'callback',
    component: CallbackView
  },
  {
    path: '/',
    name: 'landing',
    component: LandingView
  },
  {
    path: '/share/:job_id',
    name: 'share',
    component: ShareView
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
