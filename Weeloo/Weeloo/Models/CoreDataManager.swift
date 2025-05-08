//
//  CoreDataManager.swift
//  Weeloo
//
//  Created by TEDDY 237 on 08/05/2025.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Post CRUD Operations
    
    func createPost(with image: UIImage, caption: String) -> PostEntity {
        let post = PostEntity(context: context)
        post.id = UUID()
        post.caption = caption
        post.imageData = image.jpegData(compressionQuality: 0.7)
        post.likeCount = 0
        post.commentCount = 0
        post.createdAt = Date()
        
        saveContext()
        return post
    }
    
    func fetchAllPosts() -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching posts: \(error)")
            return []
        }
    }
    
    func updatePostLikeCount(post: PostEntity, isLiked: Bool) {
        post.likeCount = isLiked ? post.likeCount + 1 : post.likeCount - 1
        saveContext()
    }
    
    func deletePost(post: PostEntity) {
        context.delete(post)
        saveContext()
    }
    
    // MARK: - Comment CRUD Operations
    
    func addComment(to post: PostEntity, text: String, username: String) -> CommentEntity {
        let comment = CommentEntity(context: context)
        comment.id = UUID()
        comment.text = text
        comment.username = username
        comment.createdAt = Date()
        comment.post = post
        
        post.commentCount += 1
        
        saveContext()
        return comment
    }
    
    func fetchComments(for post: PostEntity) -> [CommentEntity] {
        let request: NSFetchRequest<CommentEntity> = CommentEntity.fetchRequest()
        request.predicate = NSPredicate(format: "post == %@", post)
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching comments: \(error)")
            return []
        }
    }
    
    func deleteComment(comment: CommentEntity) {
        if let post = comment.post {
            post.commentCount -= 1
        }
        
        context.delete(comment)
        saveContext()
    }
}

// MARK: - Post UI Models

// A UI model for displaying posts
struct PostUIModel: Identifiable {
    let id: UUID
    let postEntity: PostEntity
    var image: UIImage?
    var caption: String
    var likeCount: Int
    var commentCount: Int
    var createdAt: Date
    
    init(postEntity: PostEntity) {
        self.id = postEntity.id ?? UUID()
        self.postEntity = postEntity
        self.caption = postEntity.caption ?? ""
        self.likeCount = Int(postEntity.likeCount)
        self.commentCount = Int(postEntity.commentCount)
        self.createdAt = postEntity.createdAt ?? Date()
        
        if let imageData = postEntity.imageData {
            self.image = UIImage(data: imageData)
        }
    }
}

// A UI model for displaying comments
struct CommentUIModel: Identifiable {
    let id: UUID
    let commentEntity: CommentEntity
    var username: String
    var text: String
    var createdAt: Date
    
    init(commentEntity: CommentEntity) {
        self.id = commentEntity.id ?? UUID()
        self.commentEntity = commentEntity
        self.username = commentEntity.username ?? "Anonymous"
        self.text = commentEntity.text ?? ""
        self.createdAt = commentEntity.createdAt ?? Date()
    }
} 