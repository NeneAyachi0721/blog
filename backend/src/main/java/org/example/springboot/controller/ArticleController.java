package org.example.springboot.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Article;
import org.example.springboot.service.ArticleService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "文章管理接口")
@RestController
@RequestMapping("/article")
public class ArticleController {
    @Resource
    private ArticleService articleService;
    
    @Operation(summary = "分页查询文章")
    @GetMapping("/page")
    public Result<Page<Article>> getArticlesByPage(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Article> page = articleService.getArticlesByPage(title, categoryId, status, currentPage, size);
        return Result.success(page);
    }
    
    @Operation(summary = "获取文章详情")
    @GetMapping("/{id}")
    public Result<Article> getArticleById(@PathVariable Long id) {
        Article article = articleService.getArticleById(id);
        // 更新浏览量
        articleService.updateArticleViewCount(id);
        return Result.success(article);
    }
    
    @Operation(summary = "获取推荐文章")
    @GetMapping("/recommend")
    public Result<List<Article>> getRecommendArticles(
            @RequestParam(defaultValue = "5") Integer limit) {
        List<Article> articles = articleService.getRecommendArticles(limit);
        return Result.success(articles);
    }
    
    @Operation(summary = "获取热门文章")
    @GetMapping("/hot")
    public Result<List<Article>> getHotArticles(
            @RequestParam(defaultValue = "5") Integer limit) {
        List<Article> articles = articleService.getHotArticles(limit);
        return Result.success(articles);
    }
    
    @Operation(summary = "新增文章")
    @PostMapping
    public Result<?> addArticle(@RequestBody Article article) {
        articleService.addArticle(article);
        return Result.success();
    }
    
    @Operation(summary = "更新文章")
    @PutMapping("/{id}")
    public Result<?> updateArticle(@PathVariable Long id, @RequestBody Article article) {
        article.setId(id);
        articleService.updateArticle(article);
        return Result.success();
    }
    
    @Operation(summary = "删除文章")
    @DeleteMapping("/{id}")
    public Result<?> deleteArticle(@PathVariable Long id) {
        articleService.deleteArticle(id);
        return Result.success();
    }
    
    @Operation(summary = "修改文章状态")
    @PutMapping("/{id}/status")
    public Result<?> updateArticleStatus(
            @PathVariable Long id,
            @RequestParam Integer status) {
        articleService.updateArticleStatus(id, status);
        return Result.success();
    }
    
    @Operation(summary = "根据分类ID获取文章列表")
    @GetMapping("/category/{categoryId}")
    public Result<Page<Article>> getArticlesByCategoryId(
            @PathVariable Long categoryId,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Article> page = articleService.getArticlesByCategoryId(categoryId, currentPage, size);
        return Result.success(page);
    }
    
    @Operation(summary = "根据标签ID获取文章列表")
    @GetMapping("/tag/{tagId}")
    public Result<Page<Article>> getArticlesByTagId(
            @PathVariable Long tagId,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Article> page = articleService.getArticlesByTagId(tagId, currentPage, size);
        return Result.success(page);
    }
    
    @Operation(summary = "搜索文章")
    @GetMapping("/search")
    public Result<Page<Article>> searchArticles(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Article> page = articleService.searchArticles(keyword, currentPage, size);
        return Result.success(page);
    }
    
    @Operation(summary = "获取文章点赞用户列表")
    @GetMapping("/{id}/like/users")
    public Result<?> getArticleLikeUsers(
            @PathVariable Long id,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {

        return Result.success(articleService.getArticleLikeUsers(id, currentPage, size));
    }
    
    @Operation(summary = "获取文章收藏用户列表")
    @GetMapping("/{id}/collect/users")
    public Result<?> getArticleCollectUsers(
            @PathVariable Long id,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {

        return Result.success(articleService.getArticleCollectUsers(id, currentPage, size));
    }
    
    @Operation(summary = "获取最近发布的文章")
    @GetMapping("/recent")
    public Result<?> getRecentArticles(@RequestParam(defaultValue = "5") Integer size) {
//        LOGGER.info("获取最近发布的文章, size={}", size);
        List<Article> articles = articleService.getRecentArticles(size);
        return Result.success(articles);
    }
} 