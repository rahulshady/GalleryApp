//
//  Model.swift
//  ImageGalleryApp
//
//  Created by Mac on 15/10/24.
//

import Foundation

struct ImagesModel: Codable {
    let albumID, id: Int?
    let title: String?
    let url, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias Welcome = [ImagesModel]
