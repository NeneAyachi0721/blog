<template>
  <div class="friend-link-container">
    <div class="page-header">
      <h2>友情链接管理</h2>
      <el-button type="primary" @click="handleAdd">新增友链</el-button>
    </div>

    <!-- 搜索表单 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" ref="searchFormRef">
        <el-form-item label="链接名称">
          <el-input
            v-model="searchForm.name"
            placeholder="请输入链接名称"
            clearable
          ></el-input>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="显示" :value="1"></el-option>
            <el-option label="隐藏" :value="0"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 友链列表 -->
    <el-card class="list-card">
      <el-table
        :data="friendLinkList"
        border
        style="width: 100%"
        v-loading="loading"
      >
        <el-table-column type="index" width="50" label="#"></el-table-column>
        <el-table-column
          prop="name"
          label="链接名称"
          width="180"
        ></el-table-column>
        <el-table-column
          prop="url"
          label="链接地址"
          min-width="180"
          show-overflow-tooltip
        >
          <template #default="scope">
            <a :href="scope.row.url" target="_blank">{{ scope.row.url }}</a>
          </template>
        </el-table-column>
        <el-table-column prop="logo" label="链接LOGO" width="100">
          <template #default="scope">
            <el-image
              v-if="scope.row.logo"
              :src="getImageUrl(scope.row.logo)"
              style="width: 40px; height: 40px"
              fit="cover"
              :preview-teleported="true"
              :preview-src-list="[getImageUrl(scope.row.logo)]"
            ></el-image>
            <span v-else>无</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="description"
          label="链接描述"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column
          prop="orderNum"
          label="排序"
          width="80"
        ></el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
              {{ scope.row.status === 1 ? "显示" : "隐藏" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" link @click="handleEdit(scope.row)">
              编辑
            </el-button>
            <el-button type="primary" link @click="toggleStatus(scope.row)">
              {{ scope.row.status === 1 ? "隐藏" : "显示" }}
            </el-button>
            <el-button type="danger" link @click="handleDelete(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          background
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          :page-size="pageSize"
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        ></el-pagination>
      </div>
    </el-card>

    <!-- 编辑/新增对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑友情链接' : '新增友情链接'"
      width="600px"
    >
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="链接名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入链接名称"></el-input>
        </el-form-item>
        <el-form-item label="链接地址" prop="url">
          <el-input
            v-model="form.url"
            placeholder="请输入链接地址，以http://或https://开头"
          ></el-input>
        </el-form-item>
        <el-form-item label="链接LOGO">
          <el-upload
            class="avatar-uploader"
            action="#"
            :auto-upload="true"
            :show-file-list="false"
            :http-request="customUploadLogo"
            :preview-teleported="true"
            :before-upload="beforeLogoUpload"
          >
            <el-image
              v-if="form.logo"
              :src="getImageUrl(form.logo)"
              class="avatar"
            />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="upload-tip">点击上传图标，建议尺寸：40×40px</div>
        </el-form-item>
        <el-form-item label="链接描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            placeholder="请输入链接描述"
          ></el-input>
        </el-form-item>
        <el-form-item label="排序" prop="orderNum">
          <el-input-number
            v-model="form.orderNum"
            :min="0"
            :max="999"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">显示</el-radio>
            <el-radio :label="0">隐藏</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting"
            >确定</el-button
          >
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import request from "@/utils/request";
import { Plus } from "@element-plus/icons-vue";

// 状态变量
const loading = ref(false);
const submitting = ref(false);
const dialogVisible = ref(false);
const isEdit = ref(false);
const formRef = ref(null);
const searchFormRef = ref(null);

// 分页相关
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
const friendLinkList = ref([]);

// 搜索表单
const searchForm = reactive({
  name: "",
  status: null,
});

// 编辑表单
const form = reactive({
  id: null,
  name: "",
  url: "",
  logo: "",
  description: "",
  orderNum: 0,
  status: 1,
});

// 表单验证规则
const rules = {
  name: [
    { required: true, message: "请输入链接名称", trigger: "blur" },
    { min: 2, max: 50, message: "长度在 2 到 50 个字符", trigger: "blur" },
  ],
  url: [
    { required: true, message: "请输入链接地址", trigger: "blur" },
    {
      pattern: /^https?:\/\/.+/,
      message: "链接地址必须以http://或https://开头",
      trigger: "blur",
    },
  ],
  description: [{ max: 200, message: "描述最多200个字符", trigger: "blur" }],
  orderNum: [{ required: true, message: "请输入排序号", trigger: "blur" }],
  status: [{ required: true, message: "请选择状态", trigger: "change" }],
};

// 获取所有友情链接
const fetchFriendLinks = async () => {
  loading.value = true;
  try {
    await request.get(
      "/admin/friendLinks/page",
      {
        name: searchForm.name,
        status: searchForm.status,
        currentPage: currentPage.value,
        size: pageSize.value,
      },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          friendLinkList.value = data.records;
          total.value = data.total;
        },
      },
    );
  } catch (error) {
    console.error("获取友情链接失败:", error);
  } finally {
    loading.value = false;
  }
};

// 搜索
const handleSearch = () => {
  currentPage.value = 1;
  fetchFriendLinks();
};

// 重置搜索
const resetSearch = () => {
  searchForm.name = "";
  searchForm.status = null;
  currentPage.value = 1;
  fetchFriendLinks();
};

// 分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size;
  fetchFriendLinks();
};

// 页码变化
const handleCurrentChange = (page) => {
  currentPage.value = page;
  fetchFriendLinks();
};

// 添加友情链接
const handleAdd = () => {
  isEdit.value = false;
  resetForm();
  dialogVisible.value = true;
};

// 编辑友情链接
const handleEdit = (row) => {
  isEdit.value = true;
  resetForm();
  Object.assign(form, row);
  dialogVisible.value = true;
};

// 删除友情链接
const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除友情链接 "${row.name}" 吗？`, "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(async () => {
      try {
        await request.delete(`/admin/friendLinks/${row.id}`, {
          successMsg: "删除成功",
          onSuccess: () => {
            fetchFriendLinks();
          },
        });
      } catch (error) {
        console.error("删除友情链接失败:", error);
      }
    })
    .catch(() => {});
};

// 切换状态
const toggleStatus = async (row) => {
  const newStatus = row.status === 1 ? 0 : 1;
  try {
    await request.put(
      `/admin/friendLinks/${row.id}/status`,
      {
        status: newStatus,
      },
      {
        successMsg: "更新状态成功",
        onSuccess: () => {
          row.status = newStatus;
        },
      },
    );
  } catch (error) {
    console.error("更新状态失败:", error);
  }
};

// 重置表单
const resetForm = () => {
  form.id = null;
  form.name = "";
  form.url = "";
  form.logo = "";
  form.description = "";
  form.orderNum = 0;
  form.status = 1;

  if (formRef.value) {
    formRef.value.resetFields();
  }
};

// 提交表单
const submitForm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      submitting.value = true;
      try {
        if (isEdit.value) {
          // 更新
          await request.put(`/admin/friendLinks/${form.id}`, form, {
            successMsg: "更新友情链接成功",
            onSuccess: () => {
              dialogVisible.value = false;
              fetchFriendLinks();
            },
          });
        } else {
          // 新增
          await request.post("/admin/friendLinks", form, {
            successMsg: "新增友情链接成功",
            onSuccess: () => {
              dialogVisible.value = false;
              fetchFriendLinks();
            },
          });
        }
      } catch (error) {
        console.error("提交友情链接失败:", error);
      } finally {
        submitting.value = false;
      }
    }
  });
};

// 上传Logo前校验
const beforeLogoUpload = (file) => {
  const isJPG = file.type === "image/jpeg";
  const isPNG = file.type === "image/png";
  const isLt2M = file.size / 1024 / 1024 < 2;

  if (!isJPG && !isPNG) {
    ElMessage.error("Logo只能是JPG或PNG格式!");
    return false;
  }
  if (!isLt2M) {
    ElMessage.error("Logo大小不能超过2MB!");
    return false;
  }
  return true;
};

// 自定义上传Logo
const customUploadLogo = async (options) => {
  try {
    const { file } = options;
    const formData = new FormData();
    formData.append("file", file);

    await request.post("/file/upload/img", formData, {
      transformRequest: [(data) => data],
      headers: { token: localStorage.getItem("token") || "" },
      successMsg: "Logo上传成功",
      onSuccess: (data) => {
        form.logo = data;
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

// 获取图片URL
const baseAPI = process.env.VUE_APP_BASE_API || "/api";
const getImageUrl = (path) => {
  if (!path) return "";
  return baseAPI + path;
};

// 生命周期钩子
onMounted(() => {
  fetchFriendLinks();
});
</script>

<style scoped>
.friend-link-container {
  padding: 24px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-header h2 {
  font-size: 22px;
  font-weight: 500;
  color: #333;
  margin: 0;
}

.search-card {
  margin-bottom: 24px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  box-shadow: none;
}

.list-card {
  border-radius: 8px;
  border: 1px solid #eaeaea;
  box-shadow: none;
}

:deep(.el-card__header) {
  padding: 16px 20px;
  border-bottom: 1px solid #eaeaea;
}

:deep(.el-card__body) {
  padding: 20px;
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

:deep(.el-select .el-input__wrapper) {
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1);
}

:deep(.el-select .el-input__wrapper:hover),
:deep(.el-select .el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #333;
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

.pagination-container {
  margin-top: 24px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-pagination .el-pagination__total) {
  color: #666;
}

:deep(.el-pagination .el-pagination__jump) {
  color: #666;
}

:deep(.el-pagination .el-input__wrapper) {
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1);
}

:deep(.el-pagination .el-input__wrapper:hover),
:deep(.el-pagination .el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #333;
}

:deep(.el-pagination .el-pagination__sizes .el-input .el-input__wrapper) {
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1);
}

:deep(.el-pagination .el-pagination__sizes .el-input .el-input__wrapper:hover),
:deep(
    .el-pagination .el-pagination__sizes .el-input .el-input__wrapper.is-focus
  ) {
  box-shadow: 0 0 0 1px #333;
}

:deep(.el-pagination .btn-prev),
:deep(.el-pagination .btn-next) {
  background-color: transparent;
  color: #666;
}

:deep(.el-pagination .el-pager li) {
  background-color: transparent;
  color: #666;
  border-radius: 4px;
  font-weight: 400;
}

:deep(.el-pagination .el-pager li.is-active) {
  background-color: #333;
  color: #fff;
  font-weight: 500;
}

:deep(.el-pagination .el-pager li:hover) {
  color: #333;
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

:deep(.el-tag) {
  border: none;
  border-radius: 4px;
}

:deep(.el-tag--success) {
  background-color: rgba(103, 194, 58, 0.1);
  border-color: transparent;
  color: #67c23a;
}

:deep(.el-tag--info) {
  background-color: rgba(144, 147, 153, 0.1);
  border-color: transparent;
  color: #909399;
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

/* 上传样式 */
.avatar-uploader {
  width: 100px;
  height: 100px;
  border: 1px dashed #d9d9d9;
  border-radius: 8px;
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
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}

.upload-tip {
  font-size: 12px;
  color: #666;
  margin-top: 8px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>
