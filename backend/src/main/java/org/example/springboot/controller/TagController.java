package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;

import jakarta.annotation.Resource;
import org.example.springboot.common.Result;

import org.example.springboot.entity.Tag;
import org.example.springboot.service.TagService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@io.swagger.v3.oas.annotations.tags.Tag(name = "标签管理接口")
@RestController
@RequestMapping("/tag")
public class TagController {
    @Resource
    private TagService tagService;
    
    @Operation(summary = "获取所有标签")
    @GetMapping
    public Result<List<Tag>> getAllTags() {
        List<Tag> tags = tagService.getAllTags();
        return Result.success(tags);
    }
    
    @Operation(summary = "根据ID获取标签")
    @GetMapping("/{id}")
    public Result<Tag> getTagById(@PathVariable Long id) {
        org.example.springboot.entity.Tag tag = tagService.getTagById(id);
        return Result.success(tag);
    }
    
    @Operation(summary = "新增标签")
    @PostMapping
    public Result<?> addTag(@RequestBody Tag tag) {
        tagService.addTag(tag);
        return Result.success();
    }
    
    @Operation(summary = "更新标签")
    @PutMapping("/{id}")
    public Result<?> updateTag(@PathVariable Long id, @RequestBody Tag tag) {
        tag.setId(id);
        tagService.updateTag(tag);
        return Result.success();
    }
    
    @Operation(summary = "删除标签")
    @DeleteMapping("/{id}")
    public Result<?> deleteTag(@PathVariable Long id) {
        tagService.deleteTag(id);
        return Result.success();
    }
} 