package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.lang3.StringUtils;
import org.example.springboot.entity.BlogConfig;
import org.example.springboot.mapper.BlogConfigMapper;
import org.example.springboot.exception.ServiceException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class BlogConfigService {
    
    @Resource
    private BlogConfigMapper blogConfigMapper;
    
    /**
     * 获取所有博客配置
     */
    public Map<String, String> getAllConfigs() {
        List<BlogConfig> configList = blogConfigMapper.selectList(null);
        Map<String, String> configMap = new HashMap<>();
        
        for (BlogConfig config : configList) {
            configMap.put(config.getConfigKey(), config.getConfigValue());
        }
        
        return configMap;
    }
    
    /**
     * 根据配置键获取配置值
     */
    public String getConfigByKey(String key) {
        if (StringUtils.isBlank(key)) {
            return null;
        }
        
        LambdaQueryWrapper<BlogConfig> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(BlogConfig::getConfigKey, key);
        
        BlogConfig config = blogConfigMapper.selectOne(queryWrapper);
        return config != null ? config.getConfigValue() : null;
    }
    
    /**
     * 批量更新配置
     */
    @Transactional(rollbackFor = Exception.class)
    public boolean updateBatchConfig(Map<String, String> configMap) {
        if (configMap == null || configMap.isEmpty()) {
            return false;
        }
        
        for (Map.Entry<String, String> entry : configMap.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            
            // 查询是否存在该配置
            LambdaQueryWrapper<BlogConfig> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(BlogConfig::getConfigKey, key);
            BlogConfig config = blogConfigMapper.selectOne(queryWrapper);
            
            if (config != null) {
                // 更新配置
                config.setConfigValue(value);
                blogConfigMapper.updateById(config);
            } else {
                // 新增配置
                config = new BlogConfig();
                config.setConfigKey(key);
                config.setConfigValue(value);
                blogConfigMapper.insert(config);
            }
        }
        
        return true;
    }
    
    /**
     * 新增配置
     */
    public boolean addConfig(String key, String value) {
        if (StringUtils.isBlank(key)) {
            throw new ServiceException("配置键不能为空");
        }
        
        // 检查是否已存在该配置
        LambdaQueryWrapper<BlogConfig> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(BlogConfig::getConfigKey, key);
        
        BlogConfig existConfig = blogConfigMapper.selectOne(queryWrapper);
        if (existConfig != null) {
            throw new ServiceException("配置键已存在");
        }
        
        BlogConfig config = new BlogConfig();
        config.setConfigKey(key);
        config.setConfigValue(value);
        
        return blogConfigMapper.insert(config) > 0;
    }
    
    /**
     * 删除配置
     */
    public boolean deleteConfig(String key) {
        if (StringUtils.isBlank(key)) {
            return false;
        }
        
        LambdaQueryWrapper<BlogConfig> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(BlogConfig::getConfigKey, key);
        
        return blogConfigMapper.delete(queryWrapper) > 0;
    }
} 