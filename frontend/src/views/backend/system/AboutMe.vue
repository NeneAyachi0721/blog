<template>
  <div class="about-me-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>关于我页面设置</span>
          <el-button type="primary" @click="saveAboutMe" :loading="saving"
            >保存设置</el-button
          >
        </div>
      </template>

      <div v-loading="loading">
        <!-- 个人信息卡片 -->
        <h3>个人基本信息</h3>
        <el-form :model="form" label-width="120px">
          <el-form-item label="个人头像">
            <el-upload
              class="avatar-uploader"
              action="#"
              :auto-upload="true"
              :show-file-list="false"
              :http-request="customUploadAvatar"
              :before-upload="beforeAvatarUpload"
            >
              <el-image
                v-if="userStore.userInfo?.avatar"
                :src="getUserAvatar()"
                class="avatar"
              />
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
            <div class="upload-tip">点击上传头像，建议尺寸：200×200px</div>
          </el-form-item>

          <el-form-item label="昵称">
            <el-input
              v-model="form.about_name"
              placeholder="请输入昵称"
            ></el-input>
          </el-form-item>

          <el-form-item label="职业">
            <el-input
              v-model="form.about_job"
              placeholder="请输入您的职业，如：全栈开发工程师"
            ></el-input>
          </el-form-item>

          <el-form-item label="个人简介">
            <el-input
              v-model="form.about_intro"
              type="textarea"
              :rows="3"
              placeholder="请输入个人简介，简单介绍自己"
            ></el-input>
          </el-form-item>
        </el-form>

        <!-- 内容编辑器 -->
        <h3>个人详细介绍</h3>
        <div class="editor-container">
          <v-md-editor
            v-model="form.about_content"
            height="500px"
          ></v-md-editor>
        </div>

        <!-- 社交信息 -->
        <h3>社交链接</h3>
        <el-form :model="form" label-width="120px">
          <el-form-item label="GitHub">
            <el-input
              v-model="form.social_github"
              placeholder="请输入GitHub主页链接"
            ></el-input>
          </el-form-item>

          <el-form-item label="Bilibili">
            <el-input
              v-model="form.social_bilibili"
              placeholder="请输入Bilibili主页链接"
            ></el-input>
          </el-form-item>

          <el-form-item label="Steam">
            <el-input
              v-model="form.social_steam"
              placeholder="请输入Steam主页链接"
            ></el-input>
          </el-form-item>

          <el-form-item label="邮箱">
            <el-input
              v-model="form.social_email"
              placeholder="请输入邮箱地址"
            ></el-input>
          </el-form-item>
        </el-form>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";
import { Plus } from "@element-plus/icons-vue";
import { useUserStore } from "@/store/user";

// 状态变量
const loading = ref(false);
const saving = ref(false);
const userStore = useUserStore();

// 表单数据
const form = reactive({
  about_name: "",
  about_job: "",
  about_intro: "",
  about_content: "",
  social_github: "",
  social_bilibili: "",
  social_steam: "",
  social_email: "",
});

// 获取关于我的配置
const fetchAboutMe = async () => {
  loading.value = true;
  try {
    await request.get(
      "/config",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          // 填充表单
          for (const key in form) {
            if (data[key]) {
              form[key] = data[key];
            }
          }
        },
      },
    );
  } catch (error) {
    console.error("获取关于我配置失败:", error);
  } finally {
    loading.value = false;
  }
};

// 保存关于我配置
const saveAboutMe = async () => {
  saving.value = true;
  try {
    // 使用当前用户的头像
    const configData = {
      ...form,
    };

    await request.put("/admin/config", configData, {
      successMsg: "保存配置成功",
      onSuccess: () => {
        fetchAboutMe();
      },
    });
  } catch (error) {
    console.error("保存关于我配置失败:", error);
  } finally {
    saving.value = false;
  }
};

// 上传头像前的校验
const beforeAvatarUpload = (file) => {
  const isJPG = file.type === "image/jpeg";
  const isPNG = file.type === "image/png";
  const isLt2M = file.size / 1024 / 1024 < 2;

  if (!isJPG && !isPNG) {
    ElMessage.error("头像只能是JPG或PNG格式!");
    return false;
  }
  if (!isLt2M) {
    ElMessage.error("头像大小不能超过2MB!");
    return false;
  }
  return true;
};

// 自定义上传头像 - 修改为更新用户头像
const customUploadAvatar = async (options) => {
  try {
    const { file } = options;
    const formData = new FormData();
    formData.append("file", file);

    await request.post("/file/upload/img", formData, {
      transformRequest: [(data) => data],
      headers: { token: localStorage.getItem("token") || "" },
      successMsg: "头像上传成功",
      onSuccess: async (data) => {
        // 更新用户头像而不是 about_avatar
        await updateUserAvatar(data);
        options.onSuccess();
      },
      onError: (error) => {
        options.onError(error);
      },
    });
  } catch (error) {
    options.onError(error);
  }
};

// 更新用户头像
const updateUserAvatar = async (avatarPath) => {
  try {
    const userId = userStore.userInfo.id;
    await request.put(
      `/user/${userId}`,
      { avatar: avatarPath },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          // 更新本地用户信息
          const updatedUserInfo = { ...userStore.userInfo, avatar: avatarPath };
          userStore.updateUserInfo(updatedUserInfo);
        },
        onError: (error) => {
          console.error("头像信息保存失败", error);
          ElMessage.error("头像信息保存失败");
        },
      },
    );
  } catch (error) {
    console.error("头像信息保存失败", error);
    ElMessage.error("头像信息保存失败");
    throw error;
  }
};

// 获取图片URL
const baseAPI = process.env.VUE_APP_BASE_API || "/api";
const getImageUrl = (path) => {
  if (!path) return "";
  return baseAPI + path;
};

// 获取用户头像
const getUserAvatar = () => {
  const avatar = userStore.userInfo?.avatar || "";
  return getImageUrl(avatar);
};

// 生命周期钩子
onMounted(() => {
  fetchAboutMe();
});
</script>

<style scoped>
.about-me-container {
  padding: 24px;
}

.box-card {
  margin-bottom: 24px;
  border-radius: 15px;
  border: 1px solid #eaeaea;
  box-shadow: none;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0;
  border-bottom: 1px solid #eaeaea;
}

.card-header span {
  font-size: 18px;
  font-weight: 500;
  color: #333;
}

:deep(.el-card__header) {
  padding: 0 20px;
}

:deep(.el-card__body) {
  padding: 24px;
}

h3 {
  margin-top: 28px;
  margin-bottom: 18px;
  font-weight: 500;
  color: #333;
  border-left: 3px solid #333;
  padding-left: 12px;
  font-size: 16px;
}

:deep(.el-form-item__label) {
  color: #333;
  font-weight: 500;
}

:deep(.el-input__wrapper) {
  border-radius: 4px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
}

:deep(.el-input__wrapper:hover),
:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #333;
}

:deep(.el-textarea__inner) {
  border-radius: 4px;
  transition: all 0.3s;
}

:deep(.el-textarea__inner:hover),
:deep(.el-textarea__inner:focus) {
  border-color: #333;
}

:deep(.el-button) {
  border-radius: 4px;
  font-weight: 500;
  transition: all 0.3s;
}

:deep(.el-button--primary) {
  background-color: #333;
  border-color: #333;
}

:deep(.el-button--primary:hover),
:deep(.el-button--primary:focus) {
  background-color: #000;
  border-color: #000;
}

.editor-container {
  margin-bottom: 24px;
  border-radius: 4px;
  overflow: hidden;
}

:deep(.v-md-editor) {
  border-radius: 4px;
  border-color: #eaeaea !important;
}

:deep(.v-md-editor__toolbar) {
  border-bottom-color: #eaeaea !important;
}

/* 上传样式 */
.avatar-uploader {
  width: 150px;
  height: 150px;
  border: 1px dashed #d9d9d9;
  border-radius: 15px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  display: inline-block;
  transition: all 0.3s;
}

.avatar-uploader:hover {
  border-color: #333;
  background-color: #f8f8f8;
}

.avatar {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #666;
  width: 150px;
  height: 150px;
  line-height: 150px;
  text-align: center;
}

.upload-tip {
  font-size: 12px;
  color: #666;
  margin-top: 8px;
}
</style>
