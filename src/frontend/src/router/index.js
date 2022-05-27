import { createRouter, createWebHistory } from 'vue-router'
import LandingView from '../views/LandingView.vue'

const routes = [
  {
    path: '/',
    name: 'landing',
    component: LandingView
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
