<template>
  <div class="comment-management-container">
    <div class="page-header">
      <h2>评论管理</h2>
    </div>
    
    <!-- 搜索表单 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" ref="searchFormRef">
        <el-form-item label="文章标题">
          <el-input v-model="searchForm.articleTitle" placeholder="请输入文章标题" clearable></el-input>
        </el-form-item>
        <el-form-item label="审核状态">
          <el-select v-model="searchForm.status" placeholder="请选择审核状态" clearable>
            <el-option label="待审核" :value="0"></el-option>
            <el-option label="已通过" :value="1"></el-option>
            <el-option label="已拒绝" :value="2"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <!-- 评论列表 -->
    <el-card class="list-card">
      <el-table :data="commentList" border style="width: 100%" v-loading="loading">
        <el-table-column type="index" width="50" label="#"></el-table-column>
        <el-table-column prop="content" label="评论内容" show-overflow-tooltip></el-table-column>
        <el-table-column prop="articleTitle" label="文章标题" width="200" show-overflow-tooltip>
          <template #default="scope">
            <router-link :to="`/article/${scope.row.articleId}`" class="link-text" target="_blank">
              {{ scope.row.articleTitle }}
            </router-link>
          </template>
        </el-table-column>
        <el-table-column prop="userName" label="评论用户" width="120">
          <template #default="scope">
            <div class="user-info">
              <el-avatar 
                :size="30" 
                :src="getImageUrl(scope.row.userAvatar)" 
                class="user-avatar"
              ></el-avatar>
              <span>{{ scope.row.userName || scope.row.username }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="评论时间" width="180"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 0" type="info">待审核</el-tag>
            <el-tag v-else-if="scope.row.status === 1" type="success">已通过</el-tag>
            <el-tag v-else-if="scope.row.status === 2" type="danger">已拒绝</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="scope">
            <el-button 
              v-if="scope.row.status === 0"
              type="success" 
              size="small"
              @click="handleAudit(scope.row.id, 1)"
            >
              通过
            </el-button>
            <el-button 
              v-if="scope.row.status === 0"
              type="danger" 
              size="small"
              @click="handleAudit(scope.row.id, 2)"
            >
              拒绝
            </el-button>
            <el-button 
              type="primary" 
              size="small"
              @click="handleViewDetail(scope.row)"
            >
              详情
            </el-button>
            <el-button 
              type="danger" 
              size="small"
              @click="handleDelete(scope.row)"
            >
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
    
    <!-- 评论详情对话框 -->
    <el-dialog 
      v-model="dialogVisible" 
      title="评论详情" 
      width="650px"
    >
      <div class="comment-detail" v-if="currentComment">
        <div class="detail-item">
          <span class="label">评论内容：</span>
          <div class="content">{{ currentComment.content }}</div>
        </div>
        <div class="detail-item">
          <span class="label">评论文章：</span>
          <div class="content">
            <router-link :to="`/article/${currentComment.articleId}`" class="link-text" target="_blank">
              {{ currentComment.articleTitle }}
            </router-link>
          </div>
        </div>
        <div class="detail-item">
          <span class="label">评论用户：</span>
          <div class="content user-info">
            <el-avatar 
              :size="30" 
              :src="getImageUrl(currentComment.userAvatar)" 
              class="user-avatar"
            ></el-avatar>
            <span>{{ currentComment.userName || currentComment.username }}</span>
          </div>
        </div>
        <div class="detail-item">
          <span class="label">评论时间：</span>
          <div class="content">{{ currentComment.createTime }}</div>
        </div>
        <div class="detail-item">
          <span class="label">评论状态：</span>
          <div class="content">
            <el-tag v-if="currentComment.status === 0" type="info">待审核</el-tag>
            <el-tag v-else-if="currentComment.status === 1" type="success">已通过</el-tag>
            <el-tag v-else-if="currentComment.status === 2" type="danger">已拒绝</el-tag>
          </div>
        </div>
        
        <div class="detail-item" v-if="currentComment.isReply">
          <span class="label">父评论：</span>
          <div class="content">{{ currentComment.parentContent || '无法获取父评论内容' }}</div>
        </div>
        
        <div class="detail-item" v-if="currentComment.isReply && currentComment.toUserName">
          <span class="label">回复用户：</span>
          <div class="content">{{ currentComment.toUserName }}</div>
        </div>
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
          <el-button 
            v-if="currentComment && currentComment.status === 0"
            type="success" 
            size="small"
            @click="handleAudit(currentComment.id, 1); dialogVisible = false"
          >
            通过
          </el-button>
          <el-button 
            v-if="currentComment && currentComment.status === 0"
              type="danger" 
            size="small"
            @click="handleAudit(currentComment.id, 2); dialogVisible = false"
          >
            拒绝
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

// 状态变量
const loading = ref(false)
const dialogVisible = ref(false)
const currentComment = ref(null)
const searchFormRef = ref(null)

// 分页相关
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const commentList = ref([])

// 搜索表单
const searchForm = reactive({
  articleTitle: '',
  status: null
})

// 获取所有评论
const fetchComments = async () => {
  loading.value = true
  try {
    await request.get('/comment/admin/page', {
      articleTitle: searchForm.articleTitle,
      status: searchForm.status,
      currentPage: currentPage.value,
      size: pageSize.value
    }, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        commentList.value = data.records
        total.value = data.total
      }
    })
  } catch (error) {
    console.error('获取评论列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  fetchComments()
}

// 重置搜索
const resetSearch = () => {
  searchForm.articleTitle = ''
  searchForm.status = null
  currentPage.value = 1
  fetchComments()
}

// 分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size
  fetchComments()
}

// 页码变化
const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchComments()
}

// 查看评论详情
const handleViewDetail = (comment) => {
  currentComment.value = comment
  dialogVisible.value = true
}

// 审核评论
const handleAudit = async (id, status) => {
  try {
    await request.put(`/comment/audit/${id}?status=${status}`, {
      successMsg: status === 1 ? '评论审核通过' : '评论已拒绝',
      onSuccess: () => {
        // 更新本地评论状态
        const comment = commentList.value.find(item => item.id === id)
        if (comment) {
          comment.status = status
        }
        if (currentComment.value && currentComment.value.id === id) {
          currentComment.value.status = status
        }
        fetchComments()
      }
    })
  } catch (error) {
    console.error('审核评论失败:', error)
  }
}

// 删除评论
const handleDelete = (comment) => {
  ElMessageBox.confirm(`确定要删除该评论吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await request.delete(`/comment/${comment.id}`,{
        successMsg: '删除成功',
        onSuccess: () => {
          fetchComments()
        }
      })
    } catch (error) {
      console.error('删除评论失败:', error)
    }
  }).catch(() => {})
}

// 获取图片URL
const baseAPI = process.env.VUE_APP_BASE_API || '/api'
const getImageUrl = (path) => {
  if (!path) return ''
  return baseAPI + path
}

// 生命周期钩子
onMounted(() => {
  fetchComments()
})
</script>

<style scoped>
.comment-management-container {
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
:deep(.el-pagination .el-pagination__sizes .el-input .el-input__wrapper.is-focus) {
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

.user-info {
  display: flex;
  align-items: center;
}

.user-avatar {
  margin-right: 8px;
  background-color: #f0f0f0;
  color: #666;
  border: 1px solid #eaeaea;
}

.link-text {
  color: #333;
  text-decoration: none;
  transition: all 0.3s;
  border-bottom: 1px solid transparent;
}

.link-text:hover {
  text-decoration: none;
  border-bottom: 1px solid #333;
}

:deep(.el-tag) {
  border: none;
  border-radius: 4px;
}

:deep(.el-tag--info) {
  background-color: rgba(144, 147, 153, 0.1);
  border-color: transparent;
  color: #909399;
}

:deep(.el-tag--success) {
  background-color: rgba(103, 194, 58, 0.1);
  border-color: transparent;
  color: #67c23a;
}

:deep(.el-tag--danger) {
  background-color: rgba(245, 108, 108, 0.1);
  border-color: transparent;
  color: #f56c6c;
}

:deep(.el-button--text) {
  color: #333;
}

:deep(.el-button--primary.is-link) {
  color: #333;
}

:deep(.el-button--primary.is-link:hover) {
  color: #000;
}

:deep(.el-button--danger.is-link) {
  color: #f56c6c;
}

:deep(.el-button--danger.is-link:hover) {
  color: #d33030;
}

:deep(.el-button--success.is-link) {
  color: #67c23a;
}

:deep(.el-button--success.is-link:hover) {
  color: #529b2e;
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

/* 评论详情样式 */
.comment-detail {
  padding: 0;
}

.detail-item {
  margin-bottom: 18px;
  display: flex;
}

.detail-item:last-child {
  margin-bottom: 0;
}

.detail-item .label {
  font-weight: 500;
  width: 100px;
  flex-shrink: 0;
  color: #333;
}

.detail-item .content {
  flex: 1;
  color: #666;
}
</style> 