<template>
  <div class="article-list-container">
    <!-- 浪漫标题区域 -->
    <div class="romantic-title-container">
      <div class="title-decorations">
        <span class="decoration-left">&#60;&#47;</span>
        <span class="decoration-right">&#62;</span>
      </div>
      <h1 class="romantic-title">
        <span class="typewriter-text"></span>
        <span class="cursor">|</span>
      </h1>
      <!-- <p class="romantic-subtitle">用代码编织理想的模样</p> -->
      <div class="title-wave"></div>
    </div>

    <div class="search-header">
      <div class="search-wrapper">
        <el-input
          v-model="keyword"
          placeholder="搜索文章标题、内容或摘要..."
          class="search-input"
          clearable
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon class="search-icon"><Search /></el-icon>
          </template>
          <template #append>
            <el-button @click="handleSearch" type="primary"> 搜索 </el-button>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 分类筛选区域 -->
    <div class="category-filter">
      <div class="filter-title">
        <el-icon><Folder /></el-icon>
        <span>分类筛选:</span>
      </div>
      <div class="category-list">
        <el-tag
          :effect="selectedCategoryId === null ? 'dark' : 'plain'"
          class="category-tag"
          @click="selectCategory(null)"
        >
          全部
        </el-tag>
        <el-tag
          v-for="category in categories"
          :key="category.id"
          :effect="selectedCategoryId === category.id ? 'dark' : 'plain'"
          class="category-tag"
          @click="selectCategory(category.id)"
        >
          {{ category.name }} ({{ category.articleCount }})
        </el-tag>
      </div>
    </div>

    <div class="article-section" v-loading="loading">
      <div class="section-header">
        <h2 class="section-title">
          <template v-if="isSearchMode">搜索结果</template>
          <template v-else-if="selectedCategoryId !== null">{{
            selectedCategoryName
          }}</template>
          <template v-else>全部文章</template>
        </h2>
        <div class="article-count" v-if="total > 0">共 {{ total }} 篇文章</div>
      </div>

      <el-empty v-if="articles.length === 0" description="暂无文章" />

      <div
        v-else
        v-for="article in articles"
        :key="article.id"
        class="article-item"
        @click="goToArticle(article.id)"
      >
        <el-image
          v-if="article.coverImage"
          :src="getImageUrl(article.coverImage)"
          fit="cover"
          class="article-cover"
        />
        <div class="article-info">
          <h3 class="article-title">{{ article.title }}</h3>
          <p class="article-summary">{{ article.summary }}</p>
          <div class="article-meta">
            <span
              ><el-icon><User /></el-icon> {{ article.authorName }}</span
            >
            <span @click.stop="goToCategory(article.categoryId)">
              <el-icon><Folder /></el-icon> {{ article.categoryName }}
            </span>
            <span
              ><el-icon><Calendar /></el-icon>
              {{ formatDate(article.createTime) }}</span
            >
            <span
              ><el-icon><View /></el-icon> {{ article.viewCount }} 阅读</span
            >
          </div>
          <div class="article-tags">
            <el-tag
              v-for="tag in article.tags"
              :key="tag.id"
              :color="tag.color"
              effect="dark"
              class="tag-item"
              @click.stop="goToTag(tag.id)"
            >
              {{ tag.name }}
            </el-tag>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-container" v-if="total > 0">
        <el-pagination
          background
          layout="prev, pager, next, jumper"
          :total="total"
          :page-size="pageSize"
          :current-page="currentPage"
          @current-change="handlePageChange"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { User, Folder, Calendar, View, Search } from "@element-plus/icons-vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";

const route = useRoute();
const router = useRouter();
const baseAPI = process.env.VUE_APP_BASE_API || "/api";

// 打字机效果
const titleText = "Ciallo～(∠・ω< )⌒☆";
let typingTimer = null;

const startTypingAnimation = () => {
  const typewriterElement = document.querySelector(".typewriter-text");
  if (!typewriterElement) return;

  let index = 0;
  typewriterElement.textContent = "";

  clearInterval(typingTimer);
  typingTimer = setInterval(() => {
    if (index < titleText.length) {
      typewriterElement.textContent += titleText.charAt(index);
      index++;
    } else {
      clearInterval(typingTimer);
    }
  }, 150);
};

// 加载状态
const loading = ref(false);
// 搜索关键词
const keyword = ref("");
// 文章列表
const articles = ref([]);
// 分页信息
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
// 分类相关
const categories = ref([]);
const selectedCategoryId = ref(null);
const selectedCategoryName = ref("");

// 是否为搜索模式
const isSearchMode = computed(() => !!keyword.value);

// 获取所有分类
const fetchCategories = async () => {
  try {
    await request.get(
      "/category",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          categories.value = data || [];
        },
      },
    );
  } catch (error) {
    console.error("获取分类列表失败:", error);
  }
};

// 获取文章列表
const fetchArticles = async (page) => {
  loading.value = true;
  try {
    const params = {
      currentPage: page,
      size: pageSize.value,
      status: 1, // 已发布的文章
    };

    // 如果选择了分类，添加分类ID参数
    if (selectedCategoryId.value !== null) {
      params.categoryId = selectedCategoryId.value;
    }

    await request.get("/article/page", params, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        articles.value = data.records || [];
        total.value = data.total || 0;
      },
    });
  } catch (error) {
    console.error("获取文章列表失败:", error);
    ElMessage.error("获取文章列表失败");
  } finally {
    loading.value = false;
  }
};

// 搜索文章
const searchArticles = async (search, page) => {
  if (!search.trim()) {
    fetchArticles(page);
    return;
  }

  loading.value = true;
  try {
    const params = {
      keyword: search,
      currentPage: page,
      size: pageSize.value,
    };

    // 如果选择了分类，添加分类ID参数
    if (selectedCategoryId.value !== null) {
      params.categoryId = selectedCategoryId.value;
    }

    await request.get("/article/search", params, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        articles.value = data.records;
        total.value = data.total;
      },
    });
  } catch (error) {
    console.error("搜索文章失败:", error);
    ElMessage.error("搜索文章失败");
  } finally {
    loading.value = false;
  }
};

// 选择分类
const selectCategory = (categoryId) => {
  if (selectedCategoryId.value === categoryId) return;

  selectedCategoryId.value = categoryId;

  // 设置选中分类名称
  if (categoryId === null) {
    selectedCategoryName.value = "";
  } else {
    const category = categories.value.find((c) => c.id === categoryId);
    selectedCategoryName.value = category ? category.name : "";
  }

  // 更新路由
  const query = { ...route.query };
  if (categoryId === null) {
    delete query.categoryId;
  } else {
    query.categoryId = categoryId;
  }

  router.push({
    path: route.path,
    query,
  });

  // 重置页码并获取文章
  currentPage.value = 1;
  if (keyword.value) {
    searchArticles(keyword.value, 1);
  } else {
    fetchArticles(1);
  }
};

// 监听路由查询参数变化
watch(
  () => route.query,
  (query) => {
    // 处理分类ID
    if (query.categoryId) {
      const categoryId = parseInt(query.categoryId);
      if (selectedCategoryId.value !== categoryId) {
        selectedCategoryId.value = categoryId;
        // 设置选中分类名称
        const category = categories.value.find((c) => c.id === categoryId);
        selectedCategoryName.value = category ? category.name : "";
      }
    } else {
      selectedCategoryId.value = null;
      selectedCategoryName.value = "";
    }

    // 处理关键词
    if (query.keyword) {
      keyword.value = query.keyword;
      searchArticles(query.keyword, 1);
    } else if (keyword.value) {
      keyword.value = "";
      fetchArticles(1);
    } else {
      fetchArticles(1);
    }
  },
  { immediate: true },
);

// 初始化
onMounted(async () => {
  // 先获取分类列表
  await fetchCategories();

  // 处理路由参数
  if (route.query.categoryId) {
    const categoryId = parseInt(route.query.categoryId);
    selectedCategoryId.value = categoryId;
    // 设置选中分类名称
    const category = categories.value.find((c) => c.id === categoryId);
    selectedCategoryName.value = category ? category.name : "";
  }

  if (route.query.keyword) {
    keyword.value = route.query.keyword;
    searchArticles(keyword.value, 1);
  } else {
    fetchArticles(1);
  }

  document.title = "文章列表 - 个人博客";

  // 启动打字机动画
  setTimeout(() => {
    startTypingAnimation();
  }, 500);
});

// 处理搜索
const handleSearch = () => {
  const query = {};

  if (keyword.value.trim()) {
    query.keyword = keyword.value.trim();
  }

  if (selectedCategoryId.value !== null) {
    query.categoryId = selectedCategoryId.value;
  }

  router.push({
    path: "/articles",
    query,
  });

  if (keyword.value.trim()) {
    searchArticles(keyword.value.trim(), 1);
  } else {
    fetchArticles(1);
  }

  currentPage.value = 1;
};

// 处理页码变化
const handlePageChange = (page) => {
  currentPage.value = page;
  if (isSearchMode.value) {
    searchArticles(keyword.value, page);
  } else {
    fetchArticles(page);
  }
  // 滚动到页面顶部
  window.scrollTo(0, 0);
};

// 跳转到文章详情
const goToArticle = (id) => {
  router.push(`/article/${id}`);
};

// 跳转到分类页面
const goToCategory = (id) => {
  router.push(`/category/${id}`);
};

// 跳转到标签页面
const goToTag = (id) => {
  router.push(`/tag/${id}`);
};

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return "";
  const date = new Date(dateString);
  return date.toLocaleDateString();
};

// 处理图片URL
const getImageUrl = (url) => {
  if (!url) return "";
  return baseAPI + url;
};
</script>

<style scoped>
.article-list-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* 浪漫标题样式 */
.romantic-title-container {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
  padding: 30px 0;
}

.romantic-title {
  font-size: 36px;
  font-weight: 500;
  color: #59a6e6;
  margin: 0;
  letter-spacing: 2px;
  font-family: "Consolas", "Monaco", monospace;
  position: relative;
  display: inline-block;
  min-height: 45px;
}

.romantic-subtitle {
  font-size: 16px;
  color: #777;
  margin-top: 10px;
  font-weight: 300;
  letter-spacing: 1px;
}

.title-decorations {
  position: relative;
  margin-bottom: 15px;
}

.decoration-left,
.decoration-right {
  font-size: 24px;
  color: #3877ab;
  position: relative;
  display: inline-block;
  margin: 0 20px;
  font-family: "Consolas", "Monaco", monospace;
}

.decoration-left::before,
.decoration-right::before {
  content: "";
  height: 1px;
  width: 60px;
  background: linear-gradient(to right, transparent, #3877ab, transparent);
  position: absolute;
  top: 50%;
}

.decoration-left::before {
  right: 30px;
}

.decoration-right::before {
  left: 30px;
}

.title-wave {
  height: 15px;
  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 30" preserveAspectRatio="none"><path d="M0,0 C150,40 350,0 500,20 C650,40 750,0 900,10 C1050,20 1150,40 1200,10 L1200,30 L0,30 Z" style="fill: %23f9f9f9;"/></svg>')
    no-repeat;
  background-size: 100% 100%;
  position: absolute;
  bottom: 0;
  width: 100%;
  opacity: 0.8;
}

.search-header {
  margin-bottom: 20px;
  padding-bottom: 20px;
  text-align: center;
}

.search-wrapper {
  max-width: 700px;
  margin: 0 auto;
  position: relative;
}

.search-input {
  width: 100%;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 8px 0 0 8px;
  /* box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); */
  padding-left: 5px;
  transition: all 0.3s ease;
}

.search-input :deep(.el-input__wrapper:hover) {
  /* box-shadow: 0 6px 16px rgba(64, 158, 255, 0.1); */
}

.search-input :deep(.el-input__wrapper.is-focus) {
  /* box-shadow: 0 6px 16px rgba(64, 158, 255, 0.15); */
}

.search-input :deep(.el-input-group__append) {
  border-radius: 0 8px 8px 0;
  /* box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); */
}

.search-icon {
  margin-right: 5px;
  color: #909399;
}

/* 分类筛选样式 */
.category-filter {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 15px 20px;
  margin-bottom: 30px;
  /* box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03); */
}

.filter-title {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  font-weight: 600;
  color: #555;
  font-size: 15px;
}

.filter-title .el-icon {
  margin-right: 6px;
  color: #409eff;
}

.category-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.category-tag {
  cursor: pointer;
  padding: 6px 12px;
  transition: all 0.2s ease;
}

.category-tag:hover {
  transform: translateY(-2px);
}

.article-section {
  min-height: 400px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.section-title {
  margin: 0;
  font-size: 24px;
  color: #333;
  font-weight: 600;
}

.article-count {
  font-size: 14px;
  color: #888;
}

.article-item {
  display: flex;
  padding: 25px 15px;
  border-bottom: 1px solid #e0e0e0;
  position: relative;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 10px;
  border: 1px solid transparent;
}

.article-item:hover {
  transform: none;
  border: 1px solid rgba(64, 158, 255, 0.6);
  background-color: rgba(64, 158, 255, 0.02);
  box-shadow: 0 0 8px rgba(64, 158, 255, 0.08);
}

.article-item:not(:last-child)::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 10%;
  width: 80%;
  height: 1px;
  background: linear-gradient(to right, transparent, #d0d0d0, transparent);
}

.article-item:last-child {
  border-bottom: 1px solid #e0e0e0;
}

.article-cover {
  width: 220px;
  height: 140px;
  border-radius: 6px;
  margin-right: 25px;
  flex-shrink: 0;
  object-fit: cover;
  transition: all 0.3s ease;
}

.article-item:hover .article-cover {
  transform: none;
}

.article-info {
  flex: 1;
}

.article-title {
  margin: 0 0 12px;
  font-size: 20px;
  color: #333;
  text-align: left;
  font-weight: 600;
  transition: color 0.3s;
}

.article-item:hover .article-title {
  color: #409eff;
}

.article-summary {
  color: #666;
  text-align: left;
  font-size: 15px;
  line-height: 1.6;
  margin-bottom: 15px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.article-meta {
  text-align: left;
  color: #888;
  font-size: 13px;
  margin-bottom: 12px;
}

.article-meta span {
  margin-right: 18px;
  display: inline-flex;
  align-items: center;
  cursor: pointer;
  transition: color 0.2s;
}

.article-meta span:hover {
  color: #409eff;
}

.article-meta .el-icon {
  margin-right: 5px;
}

.article-tags {
  display: flex;
  flex-wrap: wrap;
}

.tag-item {
  margin-right: 8px;
  margin-bottom: 8px;
  /* border-radius: 20px; */
  font-size: 12px;
  transition: transform 0.2s;
}

.tag-item:hover {
  transform: scale(1.05);
}

.pagination-container {
  margin-top: 40px;
  display: flex;
  justify-content: center;
}

@media (max-width: 768px) {
  .article-item {
    flex-direction: column;
  }

  .article-cover {
    width: 100%;
    height: 180px;
    margin-right: 0;
    margin-bottom: 15px;
  }

  .category-list {
    gap: 8px;
  }

  .category-tag {
    padding: 4px 8px;
    font-size: 12px;
  }
}

.typewriter-text {
  display: inline-block;
}

.cursor {
  display: inline-block;
  margin-left: 2px;
  font-weight: 100;
  animation: blink 1s infinite;
}

@keyframes blink {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
}
</style>
