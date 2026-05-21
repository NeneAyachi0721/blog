package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.entity.Comment;
import org.example.springboot.service.CommentService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Tag(name="评论接口")
@RestController
@RequestMapping("/comment")
public class CommentController {
    
    @Resource
    private CommentService commentService;
    
    @Operation(summary = "添加评论")
    @PostMapping
    public Result<?> addComment(@RequestBody Comment comment) {
        Long commentId = commentService.addComment(comment);
        return Result.success(commentId);
    }
    
    @Operation(summary = "获取文章评论列表")
    @GetMapping("/article/{articleId}")
    public Result<?> getCommentsByArticle(
            @PathVariable Long articleId,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(commentService.getCommentsByArticle(articleId, currentPage, size));
    }
    
    @Operation(summary = "获取用户评论列表")
    @GetMapping("/user")
    public Result<?> getUserComments(
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {
        Long userId = JwtTokenUtils.getCurrentUser().getId();
        return Result.success(commentService.getUserComments(userId, currentPage, size));
    }
    
    @Operation(summary = "删除评论")
    @DeleteMapping("/{id}")
    public Result<?> deleteComment(@PathVariable Long id) {
        commentService.deleteComment(id);
        return Result.success();
    }
    
    @Operation(summary = "审核评论")
    @PutMapping("/audit/{id}")
    public Result<?> auditComment(
            @PathVariable Long id, 
            @RequestParam Integer status) {
        commentService.auditComment(id, status);
        return Result.success();
    }

    @Operation(summary = "管理员获取评论分页列表")
    @GetMapping("/admin/page")
    public Result<?> getAdminCommentPage(
            @RequestParam(defaultValue = "") String articleTitle,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {

        return Result.success(commentService.getAdminCommentPage(articleTitle, status, currentPage, size));
    }

    @Operation(summary = "获取最近评论")
    @GetMapping("/recent")
    public Result<?> getRecentComments(@RequestParam(defaultValue = "5") Integer size) {
//        LOGGER.info("获取最近评论, size={}", size);
        List<Map<String, Object>> comments = commentService.getRecentComments(size);
        return Result.success(comments);
    }
} 