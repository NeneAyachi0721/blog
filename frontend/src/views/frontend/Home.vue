<template>
  <div class="home-container">
    <!-- 3D视差背景 -->
    <div class="parallax-background">
      <div class="particle" v-for="n in 50" :key="n"></div>
    </div>

    <!-- 英雄区域 -->
    <div class="hero-section">
      <div class="welcome-text">
        <h1 class="typewriter">{{ displayText }}</h1>
        <p class="subtitle">{{ subtitle }}</p>
      </div>
      <el-carousel
        height="450px"
        indicator-position="none"
        arrow="never"
        class="hero-carousel"
      >
        <el-carousel-item v-for="item in recommendArticles" :key="item.id">
          <img :src="getImageUrl(item.cover)" alt="Recommend Article Cover" />
        </el-carousel-item>
      </el-carousel>

      <!-- 波浪动画 -->
      <div class="header-waves">
        <svg
          class="waves"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          viewBox="0 24 150 28"
          preserveAspectRatio="none"
          shape-rendering="auto"
        >
          <defs>
            <path
              id="gentle-wave"
              d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"
            />
          </defs>
          <g class="parallax">
            <use
              xlink:href="#gentle-wave"
              x="48"
              y="0"
              fill="rgba(234,239,244,0.7)"
            />
            <use
              xlink:href="#gentle-wave"
              x="48"
              y="3"
              fill="rgba(234,239,244,0.5)"
            />
            <use
              xlink:href="#gentle-wave"
              x="48"
              y="5"
              fill="rgba(234,239,244,0.3)"
            />
            <use xlink:href="#gentle-wave" x="48" y="7" fill="#eaeff4" />
          </g>
        </svg>
      </div>
    </div>

    <!-- 统计数字 -->
    <div class="stats-section">
      <div class="stat-card" v-for="(stat, index) in stats" :key="index">
        <div class="stat-number">{{ stat.value }}</div>
        <div class="stat-label">{{ stat.label }}</div>
        <div class="stat-icon" :class="stat.icon"></div>
      </div>
    </div>

    <!-- 内容区域部分的修改 -->
    <div class="content-section">
      <!-- 最新文章区域 -->
      <div class="latest-articles-section">
        <div class="section-header">
          <h2 class="section-title">
            <span class="title-text">最新文章</span>
            <div class="title-decoration"></div>
          </h2>
          <el-button class="view-more-btn" @click="$router.push('/articles')">
            查看更多 <el-icon><ArrowRight /></el-icon>
          </el-button>
        </div>

        <el-empty v-if="latestArticles.length === 0" description="暂无文章" />

        <div v-else class="articles-grid">
          <div
            v-for="article in latestArticles"
            :key="article.id"
            class="article-card"
            @click="goToArticle(article.id)"
          >
            <div class="article-card-inner">
              <div class="article-image">
                <el-image
                  v-if="article.coverImage"
                  :src="getImageUrl(article.coverImage)"
                  fit="cover"
                />
                <div class="article-overlay">
                  <span class="read-more">阅读全文</span>
                </div>
              </div>
              <div class="article-content">
                <div class="article-meta">
                  <span class="article-category">{{
                    article.categoryName
                  }}</span>
                  <span class="article-date">{{
                    formatDate(article.createTime)
                  }}</span>
                </div>
                <h3 class="article-title">{{ article.title }}</h3>
                <p class="article-summary">{{ article.summary }}</p>
                <div class="article-footer">
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
                  <div class="article-stats">
                    <span class="stats-item">
                      <el-icon><View /></el-icon>
                      {{ article.viewCount }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 分类和标签区域 -->
      <div class="taxonomy-section">
        <!-- 分类区域 -->
        <div class="categories-container">
          <h2 class="section-title">
            <span class="title-text">文章分类</span>
            <div class="title-decoration"></div>
          </h2>
          <div class="categories-grid">
            <div
              v-for="category in categories"
              :key="category.id"
              class="category-card"
              @click="goToCategory(category.id)"
            >
              <div class="category-icon">
                <el-icon><Folder /></el-icon>
              </div>
              <div class="category-info">
                <h3>{{ category.name }}</h3>
                <div class="category-progress">
                  <div
                    class="progress-bar"
                    :style="{
                      width:
                        (category.articleCount /
                          Math.max(...categories.map((c) => c.articleCount))) *
                          100 +
                        '%',
                    }"
                  ></div>
                </div>
                <span class="category-count"
                  >{{ category.articleCount }} 篇文章</span
                >
              </div>
            </div>
          </div>
        </div>

        <!-- 标签云区域 -->
        <div class="tags-container">
          <h2 class="section-title">
            <span class="title-text">标签云</span>
            <div class="title-decoration"></div>
          </h2>
          <div class="tags-cloud">
            <el-tag
              v-for="tag in tags"
              :key="tag.id"
              :color="tag.color"
              effect="dark"
              class="tag-item"
              @click="goToTag(tag.id)"
            >
              {{ tag.name }} ({{ tag.articleCount }})
            </el-tag>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { View, Folder, ArrowRight } from "@element-plus/icons-vue";
import request from "@/utils/request";

const router = useRouter();
const baseAPI = process.env.VUE_APP_BASE_API || "/api";

// 统计数据
const stats = computed(() => [
  { value: latestArticles.value.length, label: "文章", icon: "icon-article" },
  { value: categories.value.length, label: "分类", icon: "icon-category" },
  { value: tags.value.length, label: "标签", icon: "icon-tag" },
]);

// 推荐文章（用于轮播图）
const recommendArticles = ref([]);
// 最新文章
const latestArticles = ref([]);
// 热门文章
const hotArticles = ref([]);
// 分类列表
const categories = ref([]);
// 标签列表
const tags = ref([]);

// 打字机效果相关
const fullText = "わたしの部屋";
const displayText = ref("");
const subtitle = ref("私の0721を見て下さいっ");
let currentIndex = 0;

const typeText = () => {
  if (currentIndex < fullText.length) {
    displayText.value = fullText.substring(0, currentIndex + 1);
    currentIndex++;
    setTimeout(typeText, 230); // 每个字的打字间隔
  } else {
    // 打字完成后，等待一段时间重新开始
    setTimeout(() => {
      currentIndex = 0;
      displayText.value = "";
      typeText();
    }, 2000);
  }
};

// 初始化
onMounted(() => {
  typeText(); // 开始打字效果
  fetchRecommendArticles();
  fetchLatestArticles();
  fetchHotArticles();
  fetchCategories();
  fetchTags();
});

// 获取推荐文章
const fetchRecommendArticles = async () => {
  try {
    await request.get(
      "/article/recommend",
      { limit: 5 },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          recommendArticles.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取推荐文章失败:", error);
  }
};

// 获取最新文章
const fetchLatestArticles = async () => {
  try {
    await request.get(
      "/article/page",
      {
        currentPage: 1,
        size: 12,
        status: 1, // 已发布的文章
      },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          latestArticles.value = data.records;
        },
      },
    );
  } catch (error) {
    console.error("获取最新文章失败:", error);
  }
};

// 获取热门文章
const fetchHotArticles = async () => {
  try {
    await request.get(
      "/article/hot",
      { limit: 10 },
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          hotArticles.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取热门文章失败:", error);
  }
};

// 获取分类列表
const fetchCategories = async () => {
  try {
    await request.get(
      "/category",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          categories.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取分类列表失败:", error);
  }
};

// 获取标签列表
const fetchTags = async () => {
  try {
    await request.get(
      "/tag",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          tags.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取标签列表失败:", error);
  }
};

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return "";
  const date = new Date(dateString);
  return date.toLocaleDateString();
};

// 跳转到文章详情页
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

// 处理图片URL
const getImageUrl = (url) => {
  if (!url) return "";
  return baseAPI + url;
};
</script>

<style lang="scss" scoped>
.home-container {
  min-height: 100vh;
  background: transparent;
  color: #333;
  overflow: hidden;
  position: relative;
  width: 100%;
}

/* 背景 */
.parallax-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 0;
  background: transparent;
}

.particle {
  position: absolute;
  background: linear-gradient(120deg, #59a6e6, #c7e2fa);
  border-radius: 50%;
  animation: float 20s infinite linear;

  @for $i from 1 through 50 {
    &:nth-child(#{$i}) {
      $size: random(4) + px;
      width: $size;
      height: $size;
      left: random(100) + vw;
      top: random(100) + vh;
      animation-delay: random(20) + s;
      animation-duration: (random(20) + 10) + s;
      opacity: random(30) / 100;
    }
  }
}

@keyframes float {
  0% {
    transform: translateY(0) translateX(0);
  }
  50% {
    transform: translateY(-20px) translateX(10px);
  }
  100% {
    transform: translateY(0) translateX(0);
  }
}

/* 英雄区域 */
.hero-section {
  width: 100%;
  margin-bottom: 0;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  position: relative;
  z-index: 1;
  background-image: url("@/assets/images/60141148_p0.png");
  background-size: cover;
  background-position: center;
  overflow: hidden;
}

.welcome-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  z-index: 2;
  width: 100%;
  padding: 0 20px;
}

.typewriter {
  font-size: 8rem;
  font-weight: bold;
  margin-bottom: 1rem;
  color: #000;
  font-family: "萝莉体 第二版", serif;
  position: relative;
  display: inline-block;

  &::after {
    content: "|";
    position: absolute;
    right: -50px;
    top: 0;
    animation: blink 0.7s infinite;
  }
}

.subtitle {
  font-size: 1.5rem;
  color: #000;
  margin-top: 3rem;
  opacity: 0;
  font-family: "萝莉体 第二版", serif;
  animation: fadeIn 0.5s ease forwards;
  animation-delay: 1s;
}

.hero-carousel {
  width: 100%;
  height: 100%;
  position: absolute;
  top: 0;
  left: 0;
  z-index: 0;
}

.primary-btn {
  background: transparent;
  border: 2px solid #59a6e6;
  color: #59a6e6;
  padding: 12px 30px;
  font-size: 1.2rem;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;

  &:hover {
    background: #59a6e6;
    color: #fff;
    transform: translateY(-2px);
    box-shadow: 0 5px 20px rgba(74, 144, 226, 0.3);

    .btn-line {
      transform: translateX(100%);
    }
  }

  .btn-line {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 2px;
    background: linear-gradient(90deg, transparent, #59a6e6);
    transform: translateX(-100%);
    transition: transform 0.5s ease;
  }
}

/* 波浪动画 */
.header-waves {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 150px;
  z-index: 5;
  pointer-events: none;
  isolation: isolate;
  contain: layout style;
  margin-bottom: -1px;
  will-change: transform;
  transform: translate3d(0, 0, 0);
  backface-visibility: hidden;
}

.waves {
  overflow: visible;
  width: 100%;
  height: 100%;
  transform: translateZ(0);
  will-change: transform;
  contain: layout style;
}

.waves svg {
  width: 100%;
  height: 100%;
  display: block;
  transform: translateZ(0);
  backface-visibility: hidden;
}

.parallax {
  will-change: transform;
  transform: translateZ(0);
  backface-visibility: hidden;
}

.parallax use {
  animation: mizuki-wave 25s cubic-bezier(0.5, 0.5, 0.45, 0.5) infinite;
}

.parallax use:nth-child(1) {
  animation-delay: -2s;
  animation-duration: 7s;
}

.parallax use:nth-child(2) {
  animation-delay: -3s;
  animation-duration: 10s;
}

.parallax use:nth-child(3) {
  animation-delay: -4s;
  animation-duration: 13s;
}

.parallax use:nth-child(4) {
  animation-delay: -5s;
  animation-duration: 20s;
}

@keyframes mizuki-wave {
  0% {
    transform: translate3d(-90px, 0, 0);
  }
  100% {
    transform: translate3d(85px, 0, 0);
  }
}

/* 统计卡片 */
.stats-section {
  display: flex;
  justify-content: center;
  gap: 30px;
  padding: 20px 20px 50px;
  position: relative;
  z-index: 1;
  width: 100%;
  background: transparent;
}

.stat-card {
  background: #fff;
  padding: 30px;
  border-radius: 15px;
  text-align: center;
  min-width: 200px;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  border: 1px solid #e6e6e6;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(74, 144, 226, 0.15);

    .stat-icon {
      transform: scale(1.2);
    }
  }

  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      45deg,
      transparent,
      rgba(74, 144, 226, 0.1),
      transparent
    );
    transform: translateX(-100%);
    transition: transform 0.6s ease;
  }

  &:hover::before {
    transform: translateX(100%);
  }
}

.stat-number {
  font-size: 3rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
  background: linear-gradient(120deg, #59a6e6, #c7e2fa);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.stat-label {
  font-size: 1.2rem;
  color: #666;
}

/* 内容区域新样式 */
.content-section {
  padding: 60px 0;
  background: #eaeff4;
}

/* 通用标题样式 */
.section-title {
  display: flex;
  align-items: center;
  margin-bottom: 40px;
  padding: 0 40px;

  .title-text {
    font-size: 2.5rem;
    font-weight: bold;
    color: #333;
    font-family: Avenir, Helvetica, Arial, sans-serif;
    position: relative;
    padding-bottom: 10px;

    &::after {
      content: "";
      position: absolute;
      bottom: 0;
      left: 0;
      width: 40%;
      height: 4px;
      background: linear-gradient(90deg, #59a6e6, transparent);
    }
  }
}

/* 最新文章区域 */
.latest-articles-section {
  margin-bottom: 80px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40px;
  padding: 0 40px;
}

.view-more-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 8px 16px;
  font-size: 0.9rem;
  color: #666;
  border: none;
  background: transparent;
  transition: all 0.3s ease;

  &:hover {
    color: #59a6e6;
    transform: translateX(5px);

    .el-icon {
      transform: translateX(3px);
    }
  }

  .el-icon {
    transition: transform 0.3s ease;
  }
}

.articles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 40px;
  padding: 0 40px;
}

.article-card {
  border-radius: 15px;
  overflow: hidden;
  transition: all 0.3s ease;
  background: #fff;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
  cursor: pointer;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(74, 144, 226, 0.15);

    .article-overlay {
      opacity: 1;
    }

    .article-image img {
      transform: scale(1.05);
    }
  }
}

.article-card-inner {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.article-image {
  height: 240px;
  position: relative;
  overflow: hidden;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
  }
}

.article-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;

  .read-more {
    color: #fff;
    font-size: 1.2rem;
    padding: 10px 20px;
    border: 2px solid #fff;
    border-radius: 25px;
    transition: all 0.3s ease;

    &:hover {
      background: #fff;
      color: #333;
    }
  }
}

.article-content {
  padding: 25px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.article-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
  font-size: 0.9rem;

  .article-category {
    color: #59a6e6;
    font-weight: 500;
  }

  .article-date {
    color: #666;
  }
}

.article-title {
  font-size: 1.4rem;
  color: #333;
  margin-bottom: 15px;
  line-height: 1.4;
  font-weight: 600;
}

.article-summary {
  color: #666;
  line-height: 1.6;
  margin-bottom: 20px;
  flex: 1;
}

.article-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;

  .article-tags {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }

  .article-stats {
    color: #666;
    font-size: 0.9rem;

    .stats-item {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }
}

/* 分类和标签区域 */
.taxonomy-section {
  padding: 40px;
  background: transparent;
}

.categories-container {
  margin-bottom: 60px;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
}

.category-card {
  background: #fff;
  border-radius: 15px;
  padding: 25px;
  display: flex;
  align-items: center;
  gap: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);

  &:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(74, 144, 226, 0.15);

    .category-icon {
      transform: scale(1.1);
    }
  }
}

.category-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #59a6e6, #c7e2fa);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease;

  .el-icon {
    font-size: 24px;
    color: #fff;
  }
}

.category-info {
  flex: 1;

  h3 {
    font-size: 1.2rem;
    color: #333;
    margin-bottom: 10px;
  }
}

.category-progress {
  height: 4px;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 2px;
  margin-bottom: 8px;
  overflow: hidden;

  .progress-bar {
    height: 100%;
    background: linear-gradient(90deg, #59a6e6, #c7e2fa);
    border-radius: 2px;
    transition: width 0.3s ease;
  }
}

.category-count {
  font-size: 0.9rem;
  color: #666;
}

.tags-container {
  .tags-cloud {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    padding: 0 40px;
  }

  .tag-item {
    padding: 8px 16px;
    font-size: 1rem;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-3px) rotate(3deg);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }
  }
}

/* 响应式调整 */
@media (max-width: 768px) {
  .stat-card {
    min-width: 0;
    flex: 1;
    padding: 20px 14px;
  }
  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
    padding: 0 20px;
  }

  .view-more-btn {
    align-self: flex-end;
  }

  .section-title .title-text {
    font-size: 2rem;
  }

  .articles-grid {
    grid-template-columns: 1fr;
    padding: 0 20px;
    gap: 30px;
  }

  .taxonomy-section {
    padding: 20px;
  }

  .categories-grid {
    grid-template-columns: 1fr;
  }

  .tags-container .tags-cloud {
    padding: 0 20px;
  }
}

/* 动画关键帧 */
@keyframes blink {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
