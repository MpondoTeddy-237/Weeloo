//
//  UserProfile.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import SwiftUI
import PhotosUI
// Add this import if UserPostView.swift is in a different module or location
// import Weeloo.Views.ViewHelpers.UserPostView

struct UserProfile: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false 
    @State private var isDeleteAlertPresented = false
    @State private var isEditingProfile = false
    @State private var showAllReviews = false
    @State private var isAnimating = false
    
    // Sample data
    let userName = "John Doe"
    let phoneNumber = "+1 (555) 123-4567"
    let userEmail = "john.doe@example.com"
    let averageRating = 4.8
    let totalRatings = 128
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Header Section
                    VStack(spacing: 10) {
                        // Profile Picture
                        ZStack(alignment: .bottomTrailing) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 3)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.indigo.opacity(0.3))
                            }
                            
                            // Edit Button
                            Button {
                                isImagePickerPresented = true
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.indigo)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 1)
                            }
                            .offset(x: 3, y: 3)
                        }
                        .scaleEffect(isAnimating ? 1 : 0.8)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.1), value: isAnimating)
                        
                        // Name and Phone
                        VStack(spacing: 3) {
                            Text(userName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.indigo)
                            
                            Button {
                                // Copy phone number
                                UIPasteboard.general.string = phoneNumber
                            } label: {
                                Text(phoneNumber)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            Button {
                                // Copy email
                                UIPasteboard.general.string = userEmail
                            } label: {
                                Text(userEmail)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            Button {
                                // View location action (to be implemented)
                            } label: {
                                Text("View Location")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.indigo)
                                    .padding(.top, 1)
                            }
                        }
                        .offset(y: isAnimating ? 0 : 15)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                    }
                    .padding(.top, 10)
                    
                    // Ratings Section
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(averageRating, specifier: "%.1f")")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.indigo)
                                
                                HStack(spacing: 1) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(averageRating) ? "star.fill" : "star")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 13))
                                    }
                                }
                                
                                Text("\(totalRatings) ratings")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                
                                Button {
                                    showAllReviews.toggle()
                                } label: {
                                    Text("View all reviews")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]),
                                                         startPoint: .leading,
                                                         endPoint: .trailing)
                                        )
                                        .clipShape(Capsule())
                                }
                                .padding(.top, 4)
                            }
                            
                            Spacer()
                            
                            Button {
                                postViewModel.isNewPostPresented = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.indigo)
                            }
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                        )
                        .offset(y: isAnimating ? 0 : 15)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.3), value: isAnimating)
                    }
                    .padding(.horizontal, 8)
                    
                    // Posts Gallery
                    if postViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding()
                    } else if postViewModel.posts.isEmpty {
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
                            ForEach(postViewModel.posts) { post in
                                Button {
                                    postViewModel.selectedPost = post
                                } label: {
                                    if let image = post.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 70)
                                            .clipped()
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(height: 70)
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
                        .offset(y: isAnimating ? 0 : 15)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.4), value: isAnimating)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Refresh posts
                        postViewModel.fetchPosts()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $postViewModel.isNewPostPresented) {
                NewPostView()
            }
            .sheet(item: $postViewModel.selectedPost) { post in
                PostDetailView(post: post)
            }
            .alert("Delete Profile Picture?", isPresented: $isDeleteAlertPresented) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    selectedImage = nil
                }
            } message: {
                Text("Are you sure you want to delete your profile picture?")
            }
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
                postViewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    UserProfile()
        .environmentObject(PostViewModel())
}
