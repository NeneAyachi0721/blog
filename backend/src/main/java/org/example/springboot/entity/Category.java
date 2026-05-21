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
@TableName("category")
@Schema(description = "文章分类实体类")
public class Category {
    @TableId(type = IdType.AUTO)
    @Schema(description = "分类ID")
    private Long id;

    @Schema(description = "分类名称")
    private String name;

    @Schema(description = "分类描述")
    private String description;

    @Schema(description = "父分类ID(0表示顶级分类)")
    private Long parentId;

    @Schema(description = "排序号")
    private Integer orderNum;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
    
    // 非数据库字段
    @TableField(exist = false)
    @Schema(description = "子分类列表")
    private List<Category> children;
    
    @TableField(exist = false)
    @Schema(description = "文章数量")
    private Integer articleCount;
} 