package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import org.example.springboot.entity.ArticleTag;
import org.example.springboot.entity.Tag;
import org.example.springboot.exception.ServiceException;
import org.example.springboot.mapper.ArticleTagMapper;
import org.example.springboot.mapper.TagMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TagService {
    @Resource
    private TagMapper tagMapper;
    
    @Resource
    private ArticleTagMapper articleTagMapper;
    
    /**
     * 获取所有标签
     */
    public List<Tag> getAllTags() {
        List<Tag> tags = tagMapper.selectList(null);
        
        // 设置每个标签的文章数量
        for (Tag tag : tags) {
            setArticleCount(tag);
        }
        
        return tags;
    }
    
    /**
     * 根据ID获取标签
     */
    public Tag getTagById(Long id) {
        Tag tag = tagMapper.selectById(id);
        if (tag == null) {
            throw new ServiceException("标签不存在");
        }
        
        // 设置文章数量
        setArticleCount(tag);
        
        return tag;
    }
    
    /**
     * 新增标签
     */
    public void addTag(Tag tag) {
        // 检查标签名称是否已存在
        LambdaQueryWrapper<Tag> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Tag::getName, tag.getName());
        if (tagMapper.selectCount(queryWrapper) > 0) {
            throw new ServiceException("标签名称已存在");
        }
        
        // 如果没有设置颜色，则设置默认颜色
        if (tag.getColor() == null || tag.getColor().isEmpty()) {
            tag.setColor("#409EFF");
        }
        
        tagMapper.insert(tag);
    }
    
    /**
     * 更新标签
     */
    public void updateTag(Tag tag) {
        // 验证标签是否存在
        Tag existTag = tagMapper.selectById(tag.getId());
        if (existTag == null) {
            throw new ServiceException("标签不存在");
        }
        
        // 检查标签名称是否已存在
        LambdaQueryWrapper<Tag> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Tag::getName, tag.getName())
                .ne(Tag::getId, tag.getId());
        if (tagMapper.selectCount(queryWrapper) > 0) {
            throw new ServiceException("标签名称已存在");
        }
        
        tagMapper.updateById(tag);
    }
    
    /**
     * 删除标签
     */
    public void deleteTag(Long id) {
        // 验证标签是否存在
        Tag existTag = tagMapper.selectById(id);
        if (existTag == null) {
            throw new ServiceException("标签不存在");
        }
        
        // 检查是否有文章使用此标签
        LambdaQueryWrapper<ArticleTag> articleTagWrapper = new LambdaQueryWrapper<>();
        articleTagWrapper.eq(ArticleTag::getTagId, id);
        if (articleTagMapper.selectCount(articleTagWrapper) > 0) {
            throw new ServiceException("此标签被文章使用，无法删除");
        }
        
        tagMapper.deleteById(id);
    }
    
    /**
     * 设置标签的文章数量
     */
    private void setArticleCount(Tag tag) {
        LambdaQueryWrapper<ArticleTag> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ArticleTag::getTagId, tag.getId());
        
        Integer count = Math.toIntExact(articleTagMapper.selectCount(queryWrapper));
        tag.setArticleCount(count);
    }
} 