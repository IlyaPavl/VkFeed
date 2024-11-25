//
//  FeedResponse.swift
//  VkFeed
//
//  Created by Илья Павлов on 15.12.2023.
//

import Foundation

protocol ProfileRepresenatable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachment]?
}

struct Attachment: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
    var height: Int { getPropperSize().height }
    var width: Int { getPropperSize().width }
    var srcBig: String { getPropperSize().url }
    
    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: {$0.type == "x"}) {
            return sizeX
        } else if let fullSize = sizes.last {
            return fullSize
        } else {
            return .init(type: "wrong type", url: "", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct CountableItem: Decodable {
    let count: Int
}

struct Profile: Decodable, ProfileRepresenatable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100 }
}

struct Group: Decodable, ProfileRepresenatable {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
}
