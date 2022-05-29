import { createApp } from 'vue'
import App from './App.vue'
import Vue3Storage, { StorageType } from"vue3-storage"
import router from './router'

createApp(App)
.use(router)
.use(Vue3Storage, {namespace: "pp_", storage: StorageType.Session})
.mount('#app')