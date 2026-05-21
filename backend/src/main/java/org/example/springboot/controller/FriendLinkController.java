package org.example.springboot.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.springboot.common.Result;
import org.example.springboot.entity.FriendLink;
import org.example.springboot.service.FriendLinkService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

@Tag(name = "友情链接接口")
@RestController
public class FriendLinkController {
    
    @Resource
    private FriendLinkService friendLinkService;
    
    @Operation(summary = "获取前台显示的友情链接")
    @GetMapping("/friendLinks")
    public Result<?> getVisibleFriendLinks() {
        List<FriendLink> friendLinks = friendLinkService.getVisibleFriendLinks();
        return Result.success(friendLinks);
    }
    
    @Operation(summary = "管理员获取所有友情链接")
    @GetMapping("/admin/friendLinks")
    public Result<?> getAllFriendLinks() {

        
        List<FriendLink> friendLinks = friendLinkService.getAllFriendLinks();
        return Result.success(friendLinks);
    }
    
    @Operation(summary = "管理员分页获取友情链接")
    @GetMapping("/admin/friendLinks/page")
    public Result<?> getFriendLinksByPage(
            @RequestParam(defaultValue = "") String name,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer currentPage,
            @RequestParam(defaultValue = "10") Integer size) {

        
        Page<FriendLink> page = friendLinkService.getFriendLinksByPage(name, status, currentPage, size);
        return Result.success(page);
    }
    
    @Operation(summary = "根据ID获取友情链接")
    @GetMapping("/admin/friendLinks/{id}")
    public Result<?> getFriendLinkById(@PathVariable Long id) {

        
        FriendLink friendLink = friendLinkService.getFriendLinkById(id);
        return Result.success(friendLink);
    }
    
    @Operation(summary = "管理员新增友情链接")
    @PostMapping("/admin/friendLinks")
    public Result<?> addFriendLink(@RequestBody FriendLink friendLink) {

        
        boolean result = friendLinkService.addFriendLink(friendLink);
        return result ? Result.success() : Result.error("新增友情链接失败");
    }
    
    @Operation(summary = "管理员更新友情链接")
    @PutMapping("/admin/friendLinks/{id}")
    public Result<?> updateFriendLink(@PathVariable Long id, @RequestBody FriendLink friendLink) {

        
        friendLink.setId(id);
        boolean result = friendLinkService.updateFriendLink(friendLink);
        return result ? Result.success() : Result.error("更新友情链接失败");
    }
    
    @Operation(summary = "管理员删除友情链接")
    @DeleteMapping("/admin/friendLinks/{id}")
    public Result<?> deleteFriendLink(@PathVariable Long id) {

        
        boolean result = friendLinkService.deleteFriendLink(id);
        return result ? Result.success() : Result.error("删除友情链接失败");
    }
    
    @Operation(summary = "管理员更新友情链接状态")
    @PutMapping("/admin/friendLinks/{id}/status")
    public Result<?> updateFriendLinkStatus(@PathVariable Long id, @RequestParam Integer status) {

        
        boolean result = friendLinkService.updateFriendLinkStatus(id, status);
        return result ? Result.success() : Result.error("更新友情链接状态失败");
    }
} 