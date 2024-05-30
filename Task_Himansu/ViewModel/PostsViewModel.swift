//
//  PostsViewModel.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//

import Foundation
struct PostsViewModel:PostsInteractorProtocol{
    let delegate:PostsViewModelProtocol
    func fetchPosts(
        page: Int,
        limit: Int
    ) {
        let interactor = PostsInteractor(delegate: self)
        interactor.fetchPosts(
            page: page,
            limit: limit
        )
    }
    
    func updatePostsResponse(error: String?, page:Int, posts: [PostVM]?) {
        self.delegate.updatePostsResponse(posts: posts, page: page, error: error)
    }
}

protocol PostsViewModelProtocol{
    func updatePostsResponse(posts:[PostVM]?, page:Int, error:String?)
}
