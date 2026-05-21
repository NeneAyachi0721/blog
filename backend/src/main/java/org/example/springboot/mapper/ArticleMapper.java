package org.example.springboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.springboot.entity.Article;

@Mapper
public interface ArticleMapper extends BaseMapper<Article> {
    
    /**
     * 获取所有文章的访问量总和
     * @return 总访问量
     */
    @Select("SELECT COALESCE(SUM(view_count), 0) FROM article")
    Long getTotalViewCount();
} 