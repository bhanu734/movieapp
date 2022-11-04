//
//  HomeModel.swift
//  movieapp
//
//  Created by Mac on 30/10/22.
//

import Foundation


// MARK: - HomeModel
struct HomeModel: Codable {
    let statusCode: Int?
    let response: HomeResponse?
}

// MARK: - Response
struct HomeResponse: Codable {
    let data: HomeData?
}

// MARK: - DataClass
struct HomeData: Codable {
    let id: Int?
    let friendlyURL, seoDescription, title, type: String?
    let playlists: [Playlist]?

    enum CodingKeys: String, CodingKey {
        case id
        case friendlyURL = "friendly_url"
        case seoDescription = "seo_description"
        case title, type, playlists
    }
}

// MARK: - Playlist
struct Playlist: Codable {
    let id: Int?
    let title: String?
    let content: [Content]?
}

// MARK: - Content
struct Content: Codable {
    let id: Int?
    let ageRating: String?
    let videoID: String?
    let contentType: ContentType?
    let title: String?
    let imagery: Imagery?

    enum CodingKeys: String, CodingKey {
        case id
        case ageRating = "age_rating"
        case videoID = "video_id"
        case contentType = "content_type"
        case title, imagery
    }
}

enum ContentType: String, Codable {
    case liveTV = "LiveTV"
    case movie = "movie"
    case series = "series"
}

// MARK: - Imagery
struct Imagery: Codable {
    let thumbnail, backdrop, mobileImg, featuredImg: String?
    let banner: String?

    enum CodingKeys: String, CodingKey {
        case thumbnail, backdrop
        case mobileImg = "mobile_img"
        case featuredImg = "featured_img"
        case banner
    }
}
