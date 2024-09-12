//
//  User.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: String?
    let updatedAt: String?
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    let location: String?
    let profileImage: ProfileImage?
    let totalLikes: Int?
    let totalPhotos: Int?
    let social: Social?
    
    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case bio, location
        case profileImage = "profile_image"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case social
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct Social: Codable {
    let instagramUsername: String?
    let portfolioUrl: String?
    let twitterUsername: String?
    let paypalEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioUrl = "portfolio_url"
        case twitterUsername = "twitter_username"
        case paypalEmail = "paypal_email"
    }
}
