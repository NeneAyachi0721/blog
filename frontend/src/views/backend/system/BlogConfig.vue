<template>
  <div class="blog-config-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>博客基本设置</span>
          <el-button type="primary" @click="saveConfig" :loading="saving"
            >保存设置</el-button
          >
        </div>
      </template>

      <el-form :model="configForm" label-width="120px" v-loading="loading">
        <el-form-item label="博客名称">
          <el-input
            v-model="configForm.blog_name"
            placeholder="请输入博客名称"
          ></el-input>
        </el-form-item>

        <el-form-item label="博客描述">
          <el-input
            v-model="configForm.blog_description"
            type="textarea"
            placeholder="请输入博客描述"
          ></el-input>
        </el-form-item>

        <el-form-item label="博客作者">
          <el-input
            v-model="configForm.blog_author"
            placeholder="请输入博客作者"
          ></el-input>
        </el-form-item>

        <el-form-item label="页脚信息">
          <el-input
            v-model="configForm.blog_footer"
            type="textarea"
            placeholder="请输入页脚信息"
          ></el-input>
        </el-form-item>

        <el-form-item label="ICP备案号">
          <el-input
            v-model="configForm.blog_icp"
            placeholder="请输入ICP备案号（选填）"
          ></el-input>
        </el-form-item>

        <el-form-item label="公安备案号">
          <el-input
            v-model="configForm.blog_gongan"
            placeholder="请输入公安备案号（选填）"
          ></el-input>
        </el-form-item>

        <el-form-item label="SEO关键词">
          <el-input
            v-model="configForm.blog_keywords"
            type="textarea"
            placeholder="请输入SEO关键词，多个关键词用英文逗号分隔"
          ></el-input>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 高级设置卡片 -->
    <el-card class="box-card mt-20">
      <template #header>
        <div class="card-header">
          <span>高级设置</span>
          <el-button type="primary" @click="addConfigDialogVisible = true"
            >添加配置</el-button
          >
        </div>
      </template>

      <el-table :data="advancedConfigList" border style="width: 100%">
        <el-table-column
          prop="key"
          label="配置键"
          width="180"
        ></el-table-column>
        <el-table-column prop="value" label="配置值"></el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button type="primary" link @click="editConfig(scope.row)">
              编辑
            </el-button>
            <el-button
              type="danger"
              link
              @click="confirmDeleteConfig(scope.row.key)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 添加配置对话框 -->
    <el-dialog v-model="addConfigDialogVisible" title="添加配置" width="500px">
      <el-form
        :model="newConfig"
        label-width="80px"
        :rules="configRules"
        ref="addConfigFormRef"
      >
        <el-form-item label="配置键" prop="key">
          <el-input
            v-model="newConfig.key"
            placeholder="请输入配置键"
          ></el-input>
        </el-form-item>
        <el-form-item label="配置值" prop="value">
          <el-input
            v-model="newConfig.value"
            type="textarea"
            placeholder="请输入配置值"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addConfigDialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitAddConfig"
            :loading="addConfigLoading"
            >确定</el-button
          >
        </span>
      </template>
    </el-dialog>

    <!-- 编辑配置对话框 -->
    <el-dialog v-model="editConfigDialogVisible" title="编辑配置" width="500px">
      <el-form
        :model="editingConfig"
        label-width="80px"
        :rules="configRules"
        ref="editConfigFormRef"
      >
        <el-form-item label="配置键" prop="key">
          <el-input
            v-model="editingConfig.key"
            placeholder="请输入配置键"
            disabled
          ></el-input>
        </el-form-item>
        <el-form-item label="配置值" prop="value">
          <el-input
            v-model="editingConfig.value"
            type="textarea"
            placeholder="请输入配置值"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="editConfigDialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitEditConfig"
            :loading="editConfigLoading"
            >确定</el-button
          >
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";

// 状态变量
const loading = ref(false);
const saving = ref(false);
const addConfigDialogVisible = ref(false);
const editConfigDialogVisible = ref(false);
const addConfigLoading = ref(false);
const editConfigLoading = ref(false);
const addConfigFormRef = ref(null);
const editConfigFormRef = ref(null);

// 表单数据
const configForm = reactive({
  blog_name: "",
  blog_description: "",
  blog_author: "",
  blog_footer: "",
  blog_icp: "",
  blog_gongan: "",
  blog_keywords: "",
});

// 配置列表
const allConfigs = ref({});
const advancedConfigList = computed(() => {
  const basicKeys = [
    "blog_name",
    "blog_description",
    "blog_author",
    "blog_footer",
    "blog_icp",
    "blog_gongan",
    "blog_keywords",
  ];
  const result = [];

  for (const key in allConfigs.value) {
    if (!basicKeys.includes(key)) {
      result.push({
        key,
        value: allConfigs.value[key],
      });
    }
  }

  return result;
});

// 新配置
const newConfig = reactive({
  key: "",
  value: "",
});

// 编辑中的配置
const editingConfig = reactive({
  key: "",
  value: "",
});

// 验证规则
const configRules = {
  key: [
    { required: true, message: "请输入配置键", trigger: "blur" },
    { min: 2, max: 50, message: "长度在 2 到 50 个字符", trigger: "blur" },
  ],
  value: [{ required: true, message: "请输入配置值", trigger: "blur" }],
};

// 获取所有配置
const fetchAllConfigs = async () => {
  loading.value = true;
  try {
    await request.get(
      "/config",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          allConfigs.value = data;

          // 填充表单
          for (const key in configForm) {
            if (data[key]) {
              configForm[key] = data[key];
            }
          }
        },
      },
    );
  } catch (error) {
    console.error("获取配置失败:", error);
  } finally {
    loading.value = false;
  }
};

// 保存配置
const saveConfig = async () => {
  saving.value = true;
  try {
    await request.put("/admin/config", configForm, {
      successMsg: "保存配置成功",
      onSuccess: () => {
        fetchAllConfigs();
      },
    });
  } catch (error) {
    console.error("保存配置失败:", error);
  } finally {
    saving.value = false;
  }
};

// 打开编辑配置对话框
const editConfig = (row) => {
  editingConfig.key = row.key;
  editingConfig.value = row.value;
  editConfigDialogVisible.value = true;
};

// 提交编辑配置
const submitEditConfig = async () => {
  editConfigFormRef.value.validate(async (valid) => {
    if (valid) {
      editConfigLoading.value = true;
      try {
        const configMap = {};
        configMap[editingConfig.key] = editingConfig.value;

        await request.put("/admin/config", configMap, {
          successMsg: "更新配置成功",
          onSuccess: () => {
            editConfigDialogVisible.value = false;
            fetchAllConfigs();
          },
        });
      } catch (error) {
        console.error("更新配置失败:", error);
      } finally {
        editConfigLoading.value = false;
      }
    }
  });
};

// 提交添加配置
const submitAddConfig = async () => {
  addConfigFormRef.value.validate(async (valid) => {
    if (valid) {
      addConfigLoading.value = true;
      try {
        await request.post(
          "/admin/config?key=" + newConfig.key + "&value=" + newConfig.value,
          null,
          {
            successMsg: "添加配置成功",
            onSuccess: () => {
              addConfigDialogVisible.value = false;
              fetchAllConfigs();

              // 重置表单
              newConfig.key = "";
              newConfig.value = "";
              if (addConfigFormRef.value) {
                addConfigFormRef.value.resetFields();
              }
            },
          },
        );
      } catch (error) {
        console.error("添加配置失败:", error);
      } finally {
        addConfigLoading.value = false;
      }
    }
  });
};

// 确认删除配置
const confirmDeleteConfig = (key) => {
  ElMessageBox.confirm("确定要删除该配置吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      deleteConfig(key);
    })
    .catch(() => {});
};

// 删除配置
const deleteConfig = async (key) => {
  try {
    await request.delete(`/admin/config/${key}`, {
      successMsg: "删除配置成功",
      onSuccess: () => {
        fetchAllConfigs();
      },
    });
  } catch (error) {
    console.error("删除配置失败:", error);
  }
};

// 生命周期钩子
onMounted(() => {
  fetchAllConfigs();
});
</script>

<style scoped>
.blog-config-container {
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

:deep(.el-table) {
  border-radius: 4px;
  overflow: hidden;
  border: 1px solid #eaeaea;
}

:deep(.el-table th) {
  background-color: #f8f8f8;
  font-weight: 500;
  color: #333;
  border-bottom: 1px solid #eaeaea;
}

:deep(.el-table td) {
  border-bottom: 1px solid #eaeaea;
}

:deep(.el-table--border .el-table__cell) {
  border-right: 1px solid #eaeaea;
}

:deep(.el-table__row:hover td) {
  background-color: #f8f9fa;
}

:deep(.el-button--primary.is-link) {
  color: #fff;
}

:deep(.el-button--primary.is-link:hover) {
  color: #000000;
}

:deep(.el-button--danger.is-link) {
  color: #f56c6c;
}

:deep(.el-button--danger.is-link:hover) {
  color: #d33030;
}

/* 对话框样式 */
:deep(.el-dialog) {
  border-radius: 15px;
  overflow: hidden;
  box-shadow: none;
  border: 1px solid #eaeaea;
}

:deep(.el-dialog__header) {
  padding: 16px 20px;
  margin: 0;
  background-color: #f8f8f8;
  border-bottom: 1px solid #eaeaea;
}

:deep(.el-dialog__title) {
  color: #333;
  font-weight: 500;
  font-size: 16px;
}

:deep(.el-dialog__body) {
  padding: 24px;
}

:deep(.el-dialog__footer) {
  padding: 16px 20px;
  border-top: 1px solid #eaeaea;
}

:deep(.el-dialog__close) {
  color: #666;
}

:deep(.el-dialog__close:hover) {
  color: #333;
  background-color: #f0f0f0;
  border-radius: 50%;
}

.mt-20 {
  margin-top: 24px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>
