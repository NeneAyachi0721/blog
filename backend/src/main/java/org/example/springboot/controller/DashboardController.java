package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.service.DashboardService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Tag(name = "仪表盘接口")
@RestController
@RequestMapping("/dashboard")
public class DashboardController {
    private static final Logger LOGGER = LoggerFactory.getLogger(DashboardController.class);

    @Resource
    private DashboardService dashboardService;

    @Operation(summary = "获取仪表盘统计数据")
    @GetMapping("/stats")
    public Result<?> getStats() {
        LOGGER.info("获取仪表盘统计数据");
        Map<String, Object> stats = dashboardService.getStats();
        return Result.success(stats);
    }
    
    @Operation(summary = "获取文章发布趋势数据")
    @GetMapping("/article/trend")
    public Result<?> getArticleTrend(@RequestParam(defaultValue = "7") Integer days) {
        LOGGER.info("获取文章发布趋势数据, days={}", days);
        List<Map<String, Object>> trend = dashboardService.getArticleTrend(days);
        return Result.success(trend);
    }
    
    @Operation(summary = "获取访问量趋势数据")
    @GetMapping("/view/trend")
    public Result<?> getViewTrend(@RequestParam(defaultValue = "7") Integer days) {
        LOGGER.info("获取访问量趋势数据, days={}", days);
        List<Map<String, Object>> trend = dashboardService.getViewTrend(days);
        return Result.success(trend);
    }
} 