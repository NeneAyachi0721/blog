<template>
  <div class="category-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>分类管理</span>
          <el-button type="primary" @click="handleAdd">新增分类</el-button>
        </div>
      </template>

      <el-table
        :data="categoryList"
        style="width: 100%"
        v-loading="loading"
        border
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="分类名称" />
        <el-table-column
          prop="description"
          label="分类描述"
          show-overflow-tooltip
        />
        <el-table-column prop="parentId" label="父分类ID" width="100" />
        <el-table-column prop="orderNum" label="排序" width="80" />
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
              title="确定删除该分类吗？"
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

    <!-- 分类表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增分类' : '编辑分类'"
      width="500px"
    >
      <el-form
        ref="categoryFormRef"
        :model="categoryForm"
        :rules="categoryRules"
        label-width="80px"
      >
        <el-form-item label="名称" prop="name">
          <el-input v-model="categoryForm.name" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="categoryForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
          />
        </el-form-item>
        <el-form-item label="父分类">
          <el-select
            v-model="categoryForm.parentId"
            placeholder="请选择父分类"
            style="width: 100%"
          >
            <el-option :value="0" label="无（顶级分类）" />
            <el-option
              v-for="item in parentOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id"
              :disabled="dialogType === 'edit' && categoryForm.id === item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="排序" prop="orderNum">
          <el-input-number v-model="categoryForm.orderNum" :min="0" :max="99" />
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
import { ref, reactive, onMounted, computed } from "vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";

// 加载状态
const loading = ref(false);
// 分类列表
const categoryList = ref([]);
// 对话框可见性
const dialogVisible = ref(false);
// 对话框类型（add / edit）
const dialogType = ref("add");
// 表单引用
const categoryFormRef = ref(null);
// 表单数据
const categoryForm = reactive({
  id: null,
  name: "",
  description: "",
  parentId: 0,
  orderNum: 0,
});
// 表单验证规则
const categoryRules = {
  name: [
    { required: true, message: "请输入分类名称", trigger: "blur" },
    { min: 2, max: 50, message: "长度在 2 到 50 个字符", trigger: "blur" },
  ],
  description: [
    { max: 200, message: "长度不能超过 200 个字符", trigger: "blur" },
  ],
  orderNum: [{ required: true, message: "请输入排序号", trigger: "blur" }],
};

// 父分类选项，排除当前编辑的分类
const parentOptions = computed(() => {
  if (dialogType.value === "edit") {
    return categoryList.value.filter((item) => item.id !== categoryForm.id);
  }
  return categoryList.value;
});

// 初始化
onMounted(() => {
  fetchCategoryList();
});

// 获取分类列表
const fetchCategoryList = async () => {
  loading.value = true;
  try {
    const res = await request.get(
      "/category",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          categoryList.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取分类列表失败:", error);
  } finally {
    loading.value = false;
  }
};

// 重置表单
const resetForm = () => {
  categoryForm.id = null;
  categoryForm.name = "";
  categoryForm.description = "";
  categoryForm.parentId = 0;
  categoryForm.orderNum = 0;

  if (categoryFormRef.value) {
    categoryFormRef.value.resetFields();
  }
};

// 处理添加分类
const handleAdd = () => {
  dialogType.value = "add";
  resetForm();
  dialogVisible.value = true;
};

// 处理编辑分类
const handleEdit = (row) => {
  dialogType.value = "edit";
  resetForm();

  // 填充表单数据
  categoryForm.id = row.id;
  categoryForm.name = row.name;
  categoryForm.description = row.description;
  categoryForm.parentId = row.parentId;
  categoryForm.orderNum = row.orderNum;

  dialogVisible.value = true;
};

// 处理删除分类
const handleDelete = async (row) => {
  try {
    await request.delete(`/category/${row.id}`, {
      successMsg: "删除成功",
      onSuccess: () => {
        fetchCategoryList();
      },
    });
  } catch (error) {
    console.error("删除分类失败:", error);
  }
};

// 提交表单
const submitForm = () => {
  categoryFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === "add") {
          // 新增分类
          await request.post("/category", categoryForm, {
            successMsg: "添加成功",
            onSuccess: () => {
              dialogVisible.value = false;
              fetchCategoryList();
            },
          });
        } else {
          // 更新分类
          await request.put(`/category/${categoryForm.id}`, categoryForm, {
            successMsg: "更新成功",
            onSuccess: () => {
              dialogVisible.value = false;
              fetchCategoryList();
            },
          });
        }
      } catch (error) {
        console.error("保存分类失败:", error);
      }
    }
  });
};
</script>

<style scoped>
.category-container {
  padding: 24px;
}

.box-card {
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
  margin-top: 16px;
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

:deep(.el-select .el-input__wrapper) {
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1);
}

:deep(.el-select .el-input__wrapper:hover),
:deep(.el-select .el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #333;
}

:deep(.el-input-number .el-input__wrapper) {
  box-shadow: none;
}

:deep(.el-input-number__decrease),
:deep(.el-input-number__increase) {
  border-color: rgba(0, 0, 0, 0.1);
  color: #666;
}

:deep(.el-input-number__decrease:hover),
:deep(.el-input-number__increase:hover) {
  color: #333;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>
