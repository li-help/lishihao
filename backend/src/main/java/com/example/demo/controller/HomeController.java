package com.example.demo.controller;

import com.example.demo.dto.ApiResponse;
import com.example.demo.service.HomeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/home")
@RequiredArgsConstructor
public class HomeController {

    private final HomeService homeService;

    @GetMapping("/banner")
    public ApiResponse<List<Map<String, Object>>> getBannerList() {
        List<Map<String, Object>> data = homeService.getBannerList();
        return ApiResponse.success(data);
    }

    @GetMapping("/category")
    public ApiResponse<List<Map<String, Object>>> getCategoryList() {
        List<Map<String, Object>> data = homeService.getCategoryList();
        return ApiResponse.success(data);
    }

    @GetMapping("/list")
    public ApiResponse<Map<String, Object>> getArticleList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        Map<String, Object> data = homeService.getArticleList(pageNum, pageSize);
        return ApiResponse.success(data);
    }
}
