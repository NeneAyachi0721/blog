package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.springboot.common.Result;
import org.example.springboot.entity.BlogConfig;
import org.example.springboot.service.BlogConfigService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

@Tag(name = "博客设置接口")
@RestController
public class BlogConfigController {
    
    @Resource
    private BlogConfigService blogConfigService;
    
    @Operation(summary = "获取所有博客配置")
    @GetMapping("/config")
    public Result<?> getAllConfigs() {
        Map<String, String> configMap = blogConfigService.getAllConfigs();
        return Result.success(configMap);
    }
    
    @Operation(summary = "根据配置键获取配置值")
    @GetMapping("/config/{key}")
    public Result<?> getConfigByKey(@PathVariable String key) {
        String value = blogConfigService.getConfigByKey(key);
        return Result.success(value);
    }
    
    @Operation(summary = "管理员更新博客配置")
    @PutMapping("/admin/config")
    public Result<?> updateConfig(@RequestBody Map<String, String> configMap) {

        boolean result = blogConfigService.updateBatchConfig(configMap);
        return result ? Result.success() : Result.error("更新配置失败");
    }
    
    @Operation(summary = "管理员新增博客配置")
    @PostMapping("/admin/config")
    public Result<?> addConfig(@RequestParam String key, @RequestParam String value) {

        
        boolean result = blogConfigService.addConfig(key, value);
        return result ? Result.success() : Result.error("新增配置失败");
    }
    
    @Operation(summary = "管理员删除博客配置")
    @DeleteMapping("/admin/config/{key}")
    public Result<?> deleteConfig(@PathVariable String key) {

        
        boolean result = blogConfigService.deleteConfig(key);
        return result ? Result.success() : Result.error("删除配置失败");
    }
} 