<template>
  <div class="article-edit-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>{{ isEdit ? "编辑文章" : "写文章" }}</span>
          <div class="action-buttons">
            <el-button @click="$router.push('/back/article')"
              >返回列表</el-button
            >
            <el-button type="info" @click="saveArticle(0)">保存草稿</el-button>
            <el-button type="primary" @click="saveArticle(1)"
              >发布文章</el-button
            >
          </div>
        </div>
      </template>

      <!-- 文章表单 -->
      <el-form
        ref="articleFormRef"
        :model="articleForm"
        :rules="articleRules"
        label-width="100px"
      >
        <el-form-item label="标题" prop="title">
          <el-input v-model="articleForm.title" placeholder="请输入文章标题" />
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="分类" prop="categoryId">
              <el-select
                v-model="articleForm.categoryId"
                placeholder="请选择文章分类"
                style="width: 100%"
              >
                <el-option
                  v-for="item in categoryOptions"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标签">
              <el-select
                v-model="articleForm.tagIds"
                multiple
                placeholder="请选择文章标签"
                style="width: 100%"
              >
                <el-option
                  v-for="item in tagOptions"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
                >
                  <div class="tag-option">
                    <div
                      class="color-dot"
                      :style="{ backgroundColor: item.color }"
                    ></div>
                    <span>{{ item.name }}</span>
                  </div>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="封面图片">
          <el-upload
            class="cover-uploader"
            action="#"
            :auto-upload="true"
            :show-file-list="false"
            :http-request="uploadCoverImage"
            :before-upload="beforeCoverUpload"
          >
            <el-image
              v-if="coverImageUrl"
              :src="coverImageUrl"
              fit="cover"
              class="cover-image"
            />
            <div v-else class="upload-placeholder">
              <el-icon class="upload-icon"><Plus /></el-icon>
              <div class="upload-text">点击上传封面</div>
            </div>
          </el-upload>
          <div class="tip">建议尺寸: 900x500px, 大小不超过2MB</div>
        </el-form-item>

        <el-form-item label="摘要" prop="summary">
          <el-input
            v-model="articleForm.summary"
            type="textarea"
            :rows="3"
            placeholder="请输入文章摘要，如不填写将自动提取正文前150字"
          />
        </el-form-item>

        <el-form-item label="正文" prop="htmlContent" class="content-item">
          <!-- 富文本编辑器 -->
          <div style="border: 1px solid #ccc; z-index: 100">
            <Toolbar
              style="border-bottom: 1px solid #ccc"
              :editor="editorRef"
              :defaultConfig="toolbarConfig"
              :mode="mode"
            />
            <Editor
              style="height: 500px; overflow-y: hidden"
              v-model="valueHtml"
              :defaultConfig="editorConfig"
              :mode="mode"
              @onCreated="handleCreated"
            />
          </div>
        </el-form-item>

        <el-form-item>
          <el-row :gutter="20">
            <el-col :span="8">
              <el-checkbox v-model="articleForm.isTop">置顶文章</el-checkbox>
            </el-col>
            <el-col :span="8">
              <el-checkbox v-model="articleForm.isRecommend"
                >推荐文章</el-checkbox
              >
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import {
  ref,
  reactive,
  onMounted,
  computed,
  onBeforeUnmount,
  shallowRef,
  watch,
} from "vue";
import { useRoute, useRouter } from "vue-router";
import request from "@/utils/request";
import { ElMessage } from "element-plus";
import { Plus } from "@element-plus/icons-vue";
import "@wangeditor/editor/dist/css/style.css";
import { Editor, Toolbar } from "@wangeditor/editor-for-vue";

const route = useRoute();
const router = useRouter();

// 判断是否为编辑模式
const isEdit = computed(() => !!route.params.id);

// 基础路径
const baseAPI = process.env.VUE_APP_BASE_API || "/api";

// 表单引用
const articleFormRef = ref(null);
// 分类选项
const categoryOptions = ref([]);
// 标签选项
const tagOptions = ref([]);

// 文章表单 - 必须在使用之前定义
const articleForm = reactive({
  id: null,
  title: "",
  content: "",
  htmlContent: "",
  summary: "",
  coverImage: "",
  categoryId: null,
  tagIds: [], // 存储标签ID而不是整个对象
  tags: [], // 保留兼容性
  isTop: false,
  isRecommend: false,
  status: 0, // 0:草稿, 1:已发布
});

// 编辑器实例，必须用 shallowRef
const editorRef = shallowRef();
// 编辑器内容
const valueHtml = ref("");

// 监听valueHtml变化，同步到articleForm.htmlContent
watch(valueHtml, (newValue) => {
  articleForm.htmlContent = newValue;
  // 提取纯文本
  if (editorRef.value) {
    articleForm.content = editorRef.value.getText();
  }
});

// 监听tagIds变化，确保UI更新
watch(
  () => articleForm.tagIds,
  (newIds) => {
    // 可以在这里处理tagIds变化的逻辑
    console.log("标签选择变化:", newIds);
  },
  { deep: true },
);

// 编辑器配置
const editorConfig = {
  placeholder: "请输入文章内容...",
  MENU_CONF: {
    uploadImage: {
      server: `${baseAPI}/file/upload/img`,
      fieldName: "file",
      headers: {
        token: localStorage.getItem("token") || "",
      },
      // 自定义上传参数
      meta: {
        token: localStorage.getItem("token") || "",
      },
      // 单个文件的最大体积限制，默认为 2M
      maxFileSize: 5 * 1024 * 1024,
      // 最多可上传几个文件，默认为 100
      maxNumberOfFiles: 10,
      // 选择文件时的类型限制，默认为 ['image/*']
      allowedFileTypes: ["image/*"],
      // 自定义上传
      customUpload(file, insertFn) {
        // file 是 File 对象
        // insertFn 是回调函数，接收图片 url 作为参数，插入到编辑器
        const formData = new FormData();
        formData.append("file", file);

        request.post("/file/upload/img", formData, {
          transformRequest: [(data) => data],
          headers: {
            "Content-Type": "multipart/form-data",
          },
          showDefaultMsg: false,
          onSuccess: (data) => {
            // 上传成功，获取图片 url 并插入到编辑器
            insertFn(`${baseAPI}${data}`);
          },
        });
      },
    },
  },
};
// 工具栏配置
const toolbarConfig = {};
// 编辑器模式
const mode = "default"; // 或 'simple'

// 表单验证规则
const articleRules = {
  title: [
    { required: true, message: "请输入文章标题", trigger: "blur" },
    { min: 2, max: 100, message: "长度在 2 到 100 个字符", trigger: "blur" },
  ],
  categoryId: [
    { required: true, message: "请选择文章分类", trigger: "change" },
  ],
  htmlContent: [{ required: true, message: "请输入文章内容", trigger: "blur" }],
};

// 封面图片URL
const coverImageUrl = computed(() => {
  if (!articleForm.coverImage) return "";
  return baseAPI + articleForm.coverImage;
});

// 初始化
onMounted(async () => {
  await Promise.all([fetchCategoryList(), fetchTagList()]);

  // 如果是编辑模式，获取文章详情
  if (isEdit.value) {
    fetchArticleDetail(route.params.id);
  }
});

// 组件销毁时，也销毁编辑器
onBeforeUnmount(() => {
  const editor = editorRef.value;
  if (editor == null) return;
  editor.destroy();
});

// 编辑器创建完成时的回调
const handleCreated = (editor) => {
  editorRef.value = editor;

  // 如果有内容，设置到编辑器中
  if (articleForm.htmlContent) {
    valueHtml.value = articleForm.htmlContent;
  }
};

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

// 获取标签列表
const fetchTagList = async () => {
  try {
    await request.get(
      "/tag",
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          tagOptions.value = data;
        },
      },
    );
  } catch (error) {
    console.error("获取标签列表失败:", error);
  }
};

// 获取文章详情
const fetchArticleDetail = async (id) => {
  try {
    await request.get(
      `/article/${id}`,
      {},
      {
        showDefaultMsg: false,
        onSuccess: (data) => {
          // 填充表单数据
          articleForm.id = data.id;
          articleForm.title = data.title;
          articleForm.content = data.content;
          articleForm.htmlContent = data.htmlContent || data.content;
          articleForm.summary = data.summary;
          articleForm.coverImage = data.coverImage;
          articleForm.categoryId = data.categoryId;

          // 设置标签ID数组
          if (data.tags && Array.isArray(data.tags)) {
            articleForm.tags = data.tags;
            articleForm.tagIds = data.tags.map((tag) => tag.id);
          }

          articleForm.isTop = data.isTop === 1;
          articleForm.isRecommend = data.isRecommend === 1;
          articleForm.status = data.status;

          // 设置编辑器内容
          if (editorRef.value) {
            valueHtml.value = data.htmlContent || data.content;
          }
        },
      },
    );
  } catch (error) {
    console.error("获取文章详情失败:", error);
    ElMessage.error("获取文章详情失败");
    router.push("/back/article");
  }
};

// 封面图片上传前的校验
const beforeCoverUpload = (file) => {
  const isImage = file.type.startsWith("image/");
  const isLt2M = file.size / 1024 / 1024 < 2;

  if (!isImage) {
    ElMessage.error("封面只能是图片格式!");
    return false;
  }

  if (!isLt2M) {
    ElMessage.error("封面大小不能超过 2MB!");
    return false;
  }

  return true;
};

// 上传封面图片
const uploadCoverImage = async (options) => {
  try {
    const { file } = options;

    // 创建 FormData 对象
    const formData = new FormData();
    formData.append("file", file);

    // 发送上传请求
    await request.post("/file/upload/img", formData, {
      transformRequest: [(data) => data],
      headers: {
        "Content-Type": "multipart/form-data",
      },
      successMsg: "封面上传成功",
      onSuccess: (data) => {
        articleForm.coverImage = data;
        options.onSuccess();
      },
    });
  } catch (error) {
    options.onError(error);
    console.error("封面上传失败:", error);
  }
};

// 保存文章
const saveArticle = (status) => {
  // 如果摘要为空，自动提取正文前150字
  if (!articleForm.summary && articleForm.content) {
    articleForm.summary = articleForm.content.slice(0, 150);
  }

  // 从articleForm.tagIds构建tags数组，保持后端兼容性
  const tagsData = articleForm.tagIds.map((id) => {
    const tagObj = tagOptions.value.find((tag) => tag.id === id);
    return { id: id, ...tagObj };
  });

  // 转换布尔值为数字
  const formData = {
    ...articleForm,
    isTop: articleForm.isTop ? 1 : 0,
    isRecommend: articleForm.isRecommend ? 1 : 0,
    status,
    tags: tagsData, // 发送标签对象数组，与后端ArticleService.saveArticleTags方法兼容
  };

  articleFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (isEdit.value) {
          // 更新文章
          await request.put(`/article/${articleForm.id}`, formData, {
            successMsg: status === 1 ? "文章发布成功" : "文章已保存为草稿",
            onSuccess: () => {
              router.push("/back/article");
            },
          });
        } else {
          // 新增文章
          await request.post("/article", formData, {
            successMsg: status === 1 ? "文章发布成功" : "文章已保存为草稿",
            onSuccess: () => {
              router.push("/back/article");
            },
          });
        }
      } catch (error) {
        console.error("保存文章失败:", error);
      }
    }
  });
};
</script>

<style>
/* 全局富文本编辑器样式 */
.w-e-toolbar {
  z-index: 2001 !important;
}

.w-e-menu {
  z-index: 2002 !important;
}

.w-e-text-container {
  z-index: 2000 !important;
  text-align: left !important;
}

.w-e-dropdown-menu {
  z-index: 2003 !important;
}

/* 确保编辑器内容正确显示 */
.w-e-text-container .w-e-text p {
  margin: 10px 0;
}

.w-e-text-container .w-e-text h1,
.w-e-text-container .w-e-text h2,
.w-e-text-container .w-e-text h3,
.w-e-text-container .w-e-text h4,
.w-e-text-container .w-e-text h5 {
  margin: 10px 0;
  font-weight: bold;
}

.w-e-text-container .w-e-text ul,
.w-e-text-container .w-e-text ol {
  margin: 10px 0 10px 20px;
}

.w-e-text-container .w-e-text img {
  max-width: 100%;
  height: auto;
}

.w-e-text-container .w-e-text code {
  background-color: #f6f6f6;
  padding: 2px 4px;
  border-radius: 3px;
}

.w-e-text-container .w-e-text pre {
  background-color: #f6f6f6;
  padding: 10px;
  border-radius: 5px;
  overflow: auto;
}

.w-e-text-container .w-e-text blockquote {
  border-left: 3px solid #d0d0d0;
  padding-left: 10px;
  color: #666;
  margin: 10px 0;
}
</style>

<style scoped>
.article-edit-container {
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

.action-buttons {
  display: flex;
  gap: 12px;
}

.action-buttons .el-button {
  border-radius: 4px;
  font-weight: 500;
}

.content-item {
  margin-bottom: 24px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #333;
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

.cover-uploader {
  width: 360px;
}

.cover-image {
  width: 360px;
  height: 200px;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #eaeaea;
}

.upload-placeholder {
  width: 360px;
  height: 200px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border: 1px dashed #d9d9d9;
  border-radius: 4px;
  background-color: #fafafa;
  cursor: pointer;
  transition: all 0.3s;
}

.upload-placeholder:hover {
  border-color: #333;
  background-color: #f0f0f0;
}

.upload-icon {
  font-size: 28px;
  color: #666;
  margin-bottom: 8px;
}

.upload-text {
  color: #666;
  font-size: 14px;
}

.tip {
  margin-top: 8px;
  font-size: 12px;
  color: #666;
}

.tag-option {
  display: flex;
  align-items: center;
}

.color-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 8px;
}

/* 编辑器样式优化 */
:deep(.w-e-toolbar) {
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  border-color: #eaeaea !important;
}

:deep(.w-e-text-container) {
  border-bottom-left-radius: 4px;
  border-bottom-right-radius: 4px;
  border-color: #eaeaea !important;
}

:deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
  background-color: #333;
  border-color: #333;
}

:deep(.el-checkbox__input.is-focus .el-checkbox__inner) {
  border-color: #333;
}

:deep(.el-checkbox__inner:hover) {
  border-color: #333;
}

:deep(.el-checkbox__label) {
  color: #333;
}
</style>
