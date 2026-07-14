package com.example.demo.service;

import com.example.demo.dto.ArticlePageDTO;
import com.example.demo.dto.ArticlePageDTO.ArticleItemDTO;
import com.example.demo.entity.Article;
import com.example.demo.entity.Banner;
import com.example.demo.entity.Category;
import com.example.demo.repository.ArticleRepository;
import com.example.demo.repository.BannerRepository;
import com.example.demo.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HomeService {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final BannerRepository bannerRepository;
    private final CategoryRepository categoryRepository;
    private final ArticleRepository articleRepository;

    public List<Map<String, Object>> getBannerList() {
        List<Banner> banners = bannerRepository.findByStatusOrderBySortOrderAsc(1);
        return banners.stream().map(b -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", b.getId());
            map.put("imageUrl", b.getImageUrl());
            map.put("linkUrl", b.getLinkUrl());
            map.put("sortOrder", b.getSortOrder());
            return map;
        }).collect(Collectors.toList());
    }

    public List<Map<String, Object>> getCategoryList() {
        List<Category> categories = categoryRepository.findByStatusOrderBySortOrderAsc(1);
        return categories.stream().map(c -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", c.getId());
            map.put("name", c.getName());
            map.put("iconUrl", c.getIconUrl());
            map.put("route", c.getRoute());
            return map;
        }).collect(Collectors.toList());
    }

    public Map<String, Object> getArticleList(int pageNum, int pageSize) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<Article> page = articleRepository.findByStatusOrderByCreateTimeDesc(1, pageable);

        List<ArticleItemDTO> list = page.getContent().stream().map(a -> {
            String createTimeStr = a.getCreateTime() != null ? a.getCreateTime().format(FORMATTER) : null;
            return new ArticleItemDTO(a.getId(), a.getTitle(), a.getSummary(), a.getCoverUrl(), createTimeStr);
        }).collect(Collectors.toList());

        Map<String, Object> result = new HashMap<>();
        result.put("total", page.getTotalElements());
        result.put("pageNum", pageNum);
        result.put("pageSize", pageSize);
        result.put("pages", page.getTotalPages());
        result.put("list", list);
        return result;
    }
}
