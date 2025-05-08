//
//  UserPostView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 27/04/2025.
//

import SwiftUI
import PhotosUI

// MARK: - Main UserPostView
struct UserPostView: View {
    @EnvironmentObject var viewModel: PostViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding()
                } else if viewModel.posts.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Text("No Posts Yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Tap the + button to create your first post")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 1),
                        GridItem(.flexible(), spacing: 1),
                        GridItem(.flexible(), spacing: 1)
                    ], spacing: 1) {
                        ForEach(viewModel.posts) { post in
                            Button {
                                viewModel.selectedPost = post
                            } label: {
                                if let image = post.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 90)
                                        .clipped()
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .aspectRatio(1.0, contentMode: .fill)
                                        .frame(height: 90)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.isNewPostPresented = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.indigo)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Refresh posts
                        viewModel.fetchPosts()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isNewPostPresented) {
                NewPostView()
            }
            .sheet(item: $viewModel.selectedPost) { post in
                PostDetailView(post: post)
            }
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    UserPostView()
        .environmentObject(PostViewModel())
}
