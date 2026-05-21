package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("article")
@Schema(description = "文章实体类")
public class Article {
    @TableId(type = IdType.AUTO)
    @Schema(description = "文章ID")
    private Long id;

    @Schema(description = "文章标题")
    private String title;

    @Schema(description = "文章内容(Markdown格式)")
    private String content;

    @Schema(description = "文章内容(HTML格式)")
    private String htmlContent;

    @Schema(description = "文章摘要")
    private String summary;

    @Schema(description = "封面图片")
    private String coverImage;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "作者ID")
    private Long userId;

    @Schema(description = "浏览量")
    private Integer viewCount;

    @Schema(description = "点赞数")
    private Integer likeCount;

    @Schema(description = "评论数")
    private Integer commentCount;

    @Schema(description = "状态(0:草稿,1:已发布,2:已删除)")
    private Integer status;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    @Schema(description = "是否置顶(0:否,1:是)")
    private Integer isTop;

    @Schema(description = "是否推荐(0:否,1:是)")
    private Integer isRecommend;
    
    // 非数据库字段
    @TableField(exist = false)
    @Schema(description = "分类名称")
    private String categoryName;
    
    @TableField(exist = false)
    @Schema(description = "作者名称")
    private String authorName;
    
    @TableField(exist = false)
    @Schema(description = "标签列表")
    private List<Tag> tags;
} 