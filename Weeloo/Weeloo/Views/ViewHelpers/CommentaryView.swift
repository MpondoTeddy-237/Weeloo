//
//  CommentaryView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 08/05/2025.
//

import SwiftUI

struct CommentaryView: View {
    let post: PostUIModel
    @EnvironmentObject var viewModel: PostViewModel
    @State private var commentText = ""
    @State private var comments: [CommentUIModel] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding()
                } else if comments.isEmpty {
                    VStack {
                        Spacer()
                        Text("No comments yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Be the first to comment!")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(comments) { comment in
                                CommentRow(comment: comment)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button {
                        if !commentText.isEmpty {
                            addComment()
                        }
                    } label: {
                        Text("Post")
                            .fontWeight(.semibold)
                            .foregroundColor(.indigo)
                    }
                    .disabled(commentText.isEmpty)
                    .padding(.trailing)
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadComments()
            }
        }
    }
    
    private func loadComments() {
        isLoading = true
        comments = viewModel.fetchComments(for: post)
        isLoading = false
    }
    
    private func addComment() {
        viewModel.addComment(to: post, text: commentText)
        // Reload comments after adding a new one
        comments = viewModel.fetchComments(for: post)
        commentText = ""
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CommentRow: View {
    let comment: CommentUIModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.indigo)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(comment.username)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Spacer()
                    
                    Text(timeAgo(from: comment.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Text(comment.text)
                    .font(.system(size: 15))
                    .lineLimit(nil)
                
                HStack(spacing: 15) {
                    Button {
                        // Like comment action
                    } label: {
                        Text("Like")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Button {
                        // Reply action
                    } label: {
                        Text("Reply")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 5)
    }
    
    func timeAgo(from date: Date) -> String {
        let seconds = Int(-date.timeIntervalSinceNow)
        
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let days = seconds / 86400
            return "\(days)d ago"
        }
    }
}

#Preview {
    let coreDataManager = CoreDataManager.shared
    let sampleImage = UIImage(systemName: "photo")!
    let post = coreDataManager.createPost(with: sampleImage, caption: "Sample post for preview")
    return CommentaryView(post: PostUIModel(postEntity: post))
        .environmentObject(PostViewModel())
}
