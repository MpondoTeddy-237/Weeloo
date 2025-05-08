//
//  PostViewModel.swift
//  Weeloo
//
//  Created by TEDDY 237 on 08/05/2025.
//

import SwiftUI
import Combine

class PostViewModel: ObservableObject {
    @Published var posts: [PostUIModel] = []
    @Published var selectedPost: PostUIModel?
    @Published var isNewPostPresented: Bool = false
    @Published var isLoading: Bool = false
    
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        isLoading = true
        
        DispatchQueue.main.async {
            let postEntities = self.coreDataManager.fetchAllPosts()
            self.posts = postEntities.map { PostUIModel(postEntity: $0) }
            self.isLoading = false
        }
    }
    
    func createPost(with image: UIImage, caption: String) {
        isLoading = true
        
        DispatchQueue.main.async {
            let postEntity = self.coreDataManager.createPost(with: image, caption: caption)
            let newPost = PostUIModel(postEntity: postEntity)
            self.posts.insert(newPost, at: 0)
            self.isLoading = false
        }
    }
    
    func toggleLike(post: PostUIModel) {
        // This is a simplified implementation
        // In a real app, you would track which posts are liked by the current user
        let isLiked = true
        coreDataManager.updatePostLikeCount(post: post.postEntity, isLiked: isLiked)
        
        // Update UI model
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].likeCount = Int(post.postEntity.likeCount)
        }
    }
    
    func addComment(to post: PostUIModel, text: String) {
        // In a real app, you would get the real username from the authenticated user
        let username = "me"
        let _ = coreDataManager.addComment(to: post.postEntity, text: text, username: username)
        
        // Update UI model
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].commentCount = Int(post.postEntity.commentCount)
        }
        
        // If the commented post is the currently selected post, update selected post
        if selectedPost?.id == post.id {
            selectedPost?.commentCount = Int(post.postEntity.commentCount)
        }
    }
    
    func fetchComments(for post: PostUIModel) -> [CommentUIModel] {
        let commentEntities = coreDataManager.fetchComments(for: post.postEntity)
        return commentEntities.map { CommentUIModel(commentEntity: $0) }
    }
} 
