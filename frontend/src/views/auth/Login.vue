<template>
  <Auth
    :formData="loginForm"
    :rules="rules"
    :loading="loading"
    submitText="登录"
    formTitle="欢迎回来"
    @submit="handleSubmit"
  >
    <template #form-items>
      <el-form-item prop="username">
        <el-input
          v-model="loginForm.username"
          :prefix-icon="User"
          placeholder="请输入用户名"
        >
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          v-model="loginForm.password"
          :prefix-icon="Lock"
          type="password"
          placeholder="请输入密码"
          @keyup.enter="handleSubmit(loginFormRef)"
        >
        </el-input>
      </el-form-item>
    </template>

    <template #auth-links>
      <router-link to="/forget" class="forget-link">忘记密码？</router-link>
      <router-link to="/register">立即注册</router-link>
    </template>
  </Auth>
</template>

<script setup>
import { ref, reactive } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useUserStore } from "@/store/user";
import request from "@/utils/request";
import { User, Lock } from "@element-plus/icons-vue";
import { setBackRoutes } from "@/router";
import Auth from "./Auth.vue";

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();
const formRef = ref(null);
const loading = ref(false);

const loginForm = reactive({
  username: "",
  password: "",
});

const rules = {
  username: [{ required: true, message: "请输入用户名", trigger: "blur" }],
  password: [{ required: true, message: "请输入密码", trigger: "blur" }],
};

const handleSubmit = (form) => {
  formRef.value = form.value;
  loginFormRef.value = form.value;
  handleLogin();
};

const loginFormRef = ref(null);

const handleLogin = () => {
  loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      try {
        // 统一使用用户登录接口
        const res = await request.post("/user/login", loginForm, {
          successMsg: "登录成功",
          showDefaultMsg: true,
          onSuccess: async (data) => {
            userStore.setUserInfo(data);

            // 根据返回的角色决定跳转路径
            if (data.roleCode !== "USER") {
              await router.isReady();
              router.push(route.query.redirect || "/back/dashboard");
            } else {
              // 普通用户登录，直接跳转到前台
              const redirect = route.query.redirect || "/";
              router.push(redirect);
            }
          },
          onError: (error) => {
            console.error("登录失败:", error);
          },
        });
      } finally {
        loading.value = false;
      }
    }
  });
};
</script>

<style lang="scss" scoped>
/* 登录页面特定样式可以在这里添加 */
</style>
