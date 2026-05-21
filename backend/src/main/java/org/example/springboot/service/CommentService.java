package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import org.example.springboot.entity.Article;
import org.example.springboot.entity.Comment;
import org.example.springboot.entity.User;
import org.example.springboot.exception.ServiceException;
import org.example.springboot.mapper.ArticleMapper;
import org.example.springboot.mapper.CommentMapper;
import org.example.springboot.mapper.UserMapper;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommentService {
    @Resource
    private CommentMapper commentMapper;
    
    @Resource
    private UserMapper userMapper;
    
    @Resource
    private ArticleMapper articleMapper;
    
    @Resource
    private JdbcTemplate jdbcTemplate;
    
    /**
     * 添加评论
     * @param comment 评论对象
     * @return 评论ID
     */
    @Transactional
    public Long addComment(Comment comment) {
        // 获取当前登录用户
        User currentUser = JwtTokenUtils.getCurrentUser();
        
        // 检查文章是否存在
        Article article = articleMapper.selectById(comment.getArticleId());
        if (article == null) {
            throw new ServiceException("文章不存在");
        }
        
        // 设置评论用户ID
        comment.setUserId(currentUser.getId());
        
        // 初始状态为待审核，如果不需要审核可设置为1
        comment.setStatus(0);
        
        // 如果是回复评论，检查父评论是否存在
        if (comment.getParentId() != null && comment.getParentId() > 0) {
            Comment parentComment = commentMapper.selectById(comment.getParentId());
            if (parentComment == null) {
                throw new ServiceException("父评论不存在");
            }
        } else {
            // 顶级评论，父评论ID为0
            comment.setParentId(0L);
        }
        
        // 如果没有指定回复用户，默认为0
        if (comment.getToUserId() == null) {
            comment.setToUserId(0L);
        }
        
        // 插入评论
        commentMapper.insert(comment);
        
        // 更新文章评论数
        article.setCommentCount(article.getCommentCount() + 1);
        articleMapper.updateById(article);
        
        return comment.getId();
    }
    
    /**
     * 获取文章评论列表（分页）
     * @param articleId 文章ID
     * @param currentPage 当前页
     * @param size 每页大小
     * @return 评论分页数据
     */
    public Page<Map<String, Object>> getCommentsByArticle(Long articleId, Integer currentPage, Integer size) {
        // 分页查询顶级评论
        Page<Comment> commentPage = new Page<>(currentPage, size);
        LambdaQueryWrapper<Comment> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Comment::getArticleId, articleId)
                    .eq(Comment::getParentId, 0) // 只查顶级评论
                    .eq(Comment::getStatus, 1) // 只显示已通过的评论
                    .orderByDesc(Comment::getCreateTime);
        
        commentMapper.selectPage(commentPage, queryWrapper);
        List<Comment> comments = commentPage.getRecords();
        
        if (comments.isEmpty()) {
            return new Page<Map<String, Object>>().setCurrent(currentPage)
                                                .setSize(size)
                                                .setTotal(0)
                                                .setRecords(new ArrayList<>());
        }
        
        // 获取评论的用户ID
        List<Long> userIds = comments.stream()
                                    .map(Comment::getUserId)
                                    .distinct()
                                    .collect(Collectors.toList());
        
        // 查询用户信息
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        userQueryWrapper.in(User::getId, userIds)
                        .select(User::getId, User::getUsername, User::getName, User::getAvatar);
        List<User> users = userMapper.selectList(userQueryWrapper);
        Map<Long, User> userMap = users.stream()
                                     .collect(Collectors.toMap(User::getId, user -> user));
        
        // 查询每个顶级评论的回复
        List<Map<String, Object>> result = new ArrayList<>();
        for (Comment comment : comments) {
            Map<String, Object> commentMap = new HashMap<>();
            commentMap.put("id", comment.getId());
            commentMap.put("content", comment.getContent());
            commentMap.put("createTime", comment.getCreateTime());
            
            // 设置评论用户信息
            User commentUser = userMap.get(comment.getUserId());
            if (commentUser != null) {
                commentMap.put("userId", commentUser.getId());
                commentMap.put("username", commentUser.getUsername());
                commentMap.put("name", commentUser.getName());
                commentMap.put("avatar", commentUser.getAvatar());
            }
            
            // 查询回复
            List<Map<String, Object>> replies = getCommentReplies(comment.getId());
            commentMap.put("replies", replies);
            
            result.add(commentMap);
        }
        
        // 创建返回分页对象
        Page<Map<String, Object>> resultPage = new Page<>();
        resultPage.setRecords(result);
        resultPage.setCurrent(commentPage.getCurrent());
        resultPage.setSize(commentPage.getSize());
        resultPage.setTotal(commentPage.getTotal());
        
        return resultPage;
    }
    
    /**
     * 获取评论的回复列表
     * @param parentId 父评论ID
     * @return 回复列表
     */
    private List<Map<String, Object>> getCommentReplies(Long parentId) {
        // 查询回复
        LambdaQueryWrapper<Comment> replyWrapper = new LambdaQueryWrapper<>();
        replyWrapper.eq(Comment::getParentId, parentId)
                   .eq(Comment::getStatus, 1) // 只显示已通过的评论
                   .orderByAsc(Comment::getCreateTime);
        List<Comment> replies = commentMapper.selectList(replyWrapper);
        
        if (replies.isEmpty()) {
            return new ArrayList<>();
        }
        
        // 获取回复涉及的用户ID（评论者和被回复者）
        List<Long> userIds = new ArrayList<>();
        for (Comment reply : replies) {
            userIds.add(reply.getUserId());
            if (reply.getToUserId() > 0) {
                userIds.add(reply.getToUserId());
            }
        }
        userIds = userIds.stream().distinct().collect(Collectors.toList());
        
        // 查询用户信息
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        userQueryWrapper.in(User::getId, userIds)
                        .select(User::getId, User::getUsername, User::getName, User::getAvatar);
        List<User> users = userMapper.selectList(userQueryWrapper);
        Map<Long, User> userMap = users.stream()
                                     .collect(Collectors.toMap(User::getId, user -> user));
        
        // 组装回复结果
        List<Map<String, Object>> result = new ArrayList<>();
        for (Comment reply : replies) {
            Map<String, Object> replyMap = new HashMap<>();
            replyMap.put("id", reply.getId());
            replyMap.put("content", reply.getContent());
            replyMap.put("createTime", reply.getCreateTime());
            
            // 设置评论用户信息
            User replyUser = userMap.get(reply.getUserId());
            if (replyUser != null) {
                replyMap.put("userId", replyUser.getId());
                replyMap.put("username", replyUser.getUsername());
                replyMap.put("name", replyUser.getName());
                replyMap.put("avatar", replyUser.getAvatar());
            }
            
            // 设置被回复用户信息
            if (reply.getToUserId() > 0) {
                User toUser = userMap.get(reply.getToUserId());
                if (toUser != null) {
                    replyMap.put("toUserId", toUser.getId());
                    replyMap.put("toUsername", toUser.getUsername());
                    replyMap.put("toName", toUser.getName());
                }
            }
            
            result.add(replyMap);
        }
        
        return result;
    }
    
    /**
     * 获取用户评论列表（分页）
     * @param userId 用户ID
     * @param currentPage 当前页
     * @param size 每页大小
     * @return 评论分页数据
     */
    public Page<Map<String, Object>> getUserComments(Long userId, Integer currentPage, Integer size) {
        Page<Comment> commentPage = new Page<>(currentPage, size);
        LambdaQueryWrapper<Comment> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Comment::getUserId, userId)
                    .orderByDesc(Comment::getCreateTime);
        
        commentMapper.selectPage(commentPage, queryWrapper);
        List<Comment> comments = commentPage.getRecords();
        
        if (comments.isEmpty()) {
            return new Page<Map<String, Object>>().setCurrent(currentPage)
                                                .setSize(size)
                                                .setTotal(0)
                                                .setRecords(new ArrayList<>());
        }
        
        // 获取评论涉及的文章ID
        List<Long> articleIds = comments.stream()
                                      .map(Comment::getArticleId)
                                      .distinct()
                                      .collect(Collectors.toList());
        
        // 查询文章信息
        LambdaQueryWrapper<Article> articleQueryWrapper = new LambdaQueryWrapper<>();
        articleQueryWrapper.in(Article::getId, articleIds)
                          .select(Article::getId, Article::getTitle);
        List<Article> articles = articleMapper.selectList(articleQueryWrapper);
        Map<Long, String> articleTitleMap = articles.stream()
                                                 .collect(Collectors.toMap(Article::getId, Article::getTitle));
        
        // 组装结果
        List<Map<String, Object>> result = new ArrayList<>();
        for (Comment comment : comments) {
            Map<String, Object> commentMap = new HashMap<>();
            commentMap.put("id", comment.getId());
            commentMap.put("content", comment.getContent());
            commentMap.put("createTime", comment.getCreateTime());
            commentMap.put("status", comment.getStatus());
            commentMap.put("articleId", comment.getArticleId());
            commentMap.put("articleTitle", articleTitleMap.getOrDefault(comment.getArticleId(), "未知文章"));
            commentMap.put("isReply", comment.getParentId() > 0);
            
            result.add(commentMap);
        }
        
        // 创建返回分页对象
        Page<Map<String, Object>> resultPage = new Page<>();
        resultPage.setRecords(result);
        resultPage.setCurrent(commentPage.getCurrent());
        resultPage.setSize(commentPage.getSize());
        resultPage.setTotal(commentPage.getTotal());
        
        return resultPage;
    }
    
    /**
     * 删除评论
     * @param commentId 评论ID
     */
    @Transactional
    public void deleteComment(Long commentId) {
        Comment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new ServiceException("评论不存在");
        }
        
        // 判断是否有权限删除（管理员或评论作者）
        User currentUser = JwtTokenUtils.getCurrentUser();
        if (!currentUser.getRoleCode().equals("ADMIN") && !comment.getUserId().equals(currentUser.getId())) {
            throw new ServiceException("没有权限删除该评论");
        }
        
        // 删除评论
        commentMapper.deleteById(commentId);
        
        // 如果是顶级评论，删除其所有回复
        if (comment.getParentId() == 0) {
            LambdaQueryWrapper<Comment> replyWrapper = new LambdaQueryWrapper<>();
            replyWrapper.eq(Comment::getParentId, commentId);
            commentMapper.delete(replyWrapper);
        }
        
        // 更新文章评论数
        Article article = articleMapper.selectById(comment.getArticleId());
        if (article != null && article.getCommentCount() > 0) {
            article.setCommentCount(article.getCommentCount() - 1);
            articleMapper.updateById(article);
        }
    }
    
    /**
     * 审核评论
     * @param commentId 评论ID
     * @param status 状态 1-通过 2-拒绝
     */
    @Transactional
    public void auditComment(Long commentId, Integer status) {
        // 检查权限，只有管理员可以审核
        User currentUser = JwtTokenUtils.getCurrentUser();
        if (!currentUser.getRoleCode().equals("ADMIN")) {
            throw new ServiceException("没有权限审核评论");
        }
        
        Comment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new ServiceException("评论不存在");
        }
        
        comment.setStatus(status);
        commentMapper.updateById(comment);
    }
    
    /**
     * 管理员获取评论分页列表
     * @param articleTitle 文章标题(可选)
     * @param status 评论状态(可选)
     * @param currentPage 当前页
     * @param size 每页大小
     * @return 评论分页数据
     */
    public Page<Map<String, Object>> getAdminCommentPage(String articleTitle, Integer status, Integer currentPage, Integer size) {
        // 先查询符合条件的文章ID
        List<Long> articleIds = null;
        if (articleTitle != null && !articleTitle.trim().isEmpty()) {
            LambdaQueryWrapper<Article> articleQueryWrapper = new LambdaQueryWrapper<>();
            articleQueryWrapper.like(Article::getTitle, articleTitle.trim())
                              .select(Article::getId);
            List<Article> articles = articleMapper.selectList(articleQueryWrapper);
            if (articles.isEmpty()) {
                // 没有符合条件的文章，直接返回空结果
                return new Page<Map<String, Object>>().setCurrent(currentPage)
                                                    .setSize(size)
                                                    .setTotal(0)
                                                    .setRecords(new ArrayList<>());
            }
            articleIds = articles.stream().map(Article::getId).collect(Collectors.toList());
        }
        
        // 查询评论
        Page<Comment> commentPage = new Page<>(currentPage, size);
        LambdaQueryWrapper<Comment> queryWrapper = new LambdaQueryWrapper<>();
        
        // 添加筛选条件
        if (articleIds != null) {
            queryWrapper.in(Comment::getArticleId, articleIds);
        }
        if (status != null) {
            queryWrapper.eq(Comment::getStatus, status);
        }
        
        // 按创建时间倒序排序
        queryWrapper.orderByDesc(Comment::getCreateTime);
        
        commentMapper.selectPage(commentPage, queryWrapper);
        List<Comment> comments = commentPage.getRecords();
        
        if (comments.isEmpty()) {
            return new Page<Map<String, Object>>().setCurrent(currentPage)
                                                .setSize(size)
                                                .setTotal(0)
                                                .setRecords(new ArrayList<>());
        }
        
        // 获取评论的用户ID和文章ID
        List<Long> userIds = comments.stream()
                                    .map(Comment::getUserId)
                                    .distinct()
                                    .collect(Collectors.toList());
        
        List<Long> allArticleIds = comments.stream()
                                         .map(Comment::getArticleId)
                                         .distinct()
                                         .collect(Collectors.toList());
        
        // 查询用户信息
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        userQueryWrapper.in(User::getId, userIds)
                        .select(User::getId, User::getUsername, User::getName, User::getAvatar);
        List<User> users = userMapper.selectList(userQueryWrapper);
        Map<Long, User> userMap = users.stream()
                                     .collect(Collectors.toMap(User::getId, user -> user));
        
        // 查询文章信息
        LambdaQueryWrapper<Article> articleQueryWrapper = new LambdaQueryWrapper<>();
        articleQueryWrapper.in(Article::getId, allArticleIds)
                          .select(Article::getId, Article::getTitle);
        List<Article> articles = articleMapper.selectList(articleQueryWrapper);
        Map<Long, String> articleTitleMap = articles.stream()
                                                 .collect(Collectors.toMap(Article::getId, Article::getTitle));
        
        // 组装结果
        List<Map<String, Object>> result = new ArrayList<>();
        for (Comment comment : comments) {
            Map<String, Object> commentMap = new HashMap<>();
            commentMap.put("id", comment.getId());
            commentMap.put("content", comment.getContent());
            commentMap.put("createTime", comment.getCreateTime());
            commentMap.put("status", comment.getStatus());
            commentMap.put("articleId", comment.getArticleId());
            commentMap.put("articleTitle", articleTitleMap.getOrDefault(comment.getArticleId(), "未知文章"));
            commentMap.put("isReply", comment.getParentId() > 0);
            
            // 设置评论用户信息
            User commentUser = userMap.get(comment.getUserId());
            if (commentUser != null) {
                commentMap.put("userId", commentUser.getId());
                commentMap.put("username", commentUser.getUsername());
                commentMap.put("userName", commentUser.getName());
                commentMap.put("userAvatar", commentUser.getAvatar());
            }
            
            // 如果是回复评论，获取父评论信息
            if (comment.getParentId() > 0) {
                Comment parentComment = commentMapper.selectById(comment.getParentId());
                if (parentComment != null) {
                    commentMap.put("parentContent", parentComment.getContent());
                }
                
                // 如果有回复对象，获取回复对象信息
                if (comment.getToUserId() > 0) {
                    User toUser = userMap.get(comment.getToUserId());
                    if (toUser != null) {
                        commentMap.put("toUserId", toUser.getId());
                        commentMap.put("toUserName", toUser.getName() != null ? toUser.getName() : toUser.getUsername());
                    }
                }
            }
            
            result.add(commentMap);
        }
        
        // 创建返回分页对象
        Page<Map<String, Object>> resultPage = new Page<>();
        resultPage.setRecords(result);
        resultPage.setCurrent(commentPage.getCurrent());
        resultPage.setSize(commentPage.getSize());
        resultPage.setTotal(commentPage.getTotal());
        
        return resultPage;
    }
    
    /**
     * 获取最近评论
     * @param size 获取数量
     * @return 评论列表
     */
    public List<Map<String, Object>> getRecentComments(Integer size) {
        // 使用原生SQL查询，获取评论以及关联的文章标题和用户信息
        String sql = "SELECT c.*, a.title as article_title, u.username, u.name as user_name, u.avatar as user_avatar " +
                     "FROM comment c " +
                     "LEFT JOIN article a ON c.article_id = a.id " +
                     "LEFT JOIN user u ON c.user_id = u.id " +
                     "WHERE c.status = 1 " + // 已通过的评论
                     "ORDER BY c.create_time DESC " +
                     "LIMIT " + size;
        
        return jdbcTemplate.queryForList(sql);
    }
} 