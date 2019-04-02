//
//  TumblrResponse.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 3/28/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import Foundation

struct TumblrResponse: Codable {
    let meta: Meta
    let response: [Response]
}

struct Meta: Codable {
    let status: Int
    let msg: String
}

struct Response: Codable {
    let type: TypeEnum
    let blogName: String
    let blog: ResponseBlog
    let id: Int
    let postURL: String
    let slug, date: String
    let timestamp: Int
    let state: String
    let format: String
    let reblogKey: String
    let tags: [String]
    let shortURL: String
    let summary: String
    let bookmarklet, mobile: Bool?
    let shouldOpenInLegacy: Bool
    let recommendedSource, recommendedColor: String?
    let featuredInTag: [String]?
    let featuredTimestamp: Int?
    let noteCount: Int
    let caption: String?
    let reblog: Reblog?
    let trail: [Trail]?
    let photosetLayout: String?
    let photos: [Photo]?
    let canLike, canReblog, canSendInMessage, canReply: Bool
    let displayAvatar: Bool
    let imagePermalink: String?
    let sourceURL: String?
    let sourceTitle: String?
    let linkURL: String?
    let isAnonymous, isSubmission: Bool?
    let title: String?
    let body: String?
    let permalinkURL: String?
    let html5Capable: Bool?
    let thumbnailURL: String?
    let thumbnailWidth, thumbnailHeight: Int?
    let player: PlayerUnion?
    let videoType: String?
    let video: Video?
    let text, source: String?
    let trackName: String?
    let albumArt: String?
    let embed: String?
    let plays: Int?
    let audioURL, audioSourceURL: String?
    let isExternal: Bool?
    let audioType: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case blogName = "blog_name"
        case blog, id
        case postURL = "post_url"
        case slug, date, timestamp, state, format
        case reblogKey = "reblog_key"
        case tags, bookmarklet, mobile
        case shortURL = "short_url"
        case summary
        case shouldOpenInLegacy = "should_open_in_legacy"
        case recommendedSource = "recommended_source"
        case recommendedColor = "recommended_color"
        case featuredInTag = "featured_in_tag"
        case featuredTimestamp = "featured_timestamp"
        case noteCount = "note_count"
        case title, body, caption, reblog, trail
        case photosetLayout = "photoset_layout"
        case photos
        case canLike = "can_like"
        case canReblog = "can_reblog"
        case canSendInMessage = "can_send_in_message"
        case canReply = "can_reply"
        case displayAvatar = "display_avatar"
        case imagePermalink = "image_permalink"
        case sourceURL = "source_url"
        case sourceTitle = "source_title"
        case linkURL = "link_url"
        case isAnonymous = "is_anonymous"
        case isSubmission = "is_submission"
        case permalinkURL = "permalink_url"
        case html5Capable = "html5_capable"
        case thumbnailURL = "thumbnail_url"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case player
        case videoType = "video_type"
        case video
        case text, source
        case trackName = "track_name"
        case albumArt = "album_art"
        case embed, plays
        case audioURL = "audio_url"
        case audioSourceURL = "audio_source_url"
        case isExternal = "is_external"
        case audioType = "audio_type"
    }
}

enum TypeEnum: String, Codable {
    case photo = "photo"
    case text = "text"
    case video = "video"
    case link = "link"
    case answer = "answer"
    case quote = "quote"
    case audio = "audio"
    case chat = "chat"
}

struct ResponseBlog: Codable {
    let name, title, description: String
    let url: String
    let uuid: String
    let updated: Int
}

enum PlayerUnion: Codable {
    case playerArray([Player])
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Player].self) {
            self = .playerArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(PlayerUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PlayerUnion"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .playerArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

struct Player: Codable {
    let width: Int
    let embedCode: String
    
    enum CodingKeys: String, CodingKey {
        case width
        case embedCode = "embed_code"
    }
}

struct Video: Codable {
    let youtube: Youtube?
}

struct Youtube: Codable {
    let videoID: String
    let width, height: Int
    
    enum CodingKeys: String, CodingKey {
        case videoID = "video_id"
        case width, height
    }
}

struct Photo: Codable {
    let caption: String
    let originalSize: Size
    let altSizes: [Size]
    let exif: Exif?
    
    enum CodingKeys: String, CodingKey {
        case caption
        case originalSize = "original_size"
        case altSizes = "alt_sizes"
        case exif
    }
}

struct Size: Codable {
    let url: String
    let width, height: Int
}

struct Exif: Codable {
    let camera: String?
    
    enum CodingKeys: String, CodingKey {
        case camera = "Camera"
    }
}

struct Reblog: Codable {
    let comment, treeHTML: String
    
    enum CodingKeys: String, CodingKey {
        case comment
        case treeHTML = "tree_html"
    }
}

struct Trail: Codable {
    let blog: TrailBlog
    let post: PostInfo
    let contentRaw, content: String
    let isCurrentItem, isRootItem: Bool
    
    enum CodingKeys: String, CodingKey {
        case blog, post
        case contentRaw = "content_raw"
        case content
        case isCurrentItem = "is_current_item"
        case isRootItem = "is_root_item"
    }
}

struct TrailBlog: Codable {
    let name: String
    let active: Bool
    let theme: Theme
    let shareLikes, shareFollowing, canBeFollowed: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, active, theme
        case shareLikes = "share_likes"
        case shareFollowing = "share_following"
        case canBeFollowed = "can_be_followed"
    }
}

struct Theme: Codable {
    let headerFullWidth, headerFullHeight, headerFocusWidth, headerFocusHeight: Int?
    let avatarShape: String
    let backgroundColor: String
    let bodyFont: String
    let headerBounds: HeaderBounds
    let headerImage, headerImageFocused, headerImageScaled: String
    let headerStretch: Bool
    let linkColor: String
    let showAvatar, showDescription, showHeaderImage, showTitle: Bool
    let titleColor: String
    let titleFont: String
    let titleFontWeight: String
    
    enum CodingKeys: String, CodingKey {
        case headerFullWidth = "header_full_width"
        case headerFullHeight = "header_full_height"
        case headerFocusWidth = "header_focus_width"
        case headerFocusHeight = "header_focus_height"
        case avatarShape = "avatar_shape"
        case backgroundColor = "background_color"
        case bodyFont = "body_font"
        case headerBounds = "header_bounds"
        case headerImage = "header_image"
        case headerImageFocused = "header_image_focused"
        case headerImageScaled = "header_image_scaled"
        case headerStretch = "header_stretch"
        case linkColor = "link_color"
        case showAvatar = "show_avatar"
        case showDescription = "show_description"
        case showHeaderImage = "show_header_image"
        case showTitle = "show_title"
        case titleColor = "title_color"
        case titleFont = "title_font"
        case titleFontWeight = "title_font_weight"
    }
}

struct PostInfo: Codable {
    let id: ID
}
enum ID: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ID"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum HeaderBounds: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(HeaderBounds.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HeaderBounds"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
