//
//  MenuModel.swift
//  movieapp
//
//  Created by Mac on 29/10/22.
//


import Foundation

// MARK: - MenuModelData

struct menumodel: Codable {
    let statusCode: Int?
    let body: MenuBody?
}

// MARK: - MenuBody
struct MenuBody: Codable {
    let total: Int?
    let data: [Menu]?
}

// MARK: - Datum
struct Menu: Codable {
    let id: Int?
    let friendlyURL, seoDescription, title, type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case friendlyURL = "friendly_url"
        case seoDescription = "seo_description"
        case title, type
    }
}


