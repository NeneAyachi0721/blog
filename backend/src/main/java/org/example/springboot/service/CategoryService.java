package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import org.example.springboot.entity.Article;
import org.example.springboot.entity.Category;
import org.example.springboot.exception.ServiceException;
import org.example.springboot.mapper.ArticleMapper;
import org.example.springboot.mapper.CategoryMapper;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CategoryService {
    @Resource
    private CategoryMapper categoryMapper;
    
    @Resource
    private ArticleMapper articleMapper;
    
    /**
     * 获取所有分类（树形结构）
     */
    public List<Category> getAllCategories() {
        List<Category> allCategories = categoryMapper.selectList(null);
        
        // 设置每个分类的文章数量
        for (Category category : allCategories) {
            setArticleCount(category);
        }
        
        // 构建树形结构
        return buildCategoryTree(allCategories);
    }
    
    /**
     * 获取所有分类（列表结构，包含文章数量）
     */
    public List<Category> getCategoryList() {
        List<Category> categories = categoryMapper.selectList(null);
        
        // 设置每个分类的文章数量
        for (Category category : categories) {
            setArticleCount(category);
        }
        
        // 按排序号排序
        return categories.stream()
                .sorted(Comparator.comparing(Category::getOrderNum))
                .collect(Collectors.toList());
    }
    
    /**
     * 根据ID获取分类
     */
    public Category getCategoryById(Long id) {
        Category category = categoryMapper.selectById(id);
        if (category == null) {
            throw new ServiceException("分类不存在");
        }
        
        // 设置文章数量
        setArticleCount(category);
        
        return category;
    }
    
    /**
     * 新增分类
     */
    public void addCategory(Category category) {
        // 检查分类名称是否已存在
        LambdaQueryWrapper<Category> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Category::getName, category.getName());
        if (categoryMapper.selectCount(queryWrapper) > 0) {
            throw new ServiceException("分类名称已存在");
        }
        
        // 设置默认值
        if (category.getParentId() == null) {
            category.setParentId(0L);
        }
        if (category.getOrderNum() == null) {
            category.setOrderNum(0);
        }
        
        categoryMapper.insert(category);
    }
    
    /**
     * 更新分类
     */
    public void updateCategory(Category category) {
        // 验证分类是否存在
        Category existCategory = categoryMapper.selectById(category.getId());
        if (existCategory == null) {
            throw new ServiceException("分类不存在");
        }
        
        // 检查分类名称是否已存在
        LambdaQueryWrapper<Category> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Category::getName, category.getName())
                .ne(Category::getId, category.getId());
        if (categoryMapper.selectCount(queryWrapper) > 0) {
            throw new ServiceException("分类名称已存在");
        }
        
        categoryMapper.updateById(category);
    }
    
    /**
     * 删除分类
     */
    public void deleteCategory(Long id) {
        // 验证分类是否存在
        Category existCategory = categoryMapper.selectById(id);
        if (existCategory == null) {
            throw new ServiceException("分类不存在");
        }
        
        // 检查是否有子分类
        LambdaQueryWrapper<Category> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Category::getParentId, id);
        if (categoryMapper.selectCount(queryWrapper) > 0) {
            throw new ServiceException("请先删除子分类");
        }
        
        // 检查是否有文章使用此分类
        LambdaQueryWrapper<Article> articleWrapper = new LambdaQueryWrapper<>();
        articleWrapper.eq(Article::getCategoryId, id);
        if (articleMapper.selectCount(articleWrapper) > 0) {
            throw new ServiceException("此分类下有文章，无法删除");
        }
        
        categoryMapper.deleteById(id);
    }
    
    /**
     * 设置分类的文章数量
     */
    private void setArticleCount(Category category) {
        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Article::getCategoryId, category.getId())
                .eq(Article::getStatus, 1); // 只统计已发布的文章
        
        Integer count = Math.toIntExact(articleMapper.selectCount(queryWrapper));
        category.setArticleCount(count);
    }
    
    /**
     * 构建分类树形结构
     */
    private List<Category> buildCategoryTree(List<Category> allCategories) {
        List<Category> result = new ArrayList<>();
        
        // 按父ID分组
        Map<Long, List<Category>> parentMap = allCategories.stream()
                .collect(Collectors.groupingBy(Category::getParentId));
        
        // 获取顶级分类
        List<Category> rootCategories = parentMap.getOrDefault(0L, new ArrayList<>());
        
        // 排序
        rootCategories.sort(Comparator.comparing(Category::getOrderNum));
        
        // 设置子分类
        for (Category rootCategory : rootCategories) {
            rootCategory.setChildren(getChildCategories(rootCategory.getId(), parentMap));
            result.add(rootCategory);
        }
        
        return result;
    }
    
    /**
     * 递归获取子分类
     */
    private List<Category> getChildCategories(Long parentId, Map<Long, List<Category>> parentMap) {
        List<Category> children = parentMap.getOrDefault(parentId, new ArrayList<>());
        
        // 排序
        children.sort(Comparator.comparing(Category::getOrderNum));
        
        // 递归设置子分类的子分类
        for (Category child : children) {
            child.setChildren(getChildCategories(child.getId(), parentMap));
        }
        
        return children;
    }
} 