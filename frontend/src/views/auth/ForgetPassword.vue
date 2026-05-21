<template>
  <Auth 
    :formData="forgetForm" 
    :rules="rules" 
    :loading="loading"
    submitText="重置密码"
    formTitle="找回密码"
    @submit="handleSubmit"
  >
    <template #form-items>
      <div class="forget-form-content">
        <p class="form-description">请输入您的注册邮箱和新密码</p>
        
        <el-form-item prop="email">
          <el-input 
            v-model="forgetForm.email"
            :prefix-icon="Message"
            placeholder="请输入注册邮箱">
          </el-input>
        </el-form-item>
        
        <div class="password-group">
          <el-form-item prop="newPassword">
            <el-input 
              v-model="forgetForm.newPassword"
              :prefix-icon="Lock"
              type="password"
              placeholder="请输入新密码">
            </el-input>
          </el-form-item>
          
          <el-form-item prop="confirmPassword">
            <el-input 
              v-model="forgetForm.confirmPassword"
              :prefix-icon="Lock"
              type="password"
              placeholder="请确认新密码"
              @keyup.enter="handleSubmit(formRef)">
            </el-input>
          </el-form-item>
        </div>
      </div>
    </template>

    <template #auth-links>
      <div class="forget-links">
        <router-link to="/login">返回登录</router-link>
        <router-link to="/register">立即注册</router-link>
      </div>
    </template>
  </Auth>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { Message, Lock } from '@element-plus/icons-vue'
import request from '@/utils/request'
import Auth from './Auth.vue'

const router = useRouter()
const formRef = ref(null)
const forgetFormRef = ref(null)
const loading = ref(false)

const forgetForm = reactive({
  email: '',
  newPassword: '',
  confirmPassword: ''
})

const validatePass2 = (rule, value, callback) => {
  if (value !== forgetForm.newPassword) {
    callback(new Error('两次输入密码不一致!'))
  } else {
    callback()
  }
}

const validateEmail = (rule, value, callback) => {
  const emailRegex = /^[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)*@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
  if (!emailRegex.test(value)) {
    callback(new Error('邮箱格式不正确'))
  } else {
    callback()
  }
}

const rules = {
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { validator: validateEmail, trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 100, message: '密码长度必须在6到100个字符之间', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    { validator: validatePass2, trigger: 'blur' }
  ]
}

const handleSubmit = (form) => {
  formRef.value = form.value
  forgetFormRef.value = form.value
  handleForget()
}

const handleForget = () => {
  forgetFormRef.value.validate(async valid => {
    if (valid) {
      loading.value = true
      try {
        await request.get("/user/forget", {
          email: forgetForm.email,
          newPassword: forgetForm.newPassword
        }, {
          successMsg: "密码重置成功，请重新登录",
          showDefaultMsg: true,
          onSuccess: () => {
            router.push('/login')
          }
        })
      } finally {
        loading.value = false
      }
    }
  })
}
</script>

<style lang="scss" scoped>
.forget-form-content {
  .form-description {
    text-align: center;
    color: #666;
    margin-bottom: 20px;
    font-size: 14px;
  }
}

.password-group {
  margin-top: 15px;
}

.forget-links {
  display: flex;
  justify-content: space-between;
  width: 100%;
  
  a {
    font-size: 14px;
  }
}
</style> 