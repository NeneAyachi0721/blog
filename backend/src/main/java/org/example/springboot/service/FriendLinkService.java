package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.commons.lang3.StringUtils;
import org.example.springboot.entity.FriendLink;
import org.example.springboot.mapper.FriendLinkMapper;
import org.example.springboot.exception.ServiceException;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

@Service
public class FriendLinkService {
    
    @Resource
    private FriendLinkMapper friendLinkMapper;
    
    /**
     * 获取所有友情链接
     */
    public List<FriendLink> getAllFriendLinks() {
        // 按排序号升序排列
        LambdaQueryWrapper<FriendLink> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByAsc(FriendLink::getOrderNum);
        
        return friendLinkMapper.selectList(queryWrapper);
    }
    
    /**
     * 获取所有显示状态的友情链接（前台使用）
     */
    public List<FriendLink> getVisibleFriendLinks() {
        LambdaQueryWrapper<FriendLink> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(FriendLink::getStatus, 1)
                   .orderByAsc(FriendLink::getOrderNum);
        
        return friendLinkMapper.selectList(queryWrapper);
    }
    
    /**
     * 分页获取友情链接
     */
    public Page<FriendLink> getFriendLinksByPage(String name, Integer status, Integer currentPage, Integer size) {
        Page<FriendLink> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<FriendLink> queryWrapper = new LambdaQueryWrapper<>();
        
        // 添加查询条件
        if (StringUtils.isNotBlank(name)) {
            queryWrapper.like(FriendLink::getName, name);
        }
        
        if (status != null) {
            queryWrapper.eq(FriendLink::getStatus, status);
        }
        
        // 按排序号升序排列
        queryWrapper.orderByAsc(FriendLink::getOrderNum);
        
        return friendLinkMapper.selectPage(page, queryWrapper);
    }
    
    /**
     * 根据ID获取友情链接
     */
    public FriendLink getFriendLinkById(Long id) {
        if (id == null) {
            throw new ServiceException("友链ID不能为空");
        }
        
        return friendLinkMapper.selectById(id);
    }
    
    /**
     * 新增友情链接
     */
    public boolean addFriendLink(FriendLink friendLink) {
        if (friendLink == null) {
            throw new ServiceException("友链信息不能为空");
        }
        
        if (StringUtils.isBlank(friendLink.getName())) {
            throw new ServiceException("友链名称不能为空");
        }
        
        if (StringUtils.isBlank(friendLink.getUrl())) {
            throw new ServiceException("友链地址不能为空");
        }
        
        // 设置默认值
        if (friendLink.getOrderNum() == null) {
            friendLink.setOrderNum(0);
        }
        
        if (friendLink.getStatus() == null) {
            friendLink.setStatus(1); // 默认显示
        }
        
        return friendLinkMapper.insert(friendLink) > 0;
    }
    
    /**
     * 更新友情链接
     */
    public boolean updateFriendLink(FriendLink friendLink) {
        if (friendLink == null || friendLink.getId() == null) {
            throw new ServiceException("友链信息不完整");
        }
        
        if (StringUtils.isBlank(friendLink.getName())) {
            throw new ServiceException("友链名称不能为空");
        }
        
        if (StringUtils.isBlank(friendLink.getUrl())) {
            throw new ServiceException("友链地址不能为空");
        }
        
        FriendLink existFriendLink = friendLinkMapper.selectById(friendLink.getId());
        if (existFriendLink == null) {
            throw new ServiceException("友链不存在");
        }
        
        return friendLinkMapper.updateById(friendLink) > 0;
    }
    
    /**
     * 删除友情链接
     */
    public boolean deleteFriendLink(Long id) {
        if (id == null) {
            throw new ServiceException("友链ID不能为空");
        }
        
        return friendLinkMapper.deleteById(id) > 0;
    }
    
    /**
     * 更新友情链接状态
     */
    public boolean updateFriendLinkStatus(Long id, Integer status) {
        if (id == null) {
            throw new ServiceException("友链ID不能为空");
        }
        
        if (status == null) {
            throw new ServiceException("状态不能为空");
        }
        
        FriendLink friendLink = friendLinkMapper.selectById(id);
        if (friendLink == null) {
            throw new ServiceException("友链不存在");
        }
        
        friendLink.setStatus(status);
        return friendLinkMapper.updateById(friendLink) > 0;
    }
} 