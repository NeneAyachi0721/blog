<template>
  <div class="frontend-layout">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <!-- 背景 -->
      <div class="gradient-bg"></div>
    </div>

    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="header-container">
        <div class="logo">
          <router-link to="/">
            <span class="logo-icon">✒️</span>
            <span class="logo-text">{{ blogName }}</span>
          </router-link>
        </div>
        <el-menu
          :default-active="activeMenu"
          mode="horizontal"
          router
          class="nav-menu"
          :ellipsis="false"
        >
          <el-menu-item index="/">首页</el-menu-item>
          <el-menu-item index="/articles">文章</el-menu-item>
          <el-menu-item index="/friend-link">友情链接</el-menu-item>
          <el-menu-item index="/about">关于我</el-menu-item>
        </el-menu>
        <div class="user-menu">
          <router-link to="/profile" class="user-item" v-if="isLoggedIn">
            <el-icon><User /></el-icon> 个人中心
          </router-link>
          <a class="user-item logout" v-if="isLoggedIn" @click="handleLogout">
            <el-icon><SwitchButton /></el-icon> 退出
          </a>
          <router-link to="/login" class="user-item login" v-else
            >登录</router-link
          >
          <router-link
            to="/register"
            class="user-item register"
            v-if="!isLoggedIn"
            >注册</router-link
          >
        </div>
      </div>
    </header>

    <!-- 主要内容区域 -->
    <main class="main-content">
      <router-view />
    </main>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="footer-decoration"></div>
      <div class="footer-content">
        <div class="footer-logo">
          <span class="logo-icon">✒️</span>
          <span class="logo-text">{{ blogName }}</span>
        </div>
        <p class="footer-text">{{ footerText }}</p>
        <p v-if="icpInfo" class="icp-info">{{ icpInfo }}</p>
        <p v-if="gonganInfo" class="gongan-info">{{ gonganInfo }}</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from "vue";
import { useUserStore } from "@/store/user";
import { useRouter, useRoute } from "vue-router";
import { User, SwitchButton } from "@element-plus/icons-vue";
import request from "@/utils/request";

const route = useRoute();
const userStore = useUserStore();
const router = useRouter();
const blogConfig = ref({});

const isLoggedIn = computed(() => !!userStore.token);

// 当前激活的菜单项
const activeMenu = computed(() => route.path);

// 博客名称
const blogName = computed(() => {
  return blogConfig.value.blog_name || "个人博客";
});

// 页脚文本
const footerText = computed(() => {
  return blogConfig.value.blog_footer || "© 2026 个人博客 All Rights Reserved";
});

// ICP备案信息
const icpInfo = computed(() => {
  return blogConfig.value.blog_icp || "";
});

// 公安备案信息
const gonganInfo = computed(() => {
  return blogConfig.value.blog_gongan || "";
});

// 获取博客配置
const fetchBlogConfig = async () => {
  try {
    await request.get(
      "/config",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          blogConfig.value = data || {};
        },
      },
    );
  } catch (error) {
    console.error("获取博客配置失败:", error);
  }
};

const handleLogout = () => {
  userStore.clearUserInfo();
  router.push("/login");
};

// 生命周期钩子
onMounted(() => {
  fetchBlogConfig();
});
</script>

<style lang="scss" scoped>
.frontend-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f8f9fa;
  position: relative;
}

/* 背景装饰 */
.bg-decoration {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;
}

/* 背景 */
.gradient-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: #eaeff4;
}

/* 顶部导航栏 */
.header {
  background-color: rgba(255, 255, 255, 0.55);
  backdrop-filter: blur(20px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  width: 100%;
}

.header-container {
  width: 100%;
  padding: 0 40px;
  height: 70px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  display: flex;
  align-items: center;
}

.logo a {
  display: flex;
  align-items: center;
  color: #333;
  text-decoration: none;
  font-weight: 500;
}

.logo-icon {
  font-size: 24px;
  margin-right: 8px;
}

.logo-text {
  font-size: 20px;
  font-family: "SimSun", serif;
}

.nav-menu {
  flex: 1;
  justify-content: center;
  border-bottom: none;
  margin: 0 20px;
  background-color: transparent;
}

.user-menu {
  display: flex;
  gap: 20px;
  align-items: center;
}

.user-item {
  color: #333;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: "SimSun", serif;
}

.user-item:hover {
  color: #000;
}

.user-item.login {
  color: #333;
  padding: 5px 15px;
  border: 1px solid #333;
  border-radius: 4px;

  &:hover {
    background-color: rgba(0, 0, 0, 0.05);
  }
}

.user-item.register {
  background-color: #333;
  color: white;
  padding: 5px 15px;
  border-radius: 4px;
  border: 1px solid #333;

  &:hover {
    background-color: #000;
  }
}

.user-item.logout {
  color: #666;

  &:hover {
    color: #f56c6c;
  }
}

/* 主要内容区域 */
.main-content {
  flex: 1;
  position: relative;
  z-index: 1;
  padding: 0;
  width: 100%;
}

/* 页脚 */
.footer {
  background-color: #eaeff4;
  color: #666;
  padding: 50px 40px 30px;
  text-align: center;
  position: relative;
  z-index: 1;
  border-top: 1px solid rgba(0, 0, 0, 0.05);
  width: 100%;
}

.footer-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 50px;
  overflow: hidden;
}

.footer-wave {
  position: absolute;
  top: -40px;
  left: 0;
  width: 100%;
  height: 50px;
  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(0,0,0,0.03)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,186.7C384,213,480,235,576,224C672,213,768,171,864,149.3C960,128,1056,128,1152,149.3C1248,171,1344,213,1392,234.7L1440,256L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>')
    no-repeat;
  background-size: 100% 50px;
}

.footer-content {
  width: 100%;
}

.footer-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
}

.footer-text {
  font-family: "SimSun", serif;
  margin-bottom: 15px;
}

.icp-info,
.gongan-info {
  margin-top: 8px;
  font-size: 12px;
  opacity: 0.7;
}

@media (max-width: 768px) {
  .header-container {
    flex-direction: column;
    height: auto;
    padding: 15px 20px;
  }

  .logo {
    margin-bottom: 15px;
  }

  .nav-menu {
    width: 100%;
    margin: 0 0 15px 0;

    :deep(.el-menu-item) {
      height: 50px;
      line-height: 50px;
      padding: 0 15px;
      justify-content: center;
    }
  }

  .user-menu {
    width: 100%;
    justify-content: center;
  }
}
</style>
