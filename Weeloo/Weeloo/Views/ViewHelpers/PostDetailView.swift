//
//  PostDetailView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 08/05/2025.
//

import SwiftUI

struct PostDetailView: View {
    let post: PostUIModel
    @EnvironmentObject var viewModel: PostViewModel
    @State private var isLiked = false
    @State private var commentText = ""
    @State private var showCommentary = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if let image = post.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        // Placeholder image
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(1.0, contentMode: .fit)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    if !post.caption.isEmpty {
                        Text(post.caption)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                    }
                    
                    HStack {
                        Button {
                            withAnimation(.spring()) {
                                isLiked.toggle()
                                viewModel.toggleLike(post: post)
                            }
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundColor(isLiked ? .red : .gray)
                        }
                        
                        Text("\(post.likeCount + (isLiked ? 1 : 0)) likes")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Button {
                            showCommentary = true
                        } label: {
                            Image(systemName: "message")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(post.commentCount) comments")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.horizontal)
                    
                    // Comments Section Preview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Comments")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Sample comments (in a real app, get latest 3 comments)
                        let comments = viewModel.fetchComments(for: post)
                        
                        if comments.isEmpty {
                            Text("No comments yet")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(Array(comments.prefix(3))) { comment in
                                HStack(alignment: .top) {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.indigo)
                                    
                                    VStack(alignment: .leading) {
                                        Text(comment.username)
                                            .font(.system(size: 14, weight: .semibold))
                                        Text(comment.text)
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        HStack {
                            TextField("Add a comment...", text: $commentText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button {
                                if !commentText.isEmpty {
                                    viewModel.addComment(to: post, text: commentText)
                                    commentText = ""
                                }
                            } label: {
                                Text("Post")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.indigo)
                            }
                            .disabled(commentText.isEmpty)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Post")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCommentary) {
                CommentaryView(post: post)
            }
        }
    }
}

#Preview {
    let coreDataManager = CoreDataManager.shared
    let sampleImage = UIImage(systemName: "photo")!
    let post = coreDataManager.createPost(with: sampleImage, caption: "Sample post for preview")
    return PostDetailView(post: PostUIModel(postEntity: post))
        .environmentObject(PostViewModel())
}
