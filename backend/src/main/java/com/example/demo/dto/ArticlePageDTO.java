package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ArticlePageDTO {

    private Long total;
    private Integer pageNum;
    private Integer pageSize;
    private Integer pages;
    private List<ArticleItemDTO> list;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ArticleItemDTO {
        private Long id;
        private String title;
        private String summary;
        private String coverUrl;
        private String createTime;
    }
}
