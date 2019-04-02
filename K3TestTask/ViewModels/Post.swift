//
//  Post.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 3/28/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import Foundation
import UIKit

enum ContentType: String {
    case photo
    case notPhoto
}

struct Post {
    var blogName: String
    var blogAvatar: String
    var type: ContentType
    var imageUrl: String?
    var imageHeight: CGFloat
    var summary = String()
    var tags = String()
    var notesCount: Int
    
    init(with response: Response) {
        self.blogName = response.blogName
        self.blogAvatar = "https://api.tumblr.com/v2/blog/\(response.blog.uuid)/avatar"
        if let photo = response.photos?.first {
            self.type = .photo
            let ratio = Double(photo.originalSize.width) / Double(photo.originalSize.height)
            let newHeight = UIScreen.main.bounds.width / CGFloat(ratio)
            self.imageUrl = photo.originalSize.url
            self.imageHeight = newHeight
        } else {
            self.type = .notPhoto
            let newHeight = UIScreen.main.bounds.width
            self.imageUrl = nil
            self.imageHeight = newHeight
        }
        self.summary = response.summary
        let featuredTags = response.featuredInTag ?? []
        if !featuredTags.isEmpty {
            self.tags = "#\(featuredTags.joined(separator: " #"))"
        }
        if !response.tags.isEmpty {
            self.tags += "#\(response.tags.joined(separator: " #"))"
        }
        self.notesCount = response.noteCount
    }
}
