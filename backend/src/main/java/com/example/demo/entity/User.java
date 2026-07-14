package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private String userId;

    @Column(name = "nick_name")
    private String nickName;

    private String avatar;

    private Integer points;

    @Column(name = "collect_count")
    private Integer collectCount;

    @Column(name = "view_count")
    private Integer viewCount;

    @Column(name = "create_time")
    private LocalDateTime createTime;
}
