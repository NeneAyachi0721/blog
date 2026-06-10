<template>
  <div class="tag-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>标签管理</span>
          <el-button type="primary" @click="handleAdd">新增标签</el-button>
        </div>
      </template>

      <el-table :data="tagList" style="width: 100%" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="标签名称" />
        <el-table-column label="标签颜色" width="120">
          <template #default="scope">
            <div
              class="color-preview"
              :style="{ backgroundColor: scope.row.color }"
            ></div>
            <span>{{ scope.row.color }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="articleCount" label="文章数量" width="100" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="handleEdit(scope.row)"
              >编辑</el-button
            >
            <el-popconfirm
              title="确定删除该标签吗？"
              @confirm="handleDelete(scope.row)"
              width="220"
            >
              <template #reference>
                <el-button type="danger" size="small">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 标签表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增标签' : '编辑标签'"
      width="500px"
    >
      <el-form
        ref="tagFormRef"
        :model="tagForm"
        :rules="tagRules"
        label-width="80px"
      >
        <el-form-item label="名称" prop="name">
          <el-input v-model="tagForm.name" placeholder="请输入标签名称" />
        </el-form-item>
        <el-form-item label="颜色" prop="color">
          <el-color-picker v-model="tagForm.color" show-alpha />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";

// 加载状态
const loading = ref(false);
// 标签列表
const tagList = ref([]);
// 对话框可见性
const dialogVisible = ref(false);
// 对话框类型（add / edit）
const dialogType = ref("add");
// 表单引用
const tagFormRef = ref(null);
// 表单数据
const tagForm = reactive({
  id: null,
  name: "",
  color: "#59a6e6",
});
// 表单验证规则
const tagRules = {
  name: [
    { required: true, message: "请输入标签名称", trigger: "blur" },
    { min: 1, max: 50, message: "长度在 1 到 50 个字符", trigger: "blur" },
  ],
  color: [{ required: true, message: "请选择标签颜色", trigger: "change" }],
};

// 初始化
onMounted(() => {
  fetchTagList();
});

// 获取标签列表
const fetchTagList = async () => {
  loading.value = true;
  try {
    const res = await request.get(
      "/tag",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          tagList.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取标签列表失败:", error);
  } finally {
    loading.value = false;
  }
};

// 重置表单
const resetForm = () => {
  tagForm.id = null;
  tagForm.name = "";
  tagForm.color = "#59a6e6";

  if (tagFormRef.value) {
    tagFormRef.value.resetFields();
  }
};

// 处理添加标签
const handleAdd = () => {
  dialogType.value = "add";
  resetForm();
  dialogVisible.value = true;
};

// 处理编辑标签
const handleEdit = (row) => {
  dialogType.value = "edit";
  resetForm();

  // 填充表单数据
  tagForm.id = row.id;
  tagForm.name = row.name;
  tagForm.color = row.color;

  dialogVisible.value = true;
};

// 处理删除标签
const handleDelete = async (row) => {
  try {
    await request.delete(`/tag/${row.id}`, {
      successMsg: "删除成功",
      onSuccess: () => {
        fetchTagList();
      },
    });
  } catch (error) {
    console.error("删除标签失败:", error);
  }
};

// 提交表单
const submitForm = () => {
  tagFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === "add") {
          // 新增标签
          await request.post("/tag", tagForm, {
            successMsg: "添加成功",
            onSuccess: () => {
              dialogVisible.value = false;
              fetchTagList();
            },
          });
        } else {
          // 更新标签
          await request.put(`/tag/${tagForm.id}`, tagForm, {
            successMsg: "更新成功",
            onSuccess: () => {
              dialogVisible.value = false;
              fetchTagList();
            },
          });
        }
      } catch (error) {
        console.error("保存标签失败:", error);
      }
    }
  });
};
</script>

<style scoped>
.tag-container {
  padding: 24px;
}

.box-card {
  margin-bottom: 24px;
  border-radius: 8px;
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

.color-preview {
  display: inline-block;
  width: 20px;
  height: 20px;
  border-radius: 4px;
  margin-right: 8px;
  vertical-align: middle;
  border: 1px solid rgba(0, 0, 0, 0.1);
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

:deep(.el-button--danger) {
  background-color: #f56c6c;
  border-color: #f56c6c;
}

:deep(.el-button--danger:hover),
:deep(.el-button--danger:focus) {
  background-color: #d33030;
  border-color: #d33030;
}

/* 对话框样式 */
:deep(.el-dialog) {
  border-radius: 8px;
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

:deep(.el-color-picker__trigger) {
  border-color: rgba(0, 0, 0, 0.1);
  border-radius: 4px;
}

:deep(.el-color-picker__trigger:hover) {
  border-color: #333;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>
