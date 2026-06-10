<template>
  <div class="about-container">
    <!-- 标题区域 -->
    <div class="title-container">
      <div class="title-decorations">
        <span class="decoration-left">&#123; &#125;</span>
        <span class="decoration-right">&#60;/&#62;</span>
      </div>
      <h1 class="page-title">关于博主</h1>
    </div>

    <div class="about-content" v-loading="loading">
      <!-- 个人资料卡片 -->
      <div class="profile-section">
        <div class="avatar-wrapper">
          <el-avatar :size="120" :src="adminAvatarUrl" class="avatar">
            {{ aboutInfo.about_name ? aboutInfo.about_name.charAt(0) : "A" }}
          </el-avatar>
        </div>
        <h2 class="name">{{ aboutInfo.about_name || adminName || "博主" }}</h2>
        <div class="job">{{ aboutInfo.about_job || "全栈开发工程师" }}</div>
        <div class="intro">{{ aboutInfo.about_intro || "暂无简介" }}</div>

        <!-- 社交链接 -->
        <div class="social-links">
          <a
            v-if="aboutInfo.social_github"
            :href="aboutInfo.social_github"
            target="_blank"
            class="social-item"
          >
            <el-icon
              ><svg
                role="img"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <title>GitHub</title>
                <path
                  d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"
                /></svg
            ></el-icon>
            <span>GitHub</span>
          </a>
          <a
            v-if="aboutInfo.social_bilibili"
            :href="aboutInfo.social_bilibili"
            target="_blank"
            class="social-item"
          >
            <el-icon
              ><svg
                role="img"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <title>Bilibili</title>
                <path
                  d="M17.813 4.653h.854c1.51.054 2.769.578 3.773 1.574 1.004.995 1.524 2.249 1.56 3.76v7.36c-.036 1.51-.556 2.769-1.56 3.773s-2.262 1.524-3.773 1.56H5.333c-1.51-.036-2.769-.556-3.773-1.56S.036 18.858 0 17.347v-7.36c.036-1.511.556-2.765 1.56-3.76 1.004-.996 2.262-1.52 3.773-1.574h.774l-1.174-1.12a1.234 1.234 0 0 1-.373-.906c0-.356.124-.658.373-.907l.027-.027c.267-.249.573-.373.92-.373.347 0 .653.124.92.373L9.653 4.44c.071.071.134.142.187.213h4.267a.836.836 0 0 1 .16-.213l2.853-2.747c.267-.249.573-.373.92-.373.347 0 .662.151.929.4.267.249.391.551.391.907 0 .355-.124.657-.373.906zM5.333 7.24c-.746.018-1.373.276-1.88.773-.506.498-.769 1.13-.786 1.894v7.52c.017.764.28 1.395.786 1.893.507.498 1.134.756 1.88.773h13.334c.746-.017 1.373-.275 1.88-.773.506-.498.769-1.129.786-1.893v-7.52c-.017-.765-.28-1.396-.786-1.894-.507-.497-1.134-.755-1.88-.773zM8 11.107c.373 0 .684.124.933.373.25.249.383.569.4.96v1.173c-.017.391-.15.711-.4.96-.249.25-.56.374-.933.374s-.684-.125-.933-.374c-.25-.249-.383-.569-.4-.96V12.44c0-.373.129-.689.386-.947.258-.257.574-.386.947-.386zm8 0c.373 0 .684.124.933.373.25.249.383.569.4.96v1.173c-.017.391-.15.711-.4.96-.249.25-.56.374-.933.374s-.684-.125-.933-.374c-.25-.249-.383-.569-.4-.96V12.44c.017-.391.15-.711.4-.96.249-.249.56-.373.933-.373Z"
                /></svg
            ></el-icon>
            <span>Bilibili</span>
          </a>
          <a
            v-if="aboutInfo.social_steam"
            :href="aboutInfo.social_steam"
            target="_blank"
            class="social-item"
          >
            <el-icon
              ><svg
                role="img"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <title>Steam</title>
                <path
                  d="M11.979 0C5.678 0 .511 4.86.022 11.037l6.432 2.658c.545-.371 1.203-.59 1.912-.59.063 0 .125.004.188.006l2.861-4.142V8.91c0-2.495 2.028-4.524 4.524-4.524 2.494 0 4.524 2.031 4.524 4.527s-2.03 4.525-4.524 4.525h-.105l-4.076 2.911c0 .052.004.105.004.159 0 1.875-1.515 3.396-3.39 3.396-1.635 0-3.016-1.173-3.331-2.727L.436 15.27C1.862 20.307 6.486 24 11.979 24c6.627 0 11.999-5.373 11.999-12S18.605 0 11.979 0zM7.54 18.21l-1.473-.61c.262.543.714.999 1.314 1.25 1.297.539 2.793-.076 3.332-1.375.263-.63.264-1.319.005-1.949s-.75-1.121-1.377-1.383c-.624-.26-1.29-.249-1.878-.03l1.523.63c.956.4 1.409 1.5 1.009 2.455-.397.957-1.497 1.41-2.454 1.012H7.54zm11.415-9.303c0-1.662-1.353-3.015-3.015-3.015-1.665 0-3.015 1.353-3.015 3.015 0 1.665 1.35 3.015 3.015 3.015 1.663 0 3.015-1.35 3.015-3.015zm-5.273-.005c0-1.252 1.013-2.266 2.265-2.266 1.249 0 2.266 1.014 2.266 2.266 0 1.251-1.017 2.265-2.266 2.265-1.253 0-2.265-1.014-2.265-2.265z"
                /></svg
            ></el-icon>
            <span>Steam</span>
          </a>
          <a
            v-if="aboutInfo.social_email"
            :href="`mailto:${aboutInfo.social_email}`"
            class="social-item"
          >
            <el-icon
              ><svg
                role="img"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <title>Email</title>
                <path
                  d="M24 5.457v13.909c0 .904-.732 1.636-1.636 1.636h-3.819V11.73L12 16.64l-6.545-4.91v9.273H1.636A1.636 1.636 0 0 1 0 19.366V5.457c0-2.023 2.309-3.178 3.927-1.964L5.455 4.64 12 9.548l6.545-4.91 1.528-1.145C21.69 2.28 24 3.434 24 5.457z"
                /></svg
            ></el-icon>
            <span>Email</span>
          </a>
        </div>
      </div>

      <!-- 详细介绍 -->
      <div class="detail-section">
        <div class="section-header">
          <h2 class="section-title">个人简介</h2>
        </div>
        <div class="markdown-content" v-html="htmlContent"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import request from "@/utils/request";
import { marked } from "marked";

const loading = ref(false);
const aboutInfo = ref({});
const adminAvatar = ref("");
const adminName = ref("");

// 获取关于我的信息
const fetchAboutInfo = async () => {
  loading.value = true;
  try {
    await request.get(
      "/config",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          aboutInfo.value = data || {};
        },
      },
    );
  } catch (error) {
    console.error("获取关于我信息失败:", error);
  } finally {
    loading.value = false;
  }
};

// 获取管理员头像
const fetchAdminAvatar = async () => {
  try {
    await request.get(
      "/user/admin/avatar",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          adminAvatar.value = data.avatar || "";
          adminName.value = data.name || "";
        },
      },
    );
  } catch (error) {
    console.error("获取管理员头像失败:", error);
  }
};

// 获取图片URL
const baseAPI = process.env.VUE_APP_BASE_API || "/api";
const getImageUrl = (path) => {
  if (!path) return "";
  return baseAPI + path;
};

// 管理员头像URL
const adminAvatarUrl = computed(() => {
  return adminAvatar.value ? getImageUrl(adminAvatar.value) : "";
});

// 将markdown转换为html
const htmlContent = computed(() => {
  if (!aboutInfo.value.about_content) return "<p>暂无内容</p>";
  return marked(aboutInfo.value.about_content);
});

// 生命周期钩子
onMounted(() => {
  fetchAboutInfo();
  fetchAdminAvatar();
  document.title = "关于博主 - 个人博客";
});
</script>

<style scoped>
.about-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  min-height: 100vh;
}

/* 标题区域样式 */
.title-container {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
  padding: 30px 0;
}

.page-title {
  font-size: 36px;
  font-weight: 500;
  color: #59a6e6;
  margin: 0;
  letter-spacing: 2px;
  font-family: "萝莉体 第二版", "Monaco", monospace;
  position: relative;
  display: inline-block;
}

.title-decorations {
  position: relative;
  margin-bottom: 15px;
}

.decoration-left,
.decoration-right {
  font-size: 24px;
  color: #3877ab;
  position: relative;
  display: inline-block;
  margin: 0 20px;
  font-family: "Consolas", "Monaco", monospace;
}

.decoration-left::before,
.decoration-right::before {
  content: "";
  height: 1px;
  width: 60px;
  background: linear-gradient(to right, transparent, #3877ab, transparent);
  position: absolute;
  top: 50%;
}

.decoration-left::before {
  right: 30px;
}

.decoration-right::before {
  left: 30px;
}

.about-content {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

/* 个人资料卡片样式 */
.profile-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 40px 20px;
  text-align: center;
  position: relative;
  border: 1px solid #eaeaea;
  overflow: hidden;
}

.avatar-wrapper {
  margin-bottom: 20px;
  position: relative;
  display: inline-block;
}

.avatar {
  border: 4px solid rgba(89, 166, 230, 0.2);
  transition: transform 0.3s ease;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.avatar:hover {
  transform: scale(1.05);
}

.name {
  font-size: 28px;
  margin: 0 0 10px;
  font-weight: 600;
  color: #333;
}

.job {
  font-size: 18px;
  margin-bottom: 16px;
  color: #666;
  font-weight: 400;
}

.intro {
  max-width: 600px;
  margin: 0 auto 24px;
  line-height: 1.8;
  font-size: 16px;
  color: #555;
  padding: 0 20px;
}

.social-links {
  display: flex;
  justify-content: center;
  gap: 16px;
  flex-wrap: wrap;
}

.social-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background-color: #e3f1fd;
  border-radius: 20px;
  color: #3877ab;
  text-decoration: none;
  transition: all 0.3s ease;
  border: 1px solid transparent;
}

.social-item:hover {
  background-color: #c7e2fa;
  color: #3877ab;
  border-color: #59a6e6;
  transform: translateY(-2px);
}

/* 详细介绍样式 */
.detail-section {
  background-color: #fff;
  padding: 30px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.section-title {
  margin: 0;
  font-size: 24px;
  color: #333;
  font-weight: 600;
}

:deep(.markdown-content) {
  line-height: 1.8;
  color: #333;
}

:deep(.markdown-content h1),
:deep(.markdown-content h2),
:deep(.markdown-content h3) {
  margin-top: 28px;
  margin-bottom: 20px;
  font-weight: 600;
  line-height: 1.4;
  color: #222;
}

:deep(.markdown-content h1) {
  font-size: 2em;
  border-bottom: 2px solid #eee;
  padding-bottom: 0.5em;
}

:deep(.markdown-content h2) {
  font-size: 1.5em;
  border-bottom: 1px solid #eee;
  padding-bottom: 0.5em;
}

:deep(.markdown-content h3) {
  font-size: 1.25em;
}

:deep(.markdown-content p) {
  margin: 16px 0;
  line-height: 1.8;
}

:deep(.markdown-content a) {
  color: #59a6e6;
  text-decoration: none;
  border-bottom: 1px solid #59a6e6;
  transition: all 0.3s ease;
}

:deep(.markdown-content a:hover) {
  color: #2980b9;
  border-color: #2980b9;
}

:deep(.markdown-content img) {
  max-width: 100%;
  border-radius: 8px;
  margin: 20px 0;
  border: 1px solid #eaeaea;
}

:deep(.markdown-content blockquote) {
  padding: 16px 24px;
  margin: 24px 0;
  background: #f8f9fa;
  border-left: 4px solid #59a6e6;
  border-radius: 4px;
}

:deep(.markdown-content code) {
  background: #f8f9fa;
  padding: 3px 6px;
  border-radius: 4px;
  font-size: 0.9em;
  color: #333;
  font-family: "Consolas", "Monaco", monospace;
}

:deep(.markdown-content pre) {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  overflow-x: auto;
  margin: 24px 0;
  border: 1px solid #eaeaea;
}

:deep(.markdown-content pre code) {
  background: none;
  padding: 0;
}

@media (max-width: 768px) {
  .about-content {
    padding: 0;
  }

  .profile-section {
    padding: 30px 15px;
  }

  .detail-section {
    padding: 20px;
  }

  .name {
    font-size: 24px;
  }

  .job {
    font-size: 16px;
  }

  .social-links {
    gap: 10px;
  }

  .social-item {
    padding: 6px 12px;
    font-size: 14px;
  }

  .page-title {
    font-size: 28px;
  }

  .decoration-left,
  .decoration-right {
    font-size: 20px;
    margin: 0 10px;
  }

  .decoration-left::before,
  .decoration-right::before {
    width: 40px;
  }

  .decoration-left::before {
    right: 25px;
  }

  .decoration-right::before {
    left: 25px;
  }
}
</style>
