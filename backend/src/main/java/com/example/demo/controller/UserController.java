package com.example.demo.controller;

import com.example.demo.dto.ApiResponse;
import com.example.demo.dto.UserInfoDTO;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/info")
    public ApiResponse<UserInfoDTO> getUserInfo(@RequestParam String userId) {
        UserInfoDTO userInfo = userService.getUserInfo(userId);
        if (userInfo == null) {
            return ApiResponse.error(400, "user not found");
        }
        return ApiResponse.success(userInfo);
    }
}
