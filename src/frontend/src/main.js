import { createApp } from 'vue'
import App from './App.vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import Vue3Storage, { StorageType } from"vue3-storage"
import router from './router'

const app = createApp(App)
app.use(router)
.use(VueAxios, axios)
.use(Vue3Storage, {namespace: "pp_", storage: StorageType.Session})
.mount('#app')

app.config.globalProperties.$api_url = "https://9l9b1qt9pg.execute-api.us-east-2.amazonaws.com/v1"