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
@Table(name = "category")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(name = "icon_url")
    private String iconUrl;

    private String route;

    @Column(name = "sort_order")
    private Integer sortOrder;

    private Integer status;

    @Column(name = "create_time")
    private LocalDateTime createTime;
}
