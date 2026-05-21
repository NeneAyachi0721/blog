package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.example.springboot.entity.Article;
import org.example.springboot.entity.ArticleTag;
import org.example.springboot.entity.Category;
import org.example.springboot.entity.Tag;
import org.example.springboot.entity.User;
import org.example.springboot.exception.ServiceException;
import org.example.springboot.mapper.ArticleMapper;
import org.example.springboot.mapper.ArticleTagMapper;
import org.example.springboot.mapper.CategoryMapper;
import org.example.springboot.mapper.TagMapper;
import org.example.springboot.mapper.UserMapper;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class ArticleService {
    @Resource
    private ArticleMapper articleMapper;
    
    @Resource
    private CategoryMapper categoryMapper;
    
    @Resource
    private UserMapper userMapper;
    
    @Resource
    private TagMapper tagMapper;
    
    @Resource
    private ArticleTagMapper articleTagMapper;
    
    @Resource
    private org.example.springboot.mapper.UserLikeMapper userLikeMapper;
    
    @Resource
    private org.example.springboot.mapper.UserCollectMapper userCollectMapper;

    /**
     * 分页查询文章
     */
    public Page<Article> getArticlesByPage(String title, Long categoryId, Integer status, Integer currentPage, Integer size) {
        Page<Article> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        
        // 添加查询条件
        if (StringUtils.isNotBlank(title)) {
            queryWrapper.like(Article::getTitle, title);
        }
        if (categoryId != null) {
            queryWrapper.eq(Article::getCategoryId, categoryId);
        }
        if (status != null) {
            queryWrapper.eq(Article::getStatus, status);
        }
        
        // 按创建时间降序排序
        queryWrapper.orderByDesc(Article::getCreateTime);
        
        Page<Article> articlePage = articleMapper.selectPage(page, queryWrapper);
        
        // 设置文章的分类名称和作者名称
        for (Article article : articlePage.getRecords()) {
            setCategoryAndAuthor(article);
            // 设置文章的标签
            setArticleTags(article);
        }
        
        return articlePage;
    }
    
    /**
     * 获取推荐文章
     */
    public List<Article> getRecommendArticles(int limit) {
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Article::getStatus, 1) // 已发布的文章
                .eq(Article::getIsRecommend, 1) // 推荐的文章
                .orderByDesc(Article::getCreateTime)
                .last("LIMIT " + limit);
        
        List<Article> articles = articleMapper.selectList(queryWrapper);
        
        for (Article article : articles) {
            setCategoryAndAuthor(article);
        }
        
        return articles;
    }
    
    /**
     * 获取热门文章
     */
    public List<Article> getHotArticles(int limit) {
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Article::getStatus, 1) // 已发布的文章
                .orderByDesc(Article::getViewCount)
                .last("LIMIT " + limit);
        
        List<Article> articles = articleMapper.selectList(queryWrapper);
        
        for (Article article : articles) {
            setCategoryAndAuthor(article);
        }
        
        return articles;
    }
    
    /**
     * 根据ID获取文章详情
     */
    public Article getArticleById(Long id) {
        Article article = articleMapper.selectById(id);
        if (article == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 设置文章的分类名称和作者名称
        setCategoryAndAuthor(article);
        // 设置文章的标签
        setArticleTags(article);
        
        return article;
    }
    
    /**
     * 更新文章浏览量
     */
    public void updateArticleViewCount(Long id) {
        Article article = articleMapper.selectById(id);
        if (article != null) {
            article.setViewCount(article.getViewCount() + 1);
            articleMapper.updateById(article);
        }
    }
    
    /**
     * 新增文章
     */
    @Transactional
    public void addArticle(Article article) {
        // 获取当前登录用户
        User currentUser = JwtTokenUtils.getCurrentUser();
        article.setUserId(currentUser.getId());
        
        // 默认值设置
        if (article.getViewCount() == null) {
            article.setViewCount(0);
        }
        if (article.getLikeCount() == null) {
            article.setLikeCount(0);
        }
        if (article.getCommentCount() == null) {
            article.setCommentCount(0);
        }
        if (article.getIsTop() == null) {
            article.setIsTop(0);
        }
        if (article.getIsRecommend() == null) {
            article.setIsRecommend(0);
        }
        
        // 保存文章
        articleMapper.insert(article);
        
        // 保存文章标签关联
        saveArticleTags(article);
    }
    
    /**
     * 更新文章
     */
    @Transactional
    public void updateArticle(Article article) {
        // 验证文章是否存在
        Article existArticle = articleMapper.selectById(article.getId());
        if (existArticle == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 验证当前用户是否有权限修改
        User currentUser = JwtTokenUtils.getCurrentUser();
        if (!Objects.equals(existArticle.getUserId(), currentUser.getId()) && 
            !"ADMIN".equals(currentUser.getRoleCode())) {
            throw new ServiceException("无权限修改此文章");
        }
        
        // 更新文章
        articleMapper.updateById(article);
        
        // 更新文章标签关联
        // 先删除原有关联
        LambdaQueryWrapper<ArticleTag> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ArticleTag::getArticleId, article.getId());
        articleTagMapper.delete(wrapper);
        
        // 重新保存关联
        saveArticleTags(article);
    }
    
    /**
     * 删除文章
     */
    @Transactional
    public void deleteArticle(Long id) {
        // 验证文章是否存在
        Article existArticle = articleMapper.selectById(id);
        if (existArticle == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 验证当前用户是否有权限删除
        User currentUser = JwtTokenUtils.getCurrentUser();
        if (!Objects.equals(existArticle.getUserId(), currentUser.getId()) && 
            !"ADMIN".equals(currentUser.getRoleCode())) {
            throw new ServiceException("无权限删除此文章");
        }
        
        // 删除文章
        articleMapper.deleteById(id);
        
        // 删除文章标签关联
        LambdaQueryWrapper<ArticleTag> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ArticleTag::getArticleId, id);
        articleTagMapper.delete(wrapper);
    }
    
    /**
     * 修改文章状态
     */
    public void updateArticleStatus(Long id, Integer status) {
        Article article = articleMapper.selectById(id);
        if (article == null) {
            throw new ServiceException("文章不存在");
        }
        
        article.setStatus(status);
        articleMapper.updateById(article);
    }
    
    /**
     * 设置文章的分类名称和作者名称
     */
    private void setCategoryAndAuthor(Article article) {
        if (article.getCategoryId() != null) {
            Category category = categoryMapper.selectById(article.getCategoryId());
            if (category != null) {
                article.setCategoryName(category.getName());
            }
        }
        
        if (article.getUserId() != null) {
            User author = userMapper.selectById(article.getUserId());
            if (author != null) {
                article.setAuthorName(author.getUsername());
            }
        }
    }
    
    /**
     * 设置文章的标签
     */
    private void setArticleTags(Article article) {
        LambdaQueryWrapper<ArticleTag> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ArticleTag::getArticleId, article.getId());
        List<ArticleTag> articleTags = articleTagMapper.selectList(queryWrapper);
        
        if (!articleTags.isEmpty()) {
            List<Long> tagIds = articleTags.stream()
                    .map(ArticleTag::getTagId)
                    .collect(Collectors.toList());
            
            LambdaQueryWrapper<Tag> tagWrapper = new LambdaQueryWrapper<>();
            tagWrapper.in(Tag::getId, tagIds);
            List<Tag> tags = tagMapper.selectList(tagWrapper);
            
            article.setTags(tags);
        } else {
            article.setTags(new ArrayList<>());
        }
    }
    
    /**
     * 保存文章标签关联
     */
    private void saveArticleTags(Article article) {
        if (article.getTags() != null && !article.getTags().isEmpty()) {
            for (Tag tag : article.getTags()) {
                ArticleTag articleTag = new ArticleTag();
                articleTag.setArticleId(article.getId());
                articleTag.setTagId(tag.getId());
                articleTagMapper.insert(articleTag);
            }
        }
    }
    
    /**
     * 根据分类ID获取文章列表
     */
    public Page<Article> getArticlesByCategoryId(Long categoryId, Integer currentPage, Integer size) {
        Page<Article> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        
        queryWrapper.eq(Article::getCategoryId, categoryId)
                .eq(Article::getStatus, 1) // 已发布的文章
                .orderByDesc(Article::getCreateTime);
        
        Page<Article> articlePage = articleMapper.selectPage(page, queryWrapper);
        
        // 设置文章的分类名称和作者名称
        for (Article article : articlePage.getRecords()) {
            setCategoryAndAuthor(article);
            // 设置文章的标签
            setArticleTags(article);
        }
        
        return articlePage;
    }
    
    /**
     * 根据标签ID获取文章列表
     */
    public Page<Article> getArticlesByTagId(Long tagId, Integer currentPage, Integer size) {
        // 先查询所有包含该标签的文章ID
        LambdaQueryWrapper<ArticleTag> articleTagWrapper = new LambdaQueryWrapper<>();
        articleTagWrapper.eq(ArticleTag::getTagId, tagId);
        List<ArticleTag> articleTags = articleTagMapper.selectList(articleTagWrapper);
        
        List<Long> articleIds = articleTags.stream()
                .map(ArticleTag::getArticleId)
                .collect(Collectors.toList());
        
        if (articleIds.isEmpty()) {
            return new Page<>(currentPage, size);
        }
        
        // 根据文章ID查询文章
        Page<Article> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        
        queryWrapper.in(Article::getId, articleIds)
                .eq(Article::getStatus, 1) // 已发布的文章
                .orderByDesc(Article::getCreateTime);
        
        Page<Article> articlePage = articleMapper.selectPage(page, queryWrapper);
        
        // 设置文章的分类名称和作者名称
        for (Article article : articlePage.getRecords()) {
            setCategoryAndAuthor(article);
            // 设置文章的标签
            setArticleTags(article);
        }
        
        return articlePage;
    }
    
    /**
     * 搜索文章
     */
    public Page<Article> searchArticles(String keyword, Integer currentPage, Integer size) {
        Page<Article> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        
        queryWrapper.like(Article::getTitle, keyword)
                .or()
                .like(Article::getContent, keyword)
                .or()
                .like(Article::getSummary, keyword)
                .eq(Article::getStatus, 1) // 已发布的文章
                .orderByDesc(Article::getCreateTime);
        
        Page<Article> articlePage = articleMapper.selectPage(page, queryWrapper);
        
        // 设置文章的分类名称和作者名称
        for (Article article : articlePage.getRecords()) {
            setCategoryAndAuthor(article);
            // 设置文章的标签
            setArticleTags(article);
        }
        
        return articlePage;
    }
    
    /**
     * 获取文章点赞用户列表
     * @param articleId 文章ID
     * @param currentPage 当前页
     * @param size 每页大小
     * @return 用户分页数据
     */
    public Page<Map<String, Object>> getArticleLikeUsers(Long articleId, Integer currentPage, Integer size) {
        // 验证文章是否存在
        Article article = articleMapper.selectById(articleId);
        if (article == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 创建结果页对象
        Page<Map<String, Object>> resultPage = new Page<>(currentPage, size);
        List<Map<String, Object>> records = new ArrayList<>();
        
        // 查询点赞用户ID列表
        LambdaQueryWrapper<org.example.springboot.entity.UserLike> likeQueryWrapper = new LambdaQueryWrapper<>();
        likeQueryWrapper.eq(org.example.springboot.entity.UserLike::getArticleId, articleId);
        Page<org.example.springboot.entity.UserLike> likePage = new Page<>(currentPage, size);
        
        userLikeMapper.selectPage(likePage, likeQueryWrapper);
        
        if (likePage.getRecords().isEmpty()) {
            resultPage.setRecords(records);
            resultPage.setTotal(0);
            return resultPage;
        }
        
        // 获取用户ID列表
        List<Long> userIds = likePage.getRecords().stream()
                                   .map(org.example.springboot.entity.UserLike::getUserId)
                                   .collect(Collectors.toList());
        
        // 查询用户信息
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        userQueryWrapper.in(User::getId, userIds);
        List<User> users = userMapper.selectList(userQueryWrapper);
        
        // 构建用户ID到点赞时间的映射
        Map<Long, LocalDateTime> userLikeTimeMap = likePage.getRecords().stream()
                                                     .collect(Collectors.toMap(
                                                         org.example.springboot.entity.UserLike::getUserId,
                                                         org.example.springboot.entity.UserLike::getCreateTime
                                                     ));
        
        // 组装结果
        for (User user : users) {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("username", user.getUsername());
            userMap.put("name", user.getName());
            userMap.put("avatar", user.getAvatar());
            userMap.put("email", user.getEmail());
            userMap.put("likeTime", userLikeTimeMap.get(user.getId()));
            records.add(userMap);
        }
        
        resultPage.setRecords(records);
        resultPage.setTotal(likePage.getTotal());
        return resultPage;
    }
    
    /**
     * 获取文章收藏用户列表
     * @param articleId 文章ID
     * @param currentPage 当前页
     * @param size 每页大小
     * @return 用户分页数据
     */
    public Page<Map<String, Object>> getArticleCollectUsers(Long articleId, Integer currentPage, Integer size) {
        // 验证文章是否存在
        Article article = articleMapper.selectById(articleId);
        if (article == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 创建结果页对象
        Page<Map<String, Object>> resultPage = new Page<>(currentPage, size);
        List<Map<String, Object>> records = new ArrayList<>();
        
        // 查询收藏用户ID列表
        LambdaQueryWrapper<org.example.springboot.entity.UserCollect> collectQueryWrapper = new LambdaQueryWrapper<>();
        collectQueryWrapper.eq(org.example.springboot.entity.UserCollect::getArticleId, articleId);
        Page<org.example.springboot.entity.UserCollect> collectPage = new Page<>(currentPage, size);
        
        userCollectMapper.selectPage(collectPage, collectQueryWrapper);
        
        if (collectPage.getRecords().isEmpty()) {
            resultPage.setRecords(records);
            resultPage.setTotal(0);
            return resultPage;
        }
        
        // 获取用户ID列表
        List<Long> userIds = collectPage.getRecords().stream()
                                     .map(org.example.springboot.entity.UserCollect::getUserId)
                                     .collect(Collectors.toList());
        
        // 查询用户信息
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        userQueryWrapper.in(User::getId, userIds);
        List<User> users = userMapper.selectList(userQueryWrapper);
        
        // 构建用户ID到收藏时间的映射
        Map<Long, LocalDateTime> userCollectTimeMap = collectPage.getRecords().stream()
                                                         .collect(Collectors.toMap(
                                                             org.example.springboot.entity.UserCollect::getUserId,
                                                             org.example.springboot.entity.UserCollect::getCreateTime
                                                         ));
        
        // 组装结果
        for (User user : users) {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("username", user.getUsername());
            userMap.put("name", user.getName());
            userMap.put("avatar", user.getAvatar());
            userMap.put("email", user.getEmail());
            userMap.put("collectTime", userCollectTimeMap.get(user.getId()));
            records.add(userMap);
        }
        
        resultPage.setRecords(records);
        resultPage.setTotal(collectPage.getTotal());
        return resultPage;
    }

    /**
     * 获取最近发布的文章
     * @param size 获取数量
     * @return 文章列表
     */
    public List<Article> getRecentArticles(Integer size) {
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Article::getStatus, 1) // 已发布的文章
                    .orderByDesc(Article::getCreateTime)
                    .last("LIMIT " + size);
        
        List<Article> articles = articleMapper.selectList(queryWrapper);
        return articles;
    }
} 