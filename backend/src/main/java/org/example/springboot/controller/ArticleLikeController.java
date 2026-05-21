package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.service.UserLikeService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Tag(name="文章点赞接口")
@RestController
@RequestMapping("/article")
public class ArticleLikeController {
    
    @Resource
    private UserLikeService userLikeService;
    
    @Operation(summary = "点赞或取消点赞文章")
    @PostMapping("/{id}/like")
    public Result<?> toggleLike(@PathVariable("id") Long articleId) {
        boolean isLiked = userLikeService.toggleLike(articleId);
        Map<String, Object> data = new HashMap<>();
        data.put("liked", isLiked);
        return Result.success(data);
    }
    
    @Operation(summary = "检查用户是否点赞了文章")
    @GetMapping("/{id}/like/status")
    public Result<?> checkLikeStatus(@PathVariable("id") Long articleId) {
        boolean isLiked = userLikeService.checkUserLiked(articleId);
        Map<String, Object> data = new HashMap<>();
        data.put("liked", isLiked);
        return Result.success(data);
    }
    
    @Operation(summary = "获取用户点赞的文章ID列表")
    @GetMapping("/user/likes")
    public Result<?> getUserLikedArticles() {
        Long userId = JwtTokenUtils.getCurrentUser().getId();
        Long[] articleIds = userLikeService.getUserLikedArticleIds(userId);
        return Result.success(articleIds);
    }
    
    @Operation(summary = "获取用户点赞的文章分页列表")
    @GetMapping("/user/likes/page")
    public Result<?> getUserLikedArticlePage(
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(userLikeService.getUserLikedArticlePage(currentPage, size));
    }
} 