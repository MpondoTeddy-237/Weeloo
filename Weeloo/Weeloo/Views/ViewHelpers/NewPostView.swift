//
//  NewPostView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 08/05/2025.
//

import SwiftUI
import PhotosUI

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PostViewModel
    @State private var caption = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    } else {
                        Button {
                            isImagePickerPresented = true
                        } label: {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                Text("Select Photo")
                                    .font(.headline)
                            }
                            .foregroundColor(.indigo)
                        }
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    TextField("Write a caption...", text: $caption)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Spacer()
                }
                
                if isProcessing || viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createNewPost()
                    }
                    .disabled(selectedImage == nil)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func createNewPost() {
        guard let image = selectedImage else { return }
        
        isProcessing = true
        viewModel.createPost(with: image, caption: caption)
        dismiss()
    }
}

#Preview {
    NewPostView()
        .environmentObject(PostViewModel())
}
