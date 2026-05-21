package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.service.UserCollectService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Tag(name="文章收藏接口")
@RestController
@RequestMapping("/article")
public class ArticleCollectController {
    
    @Resource
    private UserCollectService userCollectService;
    
    @Operation(summary = "收藏或取消收藏文章")
    @PostMapping("/{id}/collect")
    public Result<?> toggleCollect(@PathVariable("id") Long articleId) {
        boolean isCollected = userCollectService.toggleCollect(articleId);
        Map<String, Object> data = new HashMap<>();
        data.put("collected", isCollected);
        return Result.success(data);
    }
    
    @Operation(summary = "检查用户是否收藏了文章")
    @GetMapping("/{id}/collect/status")
    public Result<?> checkCollectStatus(@PathVariable("id") Long articleId) {
        boolean isCollected = userCollectService.checkUserCollected(articleId);
        Map<String, Object> data = new HashMap<>();
        data.put("collected", isCollected);
        return Result.success(data);
    }
    
    @Operation(summary = "获取用户收藏的文章ID列表")
    @GetMapping("/user/collects")
    public Result<?> getUserCollectedArticles() {
        Long userId = JwtTokenUtils.getCurrentUser().getId();
        Long[] articleIds = userCollectService.getUserCollectedArticleIds(userId);
        return Result.success(articleIds);
    }
    
    @Operation(summary = "获取用户收藏的文章分页列表")
    @GetMapping("/user/collects/page")
    public Result<?> getUserCollectedArticlePage(
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(userCollectService.getUserCollectedArticlePage(currentPage, size));
    }
} 