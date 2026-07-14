package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoDTO {

    private String avatar;
    private String nickName;
    private String userId;
    private Integer points;
    private Integer collectCount;
    private Integer viewCount;
}
