package org.example.springboot.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.example.springboot.entity.User;

import java.util.List;

@Mapper
public interface UserMapper extends BaseMapper<User> {
    /**
     * 批量删除用户
     * @param ids 用户ID列表
     * @return 删除的记录数
     */
    int deleteByIds(@Param("ids") List<Integer> ids);
}
