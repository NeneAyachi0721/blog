<template>
  <div class="user-profile">
    <h2>个人资料</h2>
    
    <el-form 
      :model="userForm" 
      :rules="rules" 
      ref="userFormRef" 
      label-width="100px"
      class="profile-form"
    >
      <el-form-item label="头像">
        <div class="avatar-container">
          <el-avatar :size="100" :src="avatarUrl" />
          <div class="avatar-upload">
            <el-upload
              class="avatar-uploader"
              action="#"
              :auto-upload="true"
              :show-file-list="false"
              :http-request="customUploadAvatar"
              :before-upload="beforeAvatarUpload"
            >
              <el-button size="small" type="primary">更换头像</el-button>
            </el-upload>
          </div>
        </div>
      </el-form-item>
      
      <el-form-item label="用户名" prop="username">
        <el-input v-model="userForm.username" disabled />
      </el-form-item>
      
      <el-form-item label="姓名" prop="name">
        <el-input v-model="userForm.name" />
      </el-form-item>
      
      <el-form-item label="邮箱" prop="email">
        <el-input v-model="userForm.email" />
      </el-form-item>
      
      <el-form-item label="手机号" prop="phone">
        <el-input v-model="userForm.phone" />
      </el-form-item>
      
      <el-form-item label="性别" prop="sex">
        <el-radio-group v-model="userForm.sex">
          <el-radio label="男">男</el-radio>
          <el-radio label="女">女</el-radio>
          <el-radio label="保密">保密</el-radio>
        </el-radio-group>
      </el-form-item>
      
      <el-form-item>
        <el-button type="primary" @click="submitForm" :loading="loading">保存修改</el-button>
      </el-form-item>
    </el-form>
    
    <div class="user-stats">
      <h3>我的数据</h3>
      <el-row :gutter="20">
        <el-col :span="8">
          <el-card shadow="hover" @click="goToLikes">
            <div class="stat-item">
              <el-icon class="stat-icon"><ThumbUp /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ stats.likeCount }}</div>
                <div class="stat-label">点赞</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card shadow="hover" @click="goToCollections">
            <div class="stat-item">
              <el-icon class="stat-icon"><Star /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ stats.collectCount }}</div>
                <div class="stat-label">收藏</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card shadow="hover" @click="goToComments">
            <div class="stat-item">
              <el-icon class="stat-icon"><ChatDotRound /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ stats.commentCount }}</div>
                <div class="stat-label">评论</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'
import { ThumbUp, Star, ChatDotRound } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const userFormRef = ref(null)
const loading = ref(false)

// 用户表单数据
const userForm = reactive({
  id: '',
  username: '',
  name: '',
  email: '',
  phone: '',
  sex: '',
  avatar: ''
})

// 表单验证规则
const rules = {
  name: [
    { max: 50, message: '姓名长度不能超过50个字符', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
}

// 用户统计数据
const stats = reactive({
  likeCount: 0,
  collectCount: 0,
  commentCount: 0
})

// 头像（文件）地址
const baseAPI = process.env.VUE_APP_BASE_API || "/api";
const avatarUrl = computed(() => {
  return userForm.avatar ? baseAPI + userForm.avatar : baseAPI + '/img/avatar/default.png';
});

// 获取用户信息
const getUserInfo = async () => {
  loading.value = true
  try {
    await request.get('/user/info', {}, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        Object.assign(userForm, data)
      }
    })
  } catch (error) {
    console.error('获取用户信息失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取用户统计数据
const getUserStats = async () => {
  try {
    await request.get('/user/stats', {}, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        Object.assign(stats, data)
      }
    })
  } catch (error) {
    console.error('获取用户统计数据失败:', error)
  }
}

// 上传头像前的校验
const beforeAvatarUpload = (file) => {
  const isJPG = file.type === "image/jpeg";
  const isPNG = file.type === "image/png";
  const isLt2M = file.size / 1024 / 1024 < 2;

  if (!isJPG && !isPNG) {
    ElMessage.error("头像只能是 JPG 或 PNG 格式!");
    return false;
  }
  if (!isLt2M) {
    ElMessage.error("头像大小不能超过 2MB!");
    return false;
  }
  return true;
};

// 自定义头像上传方法
const customUploadAvatar = async (options) => {
  try {
    const { file } = options;

    // 创建 FormData 对象
    const formData = new FormData();
    formData.append("file", file);

    // 设置自定义上传选项
    const uploadOptions = {
      headers: {
        token: localStorage.getItem("token") || "",
      },
      // 不进行JSON处理
      transformRequest: [(data) => data],
      // 自定义成功消息
      successMsg: "头像上传成功",
      // 自定义错误消息
      errorMsg: "头像上传失败",
      // 成功回调
      onSuccess: async (data) => {
        // 更新用户头像
        userForm.avatar = data;

        // 保存到后端
        await updateUserAvatar(data);

        // 通知上传成功
        options.onSuccess({ data });
      },
      // 错误回调
      onError: (error) => {
        console.error("头像上传错误:", error);
        options.onError(new Error(error.message || "上传失败"));
      },
    };

    // 发送上传请求
    await request.post("/file/upload/img", formData, uploadOptions);
  } catch (error) {
    options.onError(error);
    console.error("头像上传过程发生错误:", error);
  }
};

// 更新用户头像信息
const updateUserAvatar = async (avatarPath) => {
  try {
    await request.put(
      `/user/${userForm.id}`,
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
      }
    );
  } catch (error) {
    console.error("头像信息保存失败", error);
    ElMessage.error("头像信息保存失败");
    throw error;
  }
};

// 提交表单
const submitForm = () => {
  userFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        await request.put(`/user/${userForm.id}`, userForm, {
          successMsg: '保存成功',
          onSuccess: (data) => {
            // 更新本地用户信息
            userStore.updateUserInfo({
              ...userStore.userInfo,
              name: userForm.name,
              email: userForm.email,
              phone: userForm.phone,
              sex: userForm.sex
            })
          }
        })
      } catch (error) {
        console.error('保存用户信息失败:', error)
      } finally {
        loading.value = false
      }
    }
  })
}

// 跳转到我的点赞页面
const goToLikes = () => {
  router.push('/profile/likes')
}

// 跳转到我的收藏页面
const goToCollections = () => {
  router.push('/profile/collections')
}

// 跳转到我的评论页面
const goToComments = () => {
  router.push('/profile/comments')
}

onMounted(() => {
  getUserInfo()
  getUserStats()
})
</script>

<style scoped>
.user-profile {
  max-width: 800px;
}

h2 {
  margin-bottom: 20px;
  font-size: 24px;
  font-weight: 500;
}

.profile-form {
  margin-bottom: 40px;
}

.avatar-container {
  display: flex;
  align-items: center;
}

.avatar-upload {
  margin-left: 20px;
}

.user-stats {
  margin-top: 30px;
}

h3 {
  margin-bottom: 15px;
  font-size: 18px;
  font-weight: 500;
}

.stat-item {
  display: flex;
  align-items: center;
  padding: 10px;
  cursor: pointer;
}

.stat-icon {
  font-size: 32px;
  margin-right: 15px;
  color: #409EFF;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.stat-label {
  color: #909399;
  margin-top: 5px;
}

.el-card {
  transition: all 0.3s;
}

.el-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}
</style> 