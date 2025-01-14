//
//  UserResponse.swift
//  VkFeed
//
//  Created by Илья Павлов on 14.01.2025.
//

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String
}
