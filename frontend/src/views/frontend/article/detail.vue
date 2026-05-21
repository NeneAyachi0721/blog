<template>
  <div class="article-detail-container">
    <div class="article-content" v-loading="loading">
      <template v-if="article">
        <!-- 文章头部区域 -->
        <div class="article-header">
          <div class="header-content">

            
            <div class="header-text">
              <h1 class="article-title">{{ article.title }}</h1>
              <div class="article-meta">
                <span><el-icon><User /></el-icon> {{ article.authorName }}</span>
                <span><el-icon><Folder /></el-icon> {{ article.categoryName }}</span>
                <span><el-icon><Calendar /></el-icon> {{ formatDate(article.createTime) }}</span>
                <span><el-icon><View /></el-icon> {{ article.viewCount }} 阅读</span>
                <span><el-icon><Comment /></el-icon> {{ article.commentCount }} 评论</span>
              </div>
              <div class="article-tags">
                <el-tag 
                  v-for="tag in article.tags" 
                  :key="tag.id" 
                  :color="tag.color" 
                  effect="dark"
                  class="tag-item"
                  @click="goToTag(tag.id)"
                >
                  {{ tag.name }}
                </el-tag>
              </div>
            </div>
          </div>
        </div>

        <!-- 文章内容 -->
        <div class="article-body rich-text-content" v-html="article.htmlContent"></div>

        <!-- 文章底部操作区 -->
        <div class="article-footer">
          <div class="article-actions">
            <el-button 
              type="danger" 
              :icon="isLiked ? 'ThumbUp' : 'Thumb'" 
              @click="handleLike"
              :loading="likeLoading"
              class="action-button"
            >
              {{ isLiked ? '已点赞' : '点赞' }} ({{ article.likeCount }})
            </el-button>
            
            <el-button 
              type="warning" 
              :icon="isCollected ? 'Star' : 'StarFilled'" 
              @click="handleCollect"
              :loading="collectLoading"
              class="action-button"
            >
              {{ isCollected ? '已收藏' : '收藏' }}
            </el-button>
          </div>
        </div>
      </template>

      <el-empty v-else description="文章不存在或已被删除" />
    </div>

    <!-- 相关推荐 -->
    <div class="related-articles" v-if="relatedArticles.length > 0">
      <h3 class="section-title">相关推荐</h3>
      <div class="related-list">
        <div 
          v-for="article in relatedArticles" 
          :key="article.id" 
          class="related-item"
          @click="goToArticle(article.id)"
        >
          <el-image 
            v-if="article.coverImage" 
            :src="getImageUrl(article.coverImage)" 
            fit="cover" 
            class="related-cover"
          />
          <div class="related-info">
            <h4 class="related-title">{{ article.title }}</h4>
            <div class="related-meta">
              <span>{{ formatDate(article.createTime) }}</span>
              <span>{{ article.viewCount }} 阅读</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 评论区 -->
    <div class="comments-section">
      <comment-list 
        :article-id="route.params.id" 
        @comment-added="handleCommentAdded"
        @comment-deleted="handleCommentDeleted"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { User, Folder, Calendar, View, ThumbsUp, ChatDotRound, Comment, Star, StarFilled } from '@element-plus/icons-vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/user'
import DateUtils from '@/utils/dateUtils'
import CommentList from '@/components/Comment/CommentList.vue'

// 使用DateUtils格式化日期
const formatDate = (date) => {
  return DateUtils.formatDateTime(date);
}

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const baseAPI = process.env.VUE_APP_BASE_API || '/api'

// 加载状态
const loading = ref(false)
// 文章信息
const article = ref(null)
// 相关文章
const relatedArticles = ref([])
// 评论列表
const comments = ref([])
// 评论内容
const commentContent = ref('')
// 默认头像
const defaultAvatar = '/images/default-avatar.png'
// 是否已点赞
const isLiked = ref(false)
// 是否已收藏
const isCollected = ref(false)
const collectLoading = ref(false)
const likeLoading = ref(false)

// 初始化
onMounted(() => {
  const articleId = route.params.id
  if (articleId) {
    fetchArticleDetail(articleId)
    checkUserInteractions()
  }
})

// 获取文章详情
const fetchArticleDetail = async (id) => {
  loading.value = true
  try {
    await request.get(`/article/${id}`, {}, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        article.value = data
        document.title = `${data.title} - 个人博客`
        
        // 获取相关文章
        fetchRelatedArticles(data.categoryId)
      }
    })
  } catch (error) {
    console.error('获取文章详情失败:', error)
    ElMessage.error('获取文章详情失败')
  } finally {
    loading.value = false
  }
}

// 获取相关文章
const fetchRelatedArticles = async (categoryId) => {
  if (!categoryId) return
  
  try {
    await request.get(`/article/category/${categoryId}`, {
      currentPage: 1,
      size: 5
    }, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        // 过滤掉当前文章
        relatedArticles.value = data.records.filter(item => item.id !== article.value.id).slice(0, 4)
      }
    })
  } catch (error) {
    console.error('获取相关文章失败:', error)
  }
}

// 检查当前用户是否已点赞和收藏文章
const checkUserInteractions = async () => {
  if (!userStore.isLoggedIn) return
  
  // 检查点赞状态
  try {
    await request.get(`/article/${route.params.id}/like/status`, {}, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        isLiked.value = data.liked
      }
    })
  } catch (error) {
    console.error('获取点赞状态失败:', error)
  }
  
  // 检查收藏状态
  try {
    await request.get(`/article/${route.params.id}/collect/status`, {}, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        isCollected.value = data.collected
      }
    })
  } catch (error) {
    console.error('获取收藏状态失败:', error)
  }
}

// 点赞或取消点赞
const handleLike = async () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    return
  }
  
  likeLoading.value = true
  try {
    await request.post(`/article/${route.params.id}/like`, {}, {
      successMsg: isLiked.value ? '已取消点赞' : '点赞成功',
      onSuccess: (data) => {
        isLiked.value = data.liked
        // 更新文章点赞数
        if (data.liked) {
          article.value.likeCount++
        } else if (article.value.likeCount > 0) {
          article.value.likeCount--
        }
      }
    })
  } catch (error) {
    console.error('点赞操作失败:', error)
  } finally {
    likeLoading.value = false
  }
}

// 收藏或取消收藏
const handleCollect = async () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    return
  }
  
  collectLoading.value = true
  try {
    await request.post(`/article/${route.params.id}/collect`, {}, {
      successMsg: isCollected.value ? '已取消收藏' : '收藏成功',
      onSuccess: (data) => {
        isCollected.value = data.collected
      }
    })
  } catch (error) {
    console.error('收藏操作失败:', error)
  } finally {
    collectLoading.value = false
  }
}

// 提交评论
const submitComment = () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录再评论')
    router.push({
      path: '/login',
      query: { redirect: route.fullPath }
    })
    return
  }
  
  if (!commentContent.value.trim()) {
    ElMessage.warning('评论内容不能为空')
    return
  }
  
  ElMessage.success('评论提交成功')
  commentContent.value = ''
  
  // 实际项目中需要调用评论API
  // submitCommentApi(article.value.id, commentContent.value)
}

// 跳转到标签页
const goToTag = (id) => {
  router.push(`/tag/${id}`)
}

// 跳转到文章详情
const goToArticle = (id) => {
  router.push(`/article/${id}`)
  location.reload() // 刷新页面获取新文章内容
}

// 处理图片URL
const getImageUrl = (url) => {
  if (!url) return ''
  return baseAPI + url
}

// 处理评论添加事件
const handleCommentAdded = () => {
  // 评论计数已在后端更新，这里可以重新获取文章信息来刷新评论数
  fetchArticleDetail(route.params.id)
}

// 处理评论删除事件
const handleCommentDeleted = () => {
  // 评论计数已在后端更新，这里可以重新获取文章信息来刷新评论数
  fetchArticleDetail(route.params.id)
}
</script>

<style scoped>
.article-detail-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.article-content {
  margin-bottom: 40px;
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 40px;
}

.article-header {
  margin-top: 40px;
  border-bottom: 1px solid #f0f0f0;

}

.header-content {
  display: flex;
  gap: 30px;
  align-items: flex-start;
}

.header-text {
  flex: 1;
}

.article-title {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 20px;
  color: #222;
  line-height: 1.3;
}

.article-meta {
  color: #888;
  font-size: 14px;
  margin-bottom: 15px;
}

.article-meta span {
  margin-right: 20px;
  display: inline-flex;
  align-items: center;
}

.article-meta .el-icon {
  margin-right: 6px;
}

.article-tags {
  margin-bottom: 15px;
}

.tag-item {
  margin-right: 10px;
  cursor: pointer;
  border-radius: 20px;
  font-size: 12px;
  transition: transform 0.2s;
}

.tag-item:hover {
  transform: scale(1.05);
}



.article-body {
  line-height: 1.8;
  color: #333;
  font-size: 16px;
  word-break: break-word;
  padding: 10px 0;
}

.article-footer {
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.article-actions {
  display: flex;
  justify-content: center;
  gap: 20px;
}

.action-button {
  padding: 12px 25px;
  font-size: 15px;
  border-radius: 25px;
  transition: all 0.3s;
}

.action-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 22px;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 1px solid #f0f0f0;
  color: #333;
  font-weight: 600;
}

.related-articles {
  margin-bottom: 40px;
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 30px;
}

.related-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.related-item {
  display: flex;
  align-items: center;
  padding: 15px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #f0f0f0;
}

.related-item:hover {
  background-color: #f9f9f9;
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

.related-cover {
  width: 90px;
  height: 65px;
  border-radius: 6px;
  margin-right: 15px;
  flex-shrink: 0;
  object-fit: cover;
}

.related-info {
  flex: 1;
  overflow: hidden;
}

.related-title {
  margin: 0 0 8px;
  font-size: 15px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #333;
  font-weight: 500;
  transition: color 0.2s;
}

.related-item:hover .related-title {
  color: #409EFF;
}

.related-meta {
  font-size: 12px;
  color: #888;
}

.related-meta span {
  margin-right: 10px;
}

.comments-section {
  margin-bottom: 30px;
}

/* 富文本编辑器内容样式 */
:deep(.rich-text-content) {
  /* font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif; */
  font-size: 16px;
  line-height: 1.5;
  color: #333;
  text-align: left;
}

:deep(.rich-text-content h1),
:deep(.rich-text-content h2) {
  padding-bottom: 0.3em;
  border-bottom: 1px solid #eee;
  margin-top: 1.5em;
}

:deep(.rich-text-content h1),
:deep(.rich-text-content h2),
:deep(.rich-text-content h3),
:deep(.rich-text-content h4),
:deep(.rich-text-content h5),
:deep(.rich-text-content h6) {
  margin-top: 32px;
  margin-bottom: 20px;
  font-weight: 600;
  line-height: 1.4;
  color: #2c3e50;
  position: relative;
  padding: 8px 16px;
  background: linear-gradient(135deg, rgba(32, 160, 255, 0.1) 0%, rgba(32, 160, 255, 0.05) 100%);
  /* border-radius: 6px; */
  /* box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05); */
  border-left: 4px solid #409EFF;
  transition: all 0.3s ease;
}

:deep(.rich-text-content h1):hover,
:deep(.rich-text-content h2):hover,
:deep(.rich-text-content h3):hover,
:deep(.rich-text-content h4):hover,
:deep(.rich-text-content h5):hover,
:deep(.rich-text-content h6):hover {
  transform: translateX(5px);
  /* background: linear-gradient(135deg, rgba(32, 160, 255, 0.15) 0%, rgba(32, 160, 255, 0.1) 100%); */
  /* box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.08); */

}

:deep(.rich-text-content h1) {
  font-size: 2em;
  border-bottom: 1px solid #eaecef;
}

:deep(.rich-text-content h2) {
  font-size: 1.5em;
  border-bottom: 1px solid #eaecef;
}

:deep(.rich-text-content h3) {
  font-size: 1.25em;
}

:deep(.rich-text-content h4) {
  font-size: 1.1em;
}

:deep(.rich-text-content h5) {
  font-size: 1em;
}

:deep(.rich-text-content h6) {
  font-size: 0.875em;
  color: #5c6b77;
}

:deep(.rich-text-content img) {
  max-width: 100%;
  height: auto !important;
  box-sizing: content-box;
  background-color: #fff;
  border-radius: 6px;
  margin: 10px 0;
}

:deep(.rich-text-content pre) {
  padding: 16px;
  overflow: auto;
  font-size: 85%;
  line-height: 1.45;
  background-color: #f6f8fa;
  border-radius: 6px;
  margin: 16px 0;
  white-space: pre-wrap;
}

:deep(.rich-text-content code) {
  padding: 0.2em 0.4em;
  margin: 0;
  font-size: 85%;
  background-color: rgba(175, 184, 193, 0.2);
  border-radius: 6px;
  font-family: Consolas, Monaco, 'Andale Mono', monospace;
}

:deep(.rich-text-content pre code) {
  padding: 0;
  background-color: transparent;
}

:deep(.rich-text-content blockquote) {
  padding: 0.5em 1em;
  color: #57606a;
  border-left: 0.25em solid #d0d7de;
  margin: 16px 0;
  background-color: #f8f9fa;
}

:deep(.rich-text-content table) {
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0;
  overflow-x: auto;
  display: block;
}

:deep(.rich-text-content table th),
:deep(.rich-text-content table td) {
  padding: 8px 13px;
  border: 1px solid #d0d7de;
}

:deep(.rich-text-content table th) {
  background-color: #f1f3f5;
  font-weight: 600;
}

:deep(.rich-text-content table tr) {
  background-color: #fff;
  border-top: 1px solid #d0d7de;
}

:deep(.rich-text-content table tr:nth-child(2n)) {
  background-color: #f6f8fa;
}

:deep(.rich-text-content a) {
  color: #409EFF;
  text-decoration: none;
}

:deep(.rich-text-content a:hover) {
  text-decoration: underline;
}

:deep(.rich-text-content ul),
:deep(.rich-text-content ol) {
  padding-left: 2em;
  margin: 16px 0;
}

:deep(.rich-text-content li) {
  margin-bottom: 5px;
}

:deep(.rich-text-content p) {
  margin: 16px 0;
  text-align: left;
}

:deep(.rich-text-content hr) {
  height: 1px;
  background-color: #eee;
  border: none;
  margin: 24px 0;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
  }
  
  .article-cover {
    flex: none;
    width: 100%;
    margin-bottom: 20px;
  }
  
  .article-cover .el-image {
    height: 200px;
  }
  
  .article-title {
    font-size: 24px;
  }
  
  .related-list {
    grid-template-columns: 1fr;
  }
}
</style> 