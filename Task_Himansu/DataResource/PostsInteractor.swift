//
//  PostsInteractor.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//

import Foundation
struct PostsInteractor{
    
    let delegate:PostsInteractorProtocol
    
    func fetchPosts(
        page:Int,
        limit:Int
    ) {
        NetworkManager.shared.getRequest(
            endpoint: .fetchPosts(page: page, limit: limit),
            page: page,
            limit: limit,
            resultType: Post.self
        ) {
            posts, page, error in
                DispatchQueue.main.async {
                    self.delegate.updatePostsResponse(
                        error: error,
                        page: page,
                        posts: PostVM.convertIntoUIModel(posts: posts)
                    )
                }
            }
    }
}

protocol PostsInteractorProtocol{
    func updatePostsResponse(error:String?, page:Int, posts:[PostVM]?)
}


