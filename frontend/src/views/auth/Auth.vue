<template>
  <div class="auth-container">
    <!-- 背景动态装饰 - 彩色流星和素描元素 -->
    <div class="bg-decoration">
      <div class="meteor-shower">
        <div class="meteor meteor-1 meteor-blue"></div>
        <div class="meteor meteor-2 meteor-purple"></div>
        <div class="meteor meteor-3 meteor-orange"></div>
        <div class="meteor meteor-4 meteor-green"></div>
        <div class="meteor meteor-5 meteor-pink"></div>
        <div class="meteor meteor-6 meteor-gold"></div>
        <div class="meteor meteor-7 meteor-blue"></div>
        <div class="meteor meteor-8 meteor-purple"></div>
        <div class="meteor meteor-9 meteor-orange"></div>
        <div class="meteor meteor-10 meteor-green"></div>
        <div class="meteor meteor-11 meteor-pink"></div>
        <div class="meteor meteor-12 meteor-gold"></div>
        <div class="meteor meteor-13 meteor-blue"></div>
        <div class="meteor meteor-14 meteor-purple"></div>
        <div class="meteor meteor-15 meteor-orange"></div>
      </div>

      <!-- 素描风格装饰元素 -->
      <div class="sketch-elements">
        <div class="sketch-circle"></div>
        <div class="sketch-line sketch-line-1"></div>
        <div class="sketch-line sketch-line-2"></div>
        <div class="sketch-dot sketch-dot-1"></div>
        <div class="sketch-dot sketch-dot-2"></div>
        <div class="sketch-dot sketch-dot-3"></div>
        <div class="sketch-curve"></div>
      </div>
    </div>

    <div class="auth-layout">
      <!-- 左侧装饰区域 -->
      <div class="auth-left">
        <div class="brand-content">
          <div class="logo">
            <Notebook />
          </div>
          <h1 class="title">个人博客系统</h1>
          <div class="subtitle">PERSONAL BLOG SYSTEM</div>
          <p class="tagline">记录思想，分享生活</p>
        </div>

        <!-- 优化的装饰元素 -->
        <div class="decorative-elements">
          <div class="circle circle-1"></div>
          <div class="circle circle-2"></div>
          <div class="square"></div>
        </div>
      </div>

      <!-- 右侧表单区域 -->
      <div class="auth-right">
        <div class="auth-form-container">
          <h2 class="form-title" v-if="showHeader">{{ formTitle }}</h2>

          <el-form
            :model="formData"
            :rules="rules"
            ref="formRef"
            class="auth-form"
          >
            <slot name="form-items"></slot>

            <el-form-item>
              <el-button
                type="primary"
                :loading="loading"
                @click="handleSubmit"
                class="auth-button"
              >
                {{ submitText }}
              </el-button>
            </el-form-item>

            <div class="auth-links">
              <slot name="auth-links"></slot>
            </div>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { Notebook } from "@element-plus/icons-vue";

const props = defineProps({
  formData: {
    type: Object,
    required: true,
  },
  rules: {
    type: Object,
    required: true,
  },
  loading: {
    type: Boolean,
    default: false,
  },
  submitText: {
    type: String,
    default: "提交",
  },
  showHeader: {
    type: Boolean,
    default: true,
  },
  formTitle: {
    type: String,
    default: "欢迎",
  },
});

const formRef = ref(null);

const emit = defineEmits(["submit"]);

const handleSubmit = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      emit("submit", formRef);
    }
  });
};

defineExpose({
  formRef,
});
</script>

<style lang="scss" scoped>
.auth-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #eaeff4;
  position: relative;
  overflow: hidden;
}

/* 背景装饰 - 彩色流星和素描效果 */
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;
}

.meteor-shower {
  width: 100%;
  height: 100%;
  position: absolute;
}

.meteor {
  position: absolute;
  height: 3px;
  width: 120px;
  transform: rotate(-45deg);
  opacity: 0;
  border-radius: 100px;
  filter: blur(1px);
}

.meteor-blue {
  background: linear-gradient(
    to right,
    rgba(65, 105, 225, 0.7),
    rgba(65, 105, 225, 0)
  );
  box-shadow: 0 0 10px rgba(65, 105, 225, 0.4);
}

.meteor-purple {
  background: linear-gradient(
    to right,
    rgba(147, 112, 219, 0.7),
    rgba(147, 112, 219, 0)
  );
  box-shadow: 0 0 10px rgba(147, 112, 219, 0.4);
}

.meteor-orange {
  background: linear-gradient(
    to right,
    rgba(255, 140, 0, 0.7),
    rgba(255, 140, 0, 0)
  );
  box-shadow: 0 0 10px rgba(255, 140, 0, 0.4);
}

.meteor-green {
  background: linear-gradient(
    to right,
    rgba(50, 205, 50, 0.7),
    rgba(50, 205, 50, 0)
  );
  box-shadow: 0 0 10px rgba(50, 205, 50, 0.4);
}

.meteor-pink {
  background: linear-gradient(
    to right,
    rgba(255, 105, 180, 0.7),
    rgba(255, 105, 180, 0)
  );
  box-shadow: 0 0 10px rgba(255, 105, 180, 0.4);
}

.meteor-gold {
  background: linear-gradient(
    to right,
    rgba(255, 215, 0, 0.7),
    rgba(255, 215, 0, 0)
  );
  box-shadow: 0 0 10px rgba(255, 215, 0, 0.4);
}

.meteor-1 {
  top: 10%;
  left: 20%;
  animation: meteor-fall 5s linear infinite;
  animation-delay: 0s;
}

.meteor-2 {
  top: 15%;
  left: 60%;
  width: 180px;
  animation: meteor-fall 7s linear infinite;
  animation-delay: 1s;
}

.meteor-3 {
  top: 5%;
  left: 40%;
  width: 150px;
  animation: meteor-fall-alt 6s linear infinite;
  animation-delay: 2.5s;
}

.meteor-4 {
  top: 20%;
  left: 80%;
  width: 200px;
  animation: meteor-fall 8s linear infinite;
  animation-delay: 4s;
}

.meteor-5 {
  top: 30%;
  left: 30%;
  width: 160px;
  animation: meteor-fall 6.5s linear infinite;
  animation-delay: 5.5s;
}

.meteor-6 {
  top: 25%;
  left: 70%;
  width: 190px;
  animation: meteor-fall 7.5s linear infinite;
  animation-delay: 7s;
}

.meteor-7 {
  top: 8%;
  left: 35%;
  width: 140px;
  animation: meteor-fall-alt 6.2s linear infinite;
  animation-delay: 1.8s;
}

.meteor-8 {
  top: 12%;
  left: 75%;
  width: 170px;
  animation: meteor-fall-alt 7.8s linear infinite;
  animation-delay: 3.2s;
}

.meteor-9 {
  top: 18%;
  left: 25%;
  width: 130px;
  animation: meteor-fall-alt 5.5s linear infinite;
  animation-delay: 4.7s;
}

.meteor-10 {
  top: 22%;
  left: 55%;
  width: 160px;
  animation: meteor-fall-alt 6.8s linear infinite;
  animation-delay: 2.3s;
}

.meteor-11 {
  top: 28%;
  left: 85%;
  width: 190px;
  animation: meteor-fall-alt 7.2s linear infinite;
  animation-delay: 5.9s;
}

.meteor-12 {
  top: 35%;
  left: 15%;
  width: 150px;
  animation: meteor-fall-alt 5.8s linear infinite;
  animation-delay: 3.5s;
}

.meteor-13 {
  top: 40%;
  left: 45%;
  width: 120px;
  animation: meteor-fall-alt 5.2s linear infinite;
  animation-delay: 0.7s;
}

.meteor-14 {
  top: 45%;
  left: 65%;
  width: 180px;
  animation: meteor-fall-alt 7.4s linear infinite;
  animation-delay: 4.2s;
}

.meteor-15 {
  top: 50%;
  left: 10%;
  width: 140px;
  animation: meteor-fall-alt 6.3s linear infinite;
  animation-delay: 2.8s;
}

@keyframes meteor-fall {
  0% {
    transform: translateX(0) translateY(0) rotate(-45deg);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  70% {
    opacity: 1;
  }
  100% {
    transform: translateX(-500px) translateY(500px) rotate(-45deg);
    opacity: 0;
  }
}

@keyframes meteor-fall-alt {
  0% {
    transform: translateX(0) translateY(0) rotate(-35deg);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  70% {
    opacity: 1;
  }
  100% {
    transform: translateX(-600px) translateY(400px) rotate(-35deg);
    opacity: 0;
  }
}

/* 素描风格装饰元素 */
.sketch-elements {
  position: absolute;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.sketch-circle {
  position: absolute;
  width: 200px;
  height: 200px;
  border: 2px solid rgba(80, 80, 80, 0.1);
  border-radius: 50%;
  top: 70%;
  left: 10%;
  transform: rotate(15deg);
  border-style: solid;
  border-top-width: 2px;
  border-right-width: 1px;
  border-bottom-width: 3px;
  border-left-width: 2px;
}

.sketch-line {
  position: absolute;
  background-color: rgba(80, 80, 80, 0.1);
  transform-origin: center;
}

.sketch-line-1 {
  width: 300px;
  height: 1px;
  top: 40%;
  right: 10%;
  transform: rotate(30deg);
  background: linear-gradient(
    to right,
    transparent,
    rgba(80, 80, 80, 0.2),
    transparent
  );
}

.sketch-line-2 {
  width: 200px;
  height: 1px;
  bottom: 30%;
  right: 30%;
  transform: rotate(-20deg);
  background: linear-gradient(
    to right,
    transparent,
    rgba(80, 80, 80, 0.15),
    transparent
  );
}

.sketch-dot {
  position: absolute;
  border-radius: 50%;
  background-color: rgba(80, 80, 80, 0.15);
}

.sketch-dot-1 {
  width: 10px;
  height: 10px;
  top: 25%;
  left: 15%;
}

.sketch-dot-2 {
  width: 6px;
  height: 6px;
  top: 60%;
  right: 20%;
}

.sketch-dot-3 {
  width: 8px;
  height: 8px;
  bottom: 15%;
  left: 40%;
}

.sketch-curve {
  position: absolute;
  width: 300px;
  height: 300px;
  border: 1px solid rgba(80, 80, 80, 0.1);
  border-radius: 50%;
  bottom: -150px;
  right: -100px;
  border-top: none;
  border-left: none;
}

.auth-layout {
  display: flex;
  width: 900px;
  height: 600px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  position: relative;
  z-index: 1;
  background-color: white;
}

.auth-left {
  flex: 1;
  background-color: #fff;
  color: #333;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  border-right: 1px solid #eaeaea;
}

.brand-content {
  text-align: center;
  z-index: 2;
  padding: 0 40px;
  position: relative;
}

.logo {
  margin-bottom: 20px;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background-color: #f8f8f8;
  margin: 0 auto 20px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);

  i {
    font-size: 36px;
    color: #333;
  }

  svg {
    width: 36px;
    height: 36px;
  }
}

.title {
  font-size: 28px;
  font-weight: 600;
  margin: 0 0 8px;
  letter-spacing: 1px;
  color: #333;
  font-family: "SimSun", serif; /* 宋体 */
}

.subtitle {
  font-size: 14px;
  font-weight: 300;
  letter-spacing: 4px;
  opacity: 0.7;
  margin-bottom: 24px;
  color: #666;
  font-family: "SimSun", serif; /* 宋体 */
}

.tagline {
  font-size: 16px;
  font-weight: 300;
  line-height: 1.6;
  opacity: 0.8;
  color: #666;
  font-family: "SimSun", serif; /* 宋体 */
}

/* 装饰元素 */
.decorative-elements {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
  z-index: 1;
}

.circle {
  position: absolute;
  border-radius: 50%;
}

.circle-1 {
  width: 200px;
  height: 200px;
  border: 1px solid #f0f0f0;
  top: -100px;
  right: -100px;
}

.circle-2 {
  width: 150px;
  height: 150px;
  border: 1px solid #f0f0f0;
  bottom: -50px;
  left: -50px;
}

.square {
  position: absolute;
  width: 100px;
  height: 100px;
  border: 1px solid #f0f0f0;
  bottom: 50px;
  right: 30px;
  transform: rotate(15deg);
}

.auth-right {
  flex: 1;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.auth-form-container {
  width: 80%;
  max-width: 360px;
}

.form-title {
  font-size: 24px;
  font-weight: 500;
  color: #333;
  margin-bottom: 30px;
  text-align: center;
}

.auth-form {
  :deep(.el-input__wrapper) {
    border-radius: 8px;
    box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1);
    padding: 0 15px;
    height: 48px;
    transition: all 0.3s ease;

    &:hover,
    &.is-focus {
      box-shadow: 0 0 0 1px #333;
    }
  }

  :deep(.el-input__inner) {
    height: 48px;
    font-size: 15px;
  }

  :deep(.el-form-item) {
    margin-bottom: 20px;
  }

  :deep(.el-form-item__error) {
    padding-top: 4px;
    font-size: 12px;
  }
}

.auth-button {
  width: 100%;
  height: 48px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  letter-spacing: 1px;
  background: #333;
  border: none;
  transition: all 0.3s ease;

  &:hover,
  &:focus {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    opacity: 0.9;
  }
}

.auth-links {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
  font-size: 14px;

  a {
    color: #333;
    text-decoration: none;
    transition: all 0.3s ease;

    &:hover {
      color: #000;
      text-decoration: underline;
    }
  }
}
</style>
