//
//  Image.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

struct Image: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
