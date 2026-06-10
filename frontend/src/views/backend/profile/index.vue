<template>
  <div class="profile-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>个人信息</span>
        </div>
      </template>

      <el-form
        ref="profileFormRef"
        :model="profileForm"
        :rules="profileRules"
        label-width="80px"
        v-loading="loading"
      >
        <el-row :gutter="20">
          <el-col :span="8">
            <div class="avatar-container">
              <el-avatar :size="120" :src="avatarUrl" />
              <div class="avatar-uploader">
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
              <div class="user-role">
                {{ profileForm.roleCode === "ADMIN" ? "管理员" : "普通用户" }}
              </div>
            </div>
          </el-col>

          <el-col :span="16">
            <el-form-item label="用户名" prop="username">
              <el-input v-model="profileForm.username" disabled />
            </el-form-item>

            <el-form-item label="昵称" prop="name">
              <el-input v-model="profileForm.name" placeholder="请输入昵称" />
            </el-form-item>

            <el-form-item label="邮箱" prop="email">
              <el-input v-model="profileForm.email" placeholder="请输入邮箱" />
            </el-form-item>

            <el-form-item label="性别">
              <el-radio-group v-model="profileForm.sex">
                <el-radio label="男">男</el-radio>
                <el-radio label="女">女</el-radio>
                <el-radio label="保密">保密</el-radio>
              </el-radio-group>
            </el-form-item>

            <el-form-item label="个人简介">
              <el-input
                v-model="profileForm.bio"
                type="textarea"
                :rows="3"
                placeholder="介绍一下自己吧"
              />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="saveProfile"
                >保存信息</el-button
              >
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>

    <el-card class="box-card password-card">
      <template #header>
        <div class="card-header">
          <span>修改密码</span>
        </div>
      </template>

      <el-form
        ref="passwordFormRef"
        :model="passwordForm"
        :rules="passwordRules"
        label-width="100px"
      >
        <el-form-item label="原密码" prop="oldPassword">
          <el-input
            v-model="passwordForm.oldPassword"
            type="password"
            placeholder="请输入原密码"
            show-password
          />
        </el-form-item>

        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            placeholder="请输入新密码"
            show-password
          />
        </el-form-item>

        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
          />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="changePassword">修改密码</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from "vue";
import { useUserStore } from "@/store/user";
import request from "@/utils/request";
import { ElMessage } from "element-plus";

const userStore = useUserStore();
const baseAPI = process.env.VUE_APP_BASE_API || "/api";

// 加载状态
const loading = ref(false);
// 表单引用
const profileFormRef = ref(null);
const passwordFormRef = ref(null);

// 个人信息表单
const profileForm = reactive({
  id: "",
  username: "",
  name: "",
  email: "",
  sex: "保密",
  avatar: "",
  bio: "",
  roleCode: "",
});

// 表单校验规则
const profileRules = {
  name: [{ max: 50, message: "昵称长度不能超过50个字符", trigger: "blur" }],
  email: [
    { type: "email", message: "请输入正确的邮箱地址", trigger: "blur" },
    { max: 50, message: "邮箱长度不能超过50个字符", trigger: "blur" },
  ],
  bio: [{ max: 200, message: "个人简介不能超过200个字符", trigger: "blur" }],
};

// 密码表单
const passwordForm = reactive({
  oldPassword: "",
  newPassword: "",
  confirmPassword: "",
});

// 密码表单校验规则
const passwordRules = {
  oldPassword: [{ required: true, message: "请输入原密码", trigger: "blur" }],
  newPassword: [
    { required: true, message: "请输入新密码", trigger: "blur" },
    { min: 6, max: 20, message: "密码长度在6到20个字符之间", trigger: "blur" },
  ],
  confirmPassword: [
    { required: true, message: "请再次输入新密码", trigger: "blur" },
    {
      validator: (rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error("两次输入的密码不一致"));
        } else {
          callback();
        }
      },
      trigger: "blur",
    },
  ],
};

// 头像（文件）地址
const avatarUrl = computed(() => {
  return baseAPI + profileForm.avatar;
});

// 初始化
onMounted(() => {
  getUserInfo();
});

// 获取用户信息
const getUserInfo = async () => {
  loading.value = true;
  try {
    // 从 userStore 获取当前用户ID
    const userId = userStore.userInfo?.id;

    if (!userId) {
      ElMessage.error("获取用户信息失败，请重新登录");
      return;
    }

    await request.get(
      `/user/${userId}`,
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          // 填充表单
          profileForm.id = data.id;
          profileForm.username = data.username;
          profileForm.name = data.name || "";
          profileForm.email = data.email || "";
          profileForm.sex = data.sex || "保密";
          profileForm.avatar = data.avatar || "";
          profileForm.bio = data.bio || "";
          profileForm.roleCode = data.roleCode;
        },
      },
    );
  } catch (error) {
    console.error("获取用户信息失败:", error);
    ElMessage.error("获取用户信息失败");
  } finally {
    loading.value = false;
  }
};

// 保存个人信息
const saveProfile = () => {
  profileFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        await request.put(`/user/${profileForm.id}`, profileForm, {
          successMsg: "个人信息保存成功",
          onSuccess: (data) => {
            // 更新store中的用户信息
            userStore.updateUserInfo({
              ...userStore.userInfo,
              name: profileForm.name,
              email: profileForm.email,
              sex: profileForm.sex,
              avatar: profileForm.avatar,
              bio: profileForm.bio,
            });
          },
        });
      } catch (error) {
        console.error("保存个人信息失败:", error);
      }
    }
  });
};

// 修改密码
const changePassword = () => {
  passwordFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        await request.put(
          "/user/password",
          {
            oldPassword: passwordForm.oldPassword,
            newPassword: passwordForm.newPassword,
          },
          {
            successMsg: "密码修改成功",
            onSuccess: () => {
              // 清空密码表单
              passwordForm.oldPassword = "";
              passwordForm.newPassword = "";
              passwordForm.confirmPassword = "";

              // 重置表单校验状态
              passwordFormRef.value.resetFields();
            },
          },
        );
      } catch (error) {
        console.error("修改密码失败:", error);
      }
    }
  });
};

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
        profileForm.avatar = data;

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
      `/user/${profileForm.id}`,
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
</script>

<style scoped>
.profile-container {
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

:deep(.el-input__wrapper.is-disabled) {
  background-color: #f8f8f8;
  color: #666;
}

:deep(.el-textarea__inner) {
  border-radius: 4px;
  transition: all 0.3s;
}

:deep(.el-textarea__inner:hover),
:deep(.el-textarea__inner:focus) {
  border-color: #333;
}

:deep(.el-radio__input.is-checked .el-radio__inner) {
  background-color: #333;
  border-color: #333;
}

:deep(.el-radio__input.is-focus .el-radio__inner) {
  border-color: #333;
}

:deep(.el-radio__inner:hover) {
  border-color: #333;
}

:deep(.el-radio__label) {
  color: #666;
}

:deep(.el-radio__input.is-checked + .el-radio__label) {
  color: #333;
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

.avatar-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 15px;
  border: 1px solid #eaeaea;
}

:deep(.el-avatar) {
  border: 2px solid #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  background-color: #f0f0f0;
}

.avatar-uploader {
  margin-top: 20px;
  margin-bottom: 15px;
}

.user-role {
  margin-top: 10px;
  font-size: 14px;
  color: #666;
  padding: 4px 12px;
  background-color: #f0f0f0;
  border-radius: 20px;
}

.password-card {
  margin-top: 24px;
}
</style>
