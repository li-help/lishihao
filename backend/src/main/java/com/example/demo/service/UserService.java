package com.example.demo.service;

import com.example.demo.dto.UserInfoDTO;
import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public UserInfoDTO getUserInfo(String userId) {
        Optional<User> optionalUser = userRepository.findByUserId(userId);
        if (optionalUser.isEmpty()) {
            return null;
        }
        User user = optionalUser.get();
        return new UserInfoDTO(
                user.getAvatar(),
                user.getNickName(),
                user.getUserId(),
                user.getPoints(),
                user.getCollectCount(),
                user.getViewCount()
        );
    }
}
