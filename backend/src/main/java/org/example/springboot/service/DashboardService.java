package org.example.springboot.service;

import jakarta.annotation.Resource;
import org.example.springboot.mapper.ArticleMapper;
import org.example.springboot.mapper.CommentMapper;
import org.example.springboot.mapper.UserMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardService {

    @Resource
    private ArticleMapper articleMapper;

    @Resource
    private CommentMapper commentMapper;

    @Resource
    private UserMapper userMapper;
    
    @Resource
    private JdbcTemplate jdbcTemplate;

    /**
     * 获取仪表盘统计数据
     * @return 统计数据Map
     */
    public Map<String, Object> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取文章总数
        Long articleCount = articleMapper.selectCount(null);
        stats.put("articleCount", articleCount);
        
        // 获取评论总数
        Long commentCount = commentMapper.selectCount(null);
        stats.put("commentCount", commentCount);
        
        // 获取用户总数
        Long userCount = userMapper.selectCount(null);
        stats.put("userCount", userCount);
        
        // 获取总访问量（所有文章的访问量总和）
        Long viewCount = articleMapper.getTotalViewCount();
        stats.put("viewCount", viewCount);
        
        return stats;
    }
    
    /**
     * 获取文章发布趋势数据
     * @param days 天数
     * @return 趋势数据列表
     */
    public List<Map<String, Object>> getArticleTrend(Integer days) {
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        // 生成日期范围
        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            String dateStr = date.format(formatter);
            String nextDateStr = date.plusDays(1).format(formatter);
            
            // 查询该日期发布的文章数量
            String sql = "SELECT COUNT(*) FROM article WHERE create_time >= ? AND create_time < ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, dateStr, nextDateStr);
            
            Map<String, Object> item = new HashMap<>();
            item.put("date", dateStr);
            item.put("count", count != null ? count : 0);
            
            result.add(item);
        }
        
        return result;
    }
    
    /**
     * 获取访问量趋势数据
     * @param days 天数
     * @return 趋势数据列表
     */
    public List<Map<String, Object>> getViewTrend(Integer days) {
        // 由于我们没有按日期记录访问量，这里使用模拟数据
        // 实际项目中应该有访问日志表记录每日访问量
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        // 获取总访问量
        Long totalViews = articleMapper.getTotalViewCount();
        
        // 生成模拟数据，按日期递增
        int baseCount = totalViews.intValue() / (days * 2); // 基础访问量
        
        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            String dateStr = date.format(formatter);
            
            // 生成该日期的模拟访问量（随机波动）
            int dayIndex = date.getDayOfWeek().getValue(); // 1-7
            int variance = (int) (baseCount * 0.3 * dayIndex); // 日访问量波动
            int count = baseCount + variance;
            
            Map<String, Object> item = new HashMap<>();
            item.put("date", dateStr);
            item.put("count", count);
            
            result.add(item);
        }
        
        return result;
    }
} 