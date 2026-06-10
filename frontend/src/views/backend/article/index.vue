<template>
  <div class="article-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>文章管理</span>
          <el-button
            type="primary"
            @click="$router.push('/back/article/create')"
            >写文章</el-button
          >
        </div>
      </template>

      <!-- 搜索表单 -->
      <div class="search-form">
        <el-form :inline="true" :model="searchForm">
          <el-form-item>
            <el-input
              v-model="searchForm.title"
              placeholder="文章标题"
              clearable
            />
          </el-form-item>
          <el-form-item>
            <el-select
              v-model="searchForm.categoryId"
              placeholder="文章分类"
              clearable
              style="width: 160px"
            >
              <el-option
                v-for="item in categoryOptions"
                :key="item.id"
                :label="item.name"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-select
              v-model="searchForm.status"
              placeholder="文章状态"
              clearable
              style="width: 160px"
            >
              <el-option :value="0" label="草稿" />
              <el-option :value="1" label="已发布" />
              <el-option :value="2" label="已删除" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="fetchArticleList(1)"
              >搜索</el-button
            >
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 文章列表 -->
      <el-table
        :data="articleList"
        style="width: 100%"
        v-loading="loading"
        border
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="封面" width="100">
          <template #default="scope">
            <el-image
              v-if="scope.row.coverImage"
              :src="getImageUrl(scope.row.coverImage)"
              :preview-src-list="[getImageUrl(scope.row.coverImage)]"
              fit="cover"
              :preview-teleported="true"
              class="article-cover"
            />
            <div v-else class="no-image">无封面</div>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" show-overflow-tooltip />
        <el-table-column prop="categoryName" label="分类" width="120" />
        <el-table-column label="标签" width="180">
          <template #default="scope">
            <el-tag
              v-for="tag in scope.row.tags"
              :key="tag.id"
              :color="tag.color"
              effect="dark"
              class="tag-item"
            >
              {{ tag.name }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 0" type="warning">草稿</el-tag>
            <el-tag v-else-if="scope.row.status === 1" type="success"
              >已发布</el-tag
            >
            <el-tag v-else-if="scope.row.status === 2" type="danger"
              >已删除</el-tag
            >
          </template>
        </el-table-column>
        <el-table-column label="统计" width="180">
          <template #default="scope">
            <div class="article-stats">
              <span
                ><i class="el-icon-view"></i> {{ scope.row.viewCount }}</span
              >
              <span
                ><i class="el-icon-star-on"></i> {{ scope.row.likeCount }}</span
              >
              <span
                ><i class="el-icon-chat-line-square"></i>
                {{ scope.row.commentCount }}</span
              >
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="400" fixed="right">
          <template #default="scope">
            <el-button
              v-if="scope.row.status !== 2"
              type="primary"
              size="small"
              @click="$router.push(`/back/article/edit/${scope.row.id}`)"
            >
              编辑
            </el-button>
            <el-button
              v-if="scope.row.status === 0"
              type="success"
              size="small"
              @click="updateArticleStatus(scope.row.id, 1)"
            >
              发布
            </el-button>
            <el-button
              v-if="scope.row.status === 1"
              type="warning"
              size="small"
              @click="updateArticleStatus(scope.row.id, 0)"
            >
              撤回
            </el-button>
            <el-button
              v-if="scope.row.likeCount > 0"
              type="primary"
              size="small"
              @click="showLikeUsers(scope.row)"
            >
              点赞用户
            </el-button>
            <el-button
              v-if="scope.row.collectCount > 0 || true"
              type="success"
              plain
              size="small"
              @click="showCollectUsers(scope.row)"
            >
              收藏用户
            </el-button>
            <el-popconfirm
              v-if="scope.row.status !== 2"
              title="确定删除该文章吗？"
              @confirm="updateArticleStatus(scope.row.id, 2)"
              width="220"
            >
              <template #reference>
                <el-button type="danger" size="small">删除</el-button>
              </template>
            </el-popconfirm>
            <el-button
              v-if="scope.row.status === 2"
              type="info"
              size="small"
              @click="updateArticleStatus(scope.row.id, 0)"
            >
              恢复
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          :current-page="currentPage"
          :page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 点赞用户对话框 -->
    <el-dialog
      v-model="likeDialogVisible"
      :title="`《${currentArticle?.title || ''}》的点赞用户`"
      width="700px"
    >
      <el-table
        :data="likeUserList"
        border
        style="width: 100%"
        v-loading="likeLoading"
      >
        <el-table-column type="index" width="50" label="#"></el-table-column>
        <el-table-column
          prop="username"
          label="用户名"
          width="120"
        ></el-table-column>
        <el-table-column prop="name" label="姓名" width="120"></el-table-column>
        <el-table-column label="头像" width="80">
          <template #default="scope">
            <el-avatar
              :size="40"
              :src="getImageUrl(scope.row.avatar)"
            ></el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="email" label="邮箱"></el-table-column>
        <el-table-column
          prop="likeTime"
          label="点赞时间"
          width="180"
        ></el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          :current-page="likeCurrentPage"
          :page-size="likePageSize"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="likeTotal"
          @size-change="handleLikeSizeChange"
          @current-change="handleLikeCurrentChange"
        />
      </div>
    </el-dialog>

    <!-- 收藏用户对话框 -->
    <el-dialog
      v-model="collectDialogVisible"
      :title="`《${currentArticle?.title || ''}》的收藏用户`"
      width="700px"
    >
      <el-table
        :data="collectUserList"
        border
        style="width: 100%"
        v-loading="collectLoading"
      >
        <el-table-column type="index" width="50" label="#"></el-table-column>
        <el-table-column
          prop="username"
          label="用户名"
          width="120"
        ></el-table-column>
        <el-table-column prop="name" label="姓名" width="120"></el-table-column>
        <el-table-column label="头像" width="80">
          <template #default="scope">
            <el-avatar
              :size="40"
              :src="getImageUrl(scope.row.avatar)"
            ></el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="email" label="邮箱"></el-table-column>
        <el-table-column
          prop="collectTime"
          label="收藏时间"
          width="180"
        ></el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          :current-page="collectCurrentPage"
          :page-size="collectPageSize"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="collectTotal"
          @size-change="handleCollectSizeChange"
          @current-change="handleCollectCurrentChange"
        />
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from "vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";

// 基础路径
const baseAPI = process.env.VUE_APP_BASE_API || "/api";

// 加载状态
const loading = ref(false);
// 文章列表
const articleList = ref([]);
// 分类选项
const categoryOptions = ref([]);
// 分页信息
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
// 搜索表单
const searchForm = reactive({
  title: "",
  categoryId: "",
  status: "",
});

// 点赞用户对话框相关
const likeDialogVisible = ref(false);
const likeLoading = ref(false);
const likeUserList = ref([]);
const likeCurrentPage = ref(1);
const likePageSize = ref(10);
const likeTotal = ref(0);
const currentArticle = ref(null);

// 收藏用户对话框相关
const collectDialogVisible = ref(false);
const collectLoading = ref(false);
const collectUserList = ref([]);
const collectCurrentPage = ref(1);
const collectPageSize = ref(10);
const collectTotal = ref(0);

// 初始化
onMounted(() => {
  fetchCategoryList();
  fetchArticleList(1);
});

// 获取分类列表
const fetchCategoryList = async () => {
  try {
    await request.get(
      "/category",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          categoryOptions.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取分类列表失败:", error);
  }
};

// 获取文章列表
const fetchArticleList = async (page) => {
  if (page) {
    currentPage.value = page;
  }

  loading.value = true;
  try {
    const params = {
      currentPage: currentPage.value,
      size: pageSize.value,
      ...searchForm,
    };

    await request.get("/article/page", params, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        articleList.value = data.records;
        total.value = data.total;
      },
    });
  } catch (error) {
    console.error("获取文章列表失败:", error);
  } finally {
    loading.value = false;
  }
};

// 处理每页显示数量变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchArticleList(1);
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchArticleList();
};

// 重置搜索条件
const resetSearch = () => {
  searchForm.title = "";
  searchForm.categoryId = "";
  searchForm.status = "";
  fetchArticleList(1);
};

// 更新文章状态
const updateArticleStatus = async (id, status) => {
  try {
    await request.put(`/article/${id}/status?status=${status}`, null, {
      successMsg: "操作成功",
      onSuccess: () => {
        fetchArticleList();
      },
    });
  } catch (error) {
    console.error("更新文章状态失败:", error);
  }
};

// 处理图片URL
const getImageUrl = (url) => {
  if (!url) return "";
  return baseAPI + url;
};

// 显示点赞用户
const showLikeUsers = (article) => {
  currentArticle.value = article;
  likeDialogVisible.value = true;
  likeCurrentPage.value = 1;
  fetchLikeUsers();
};

// 获取点赞用户列表
const fetchLikeUsers = async () => {
  if (!currentArticle.value) return;

  likeLoading.value = true;
  try {
    await request.get(
      `/article/${currentArticle.value.id}/like/users`,
      {
        currentPage: likeCurrentPage.value,
        size: likePageSize.value,
      },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          likeUserList.value = data.records;
          likeTotal.value = data.total;
        },
      },
    );
  } catch (error) {
    console.error("获取点赞用户列表失败:", error);
  } finally {
    likeLoading.value = false;
  }
};

// 点赞用户分页大小变化
const handleLikeSizeChange = (val) => {
  likePageSize.value = val;
  fetchLikeUsers();
};

// 点赞用户页码变化
const handleLikeCurrentChange = (val) => {
  likeCurrentPage.value = val;
  fetchLikeUsers();
};

// 显示收藏用户
const showCollectUsers = (article) => {
  currentArticle.value = article;
  collectDialogVisible.value = true;
  collectCurrentPage.value = 1;
  fetchCollectUsers();
};

// 获取收藏用户列表
const fetchCollectUsers = async () => {
  if (!currentArticle.value) return;

  collectLoading.value = true;
  try {
    await request.get(
      `/article/${currentArticle.value.id}/collect/users`,
      {
        currentPage: collectCurrentPage.value,
        size: collectPageSize.value,
      },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          collectUserList.value = data.records;
          collectTotal.value = data.total;
        },
      },
    );
  } catch (error) {
    console.error("获取收藏用户列表失败:", error);
  } finally {
    collectLoading.value = false;
  }
};

// 收藏用户分页大小变化
const handleCollectSizeChange = (val) => {
  collectPageSize.value = val;
  fetchCollectUsers();
};

// 收藏用户页码变化
const handleCollectCurrentChange = (val) => {
  collectCurrentPage.value = val;
  fetchCollectUsers();
};
</script>

<style scoped>
.article-container {
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

.search-form {
  margin-bottom: 24px;
  padding-top: 8px;
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

.pagination {
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

.article-cover {
  width: 60px;
  height: 40px;
  border-radius: 4px;
  border: 1px solid #eaeaea;
  object-fit: cover;
}

.no-image {
  width: 60px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f8f9fa;
  color: #666;
  font-size: 12px;
  border-radius: 4px;
  border: 1px solid #eaeaea;
}

.article-stats {
  display: flex;
  gap: 12px;
  color: #666;
  font-size: 13px;
}

.tag-item {
  margin-right: 5px;
  margin-bottom: 5px;
  border: none;
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

:deep(.el-tag--warning) {
  background-color: rgba(230, 162, 60, 0.1);
  border-color: transparent;
  color: #e6a23c;
}

:deep(.el-tag--danger) {
  background-color: rgba(245, 108, 108, 0.1);
  border-color: transparent;
  color: #f56c6c;
}

/* 对话框样式 */
:deep(.el-dialog) {
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
  padding: 20px;
}

:deep(.el-dialog__close) {
  color: #666;
}

:deep(.el-dialog__close:hover) {
  color: #333;
  background-color: #f0f0f0;
  border-radius: 50%;
}

/* 对话框内的分页样式 */
.el-dialog .pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-avatar) {
  background-color: #f0f0f0;
  color: #666;
  border: 1px solid #eaeaea;
}
</style>
