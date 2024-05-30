//
//  PostModel.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//

import Foundation

struct Post: Decodable {
    let userID: Int?
    let id: Int?
    let title: String?
    let body: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
        case body
    }
}

struct PostVM{
    let userID: Int?
    let id: Int?
    let title: String?
    let body: String?
    
    static func convertIntoUIModel(posts:[Post]?) -> [PostVM]?{
        guard let posts = posts else {
            return nil
        }
        return posts.map({
            PostVM.init(
                userID: $0.userID,
                id: $0.id,
                title: $0.title,
                body: $0.body
            )
        })
    }
    
}



