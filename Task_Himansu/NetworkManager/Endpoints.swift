//
//  Endpoints.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//

import Foundation
enum Endpoints{
    case fetchPosts(page:Int, limit:Int)
    
    var url:String{
        switch self{
        case .fetchPosts(page: let page, limit: let limit):
            return "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)"
        }
    }
}
