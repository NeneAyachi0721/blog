package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import org.example.springboot.entity.Article;
import org.example.springboot.entity.User;
import org.example.springboot.entity.UserCollect;
import org.example.springboot.exception.ServiceException;
import org.example.springboot.mapper.ArticleMapper;
import org.example.springboot.mapper.UserCollectMapper;
import org.example.springboot.mapper.UserMapper;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class UserCollectService {
    @Resource
    private UserCollectMapper userCollectMapper;
    
    @Resource
    private ArticleMapper articleMapper;
    
    @Resource
    private UserMapper userMapper;
    
    /**
     * 收藏或取消收藏文章
     * @param articleId 文章ID
     * @return 收藏状态 true-已收藏 false-未收藏
     */
    @Transactional
    public boolean toggleCollect(Long articleId) {
        // 获取当前登录用户
        Long userId = JwtTokenUtils.getCurrentUser().getId();
        
        // 检查文章是否存在
        Article article = articleMapper.selectById(articleId);
        if (article == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 查询用户是否已收藏
        LambdaQueryWrapper<UserCollect> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UserCollect::getUserId, userId)
                    .eq(UserCollect::getArticleId, articleId);
        
        UserCollect userCollect = userCollectMapper.selectOne(queryWrapper);
        
        if (userCollect == null) {
            // 未收藏，添加收藏记录
            userCollect = new UserCollect();
            userCollect.setUserId(userId);
            userCollect.setArticleId(articleId);
            userCollectMapper.insert(userCollect);
            
            return true;
        } else {
            // 已收藏，取消收藏
            userCollectMapper.deleteById(userCollect.getId());
            
            return false;
        }
    }
    
    /**
     * 检查用户是否收藏了文章
     * @param articleId 文章ID
     * @return 是否收藏
     */
    public boolean checkUserCollected(Long articleId) {
        // 获取当前登录用户
        Long userId = JwtTokenUtils.getCurrentUser().getId();
        
        LambdaQueryWrapper<UserCollect> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UserCollect::getUserId, userId)
                   .eq(UserCollect::getArticleId, articleId);
        
        return userCollectMapper.selectCount(queryWrapper) > 0;
    }
    
    /**
     * 获取用户收藏的文章ID列表
     * @param userId 用户ID
     * @return 收藏的文章ID列表
     */
    public Long[] getUserCollectedArticleIds(Long userId) {
        LambdaQueryWrapper<UserCollect> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UserCollect::getUserId, userId)
                   .select(UserCollect::getArticleId);
        
        return userCollectMapper.selectList(queryWrapper)
                           .stream()
                           .map(UserCollect::getArticleId)
                           .toArray(Long[]::new);
    }
    
    /**
     * 获取用户收藏的文章分页列表
     * @param currentPage 当前页
     * @param size 每页大小
     * @return 收藏文章分页数据
     */
    public Page<Map<String, Object>> getUserCollectedArticlePage(Integer currentPage, Integer size) {
        // 获取当前登录用户
        Long userId = JwtTokenUtils.getCurrentUser().getId();
        
        // 查询用户收藏记录
        Page<UserCollect> collectPage = new Page<>(currentPage, size);
        LambdaQueryWrapper<UserCollect> collectQueryWrapper = new LambdaQueryWrapper<>();
        collectQueryWrapper.eq(UserCollect::getUserId, userId)
                          .orderByDesc(UserCollect::getCreateTime);
        
        userCollectMapper.selectPage(collectPage, collectQueryWrapper);
        List<UserCollect> collectList = collectPage.getRecords();
        
        if (collectList.isEmpty()) {
            return new Page<Map<String, Object>>().setRecords(new ArrayList<>())
                                                .setCurrent(currentPage)
                                                .setSize(size)
                                                .setTotal(0);
        }
        
        // 提取文章ID列表
        List<Long> articleIds = collectList.stream()
                                        .map(UserCollect::getArticleId)
                                        .collect(Collectors.toList());
        
        // 查询文章信息
        LambdaQueryWrapper<Article> articleQueryWrapper = new LambdaQueryWrapper<>();
        articleQueryWrapper.in(Article::getId, articleIds)
                          .select(Article::getId, Article::getTitle, Article::getUserId, 
                                 Article::getCoverImage, Article::getSummary, Article::getCreateTime, 
                                 Article::getViewCount, Article::getLikeCount, Article::getCommentCount);
        List<Article> articles = articleMapper.selectList(articleQueryWrapper);
        
        // 查询作者信息
        List<Long> authorIds = articles.stream()
                                     .map(Article::getUserId)
                                     .distinct()
                                     .collect(Collectors.toList());
        
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        userQueryWrapper.in(User::getId, authorIds)
                        .select(User::getId, User::getName, User::getUsername);
        List<User> authors = userMapper.selectList(userQueryWrapper);
        
        // 构建作者ID到名称的映射
        Map<Long, String> authorNameMap = authors.stream()
                                              .collect(Collectors.toMap(
                                                  User::getId,
                                                  user -> user.getName() != null ? user.getName() : user.getUsername()
                                              ));
        
        // 构建文章ID到文章的映射
        Map<Long, Article> articleMap = articles.stream()
                                             .collect(Collectors.toMap(Article::getId, article -> article));
        
        // 构建收藏ID到收藏时间的映射
        Map<Long, UserCollect> collectMap = collectList.stream()
                                                  .collect(Collectors.toMap(UserCollect::getArticleId, collect -> collect));
        
        // 组装结果
        List<Map<String, Object>> records = new ArrayList<>();
        for (Long articleId : articleIds) {
            Article article = articleMap.get(articleId);
            if (article != null) {
                Map<String, Object> record = new HashMap<>();
                record.put("id", article.getId());
                record.put("title", article.getTitle());
                record.put("authorName", authorNameMap.getOrDefault(article.getUserId(), "未知作者"));
                record.put("coverImage", article.getCoverImage());
                record.put("summary", article.getSummary());
                record.put("createTime", article.getCreateTime());
                record.put("viewCount", article.getViewCount());
                record.put("likeCount", article.getLikeCount());
                record.put("commentCount", article.getCommentCount());
                record.put("collectTime", collectMap.get(articleId).getCreateTime());
                records.add(record);
            }
        }
        
        // 创建返回分页对象
        Page<Map<String, Object>> resultPage = new Page<>();
        resultPage.setRecords(records);
        resultPage.setCurrent(collectPage.getCurrent());
        resultPage.setSize(collectPage.getSize());
        resultPage.setTotal(collectPage.getTotal());
        
        return resultPage;
    }
} 