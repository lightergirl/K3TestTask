//
//  DetailPost.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 4/3/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import Foundation
import UIKit

struct DetailPost {
    var image: String?
    var imageHeight: CGFloat?
    var type: ContentType?
    var blogName: String?
    
    init(with post: Post) {
        self.image = post.imageUrl
        self.imageHeight = post.imageHeight
        self.blogName = post.blogName
        self.type = post.type
    }
}
