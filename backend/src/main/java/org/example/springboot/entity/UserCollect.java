package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_collect")
@Schema(description = "用户收藏实体类")
public class UserCollect {
    @TableId(type = IdType.AUTO)
    @Schema(description = "收藏ID")
    private Long id;
    
    @Schema(description = "用户ID")
    private Long userId;
    
    @Schema(description = "文章ID")
    private Long articleId;
    
    @Schema(description = "创建时间")
    private LocalDateTime createTime;
} 