//
//  Ai-interfaceView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import SwiftUI
import OpenAISwift
import PhotosUI

struct Ai_interfaceView: View {
    @ObservedObject var chatBotObject = ChatBot()
    @State var text = ""
    @State var messages: [Message] = []
    @State private var isAnimating = false
    @State private var headerOffset: CGFloat = -50
    @State private var headerOpacity: Double = 0
    @State private var isSending = false
    @State private var sendingMessage: Message?
    @StateObject private var keyboardResponder = KeyboardResponder()
    @Environment(\.dismiss) private var dismiss
    @State private var showMap = false
    @State private var showHome = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var suggestedQuestions: [String] = []
    
    // Initial suggestions for car mechanics
    private let initialSuggestions = [
        "What are common signs of engine trouble?",
        "How often should I change my oil?",
        "What does the check engine light mean?",
        "How can I improve my car's fuel efficiency?",
        "What's the difference between synthetic and conventional oil?"
    ]
    
    // Context-based suggestions
    private let contextSuggestions: [String: [String]] = [
        "engine": [
            "What are the symptoms of a failing engine?",
            "How much does engine repair typically cost?",
            "Should I repair or replace my engine?"
        ],
        "brake": [
            "How do I know if my brakes need replacing?",
            "What's the difference between drum and disc brakes?",
            "How often should brake pads be changed?"
        ],
        "tire": [
            "What's the correct tire pressure for my car?",
            "How do I know when to replace my tires?",
            "What's the difference between all-season and winter tires?"
        ],
        "battery": [
            "How long do car batteries typically last?",
            "What are signs of a failing battery?",
            "How do I jump start a car safely?"
        ]
    ]
    
    struct Message: Identifiable, Equatable {
        let id = UUID()
        let content: String
        let isUser: Bool
        let timestamp: Date
        var isSending: Bool = false
        var displayedText: String = ""
        var isTyping: Bool = false
        var imageData: Data? // Add support for images
        
        // Implement Equatable
        static func == (lhs: Message, rhs: Message) -> Bool {
            lhs.id == rhs.id &&
            lhs.content == rhs.content &&
            lhs.isUser == rhs.isUser &&
            lhs.timestamp == rhs.timestamp &&
            lhs.isSending == rhs.isSending &&
            lhs.displayedText == rhs.displayedText &&
            lhs.isTyping == rhs.isTyping &&
            lhs.imageData == rhs.imageData
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    // Back Button
                    Button(action: { showHome = true }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.indigo)
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(color: .indigo.opacity(0.08), radius: 2, x: 0, y: 1)
                    }
                    .padding(.leading, 12)
                    Spacer()
                    // Locate Garage Button
                    Button(action: { showMap = true }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(color: .orange.opacity(0.08), radius: 2, x: 0, y: 1)
                    }
                    .padding(.trailing, 12)
                }
                .padding(.top, 16)
                /// Header with Logo
                VStack(spacing: 8) {
                    Image("assistant-ia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 90)
                        .padding(.top, 10)
                    
                    Text("WeeAi- Garage Assistant")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                    
                    Text("Powered by gemini-pro-1.5")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
                
                /// Chat Messages
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                                    .transition(.opacity.combined(with: .scale))
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: message.isSending)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: message.displayedText)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessage = messages.last {
                            withAnimation(.easeOut(duration: 0.2)) {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                            updateSuggestions(basedOn: lastMessage.content)
                        }
                    }
                    .onChange(of: keyboardResponder.isKeyboardVisible) { _ in
                        if let lastMessage = messages.last {
                            withAnimation(.easeOut(duration: 0.2)) {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                /// Input Area
                VStack(spacing: 0) {
                    Divider()
                    if let imageData = selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        HStack(spacing: 8) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            
                            Button(action: {
                                selectedImageData = nil
                                selectedItem = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    
                    HStack(spacing: 12) {
                        // Plus Button with PhotosPicker
                        PhotosPicker(selection: $selectedItem,
                                   matching: .images) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.indigo)
                        }
                        
                        // Text Field
                        TextField("Ask anything...", text: $text, axis: .vertical)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.1))
                            )
                            .frame(minHeight: 36, maxHeight: 80)
                            .lineLimit(1...14)
                        
                        // Send Button
                        Button(action: send) {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(Color.indigo)
                                        .frame(width: 32, height: 32)
                                )
                        }
                        .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty && selectedImageData == nil || isSending)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    
                    // Suggested Questions
                    if !suggestedQuestions.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(suggestedQuestions, id: \.self) { question in
                                    Button(action: {
                                        text = question
                                    }) {
                                        Text(question)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.indigo.opacity(0.1))
                                            .foregroundColor(.indigo)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
                .onChange(of: selectedItem) { item in
                    Task {
                        if let data = try? await item?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                .offset(y: keyboardResponder.isKeyboardVisible ? -8 : 0)
                .padding(.bottom, keyboardResponder.isKeyboardVisible ? 0 : 0)
            }
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .onAppear {
                withAnimation {
                    headerOffset = 0
                    headerOpacity = 1
                }
                suggestedQuestions = initialSuggestions
            }
            // Navigation to ClientMapView
            .navigationDestination(isPresented: $showHome) {
                HomeView()
            }
            .navigationDestination(isPresented: $showMap) {
                ClientMapView()
            }
        }
    }
    
    private func updateSuggestions(basedOn message: String) {
        var newSuggestions: [String] = []
        
        // Check for keywords in the message
        for (keyword, suggestions) in contextSuggestions {
            if message.lowercased().contains(keyword) {
                newSuggestions.append(contentsOf: suggestions)
            }
        }
        
        // If no context-specific suggestions, use general ones
        if newSuggestions.isEmpty {
            newSuggestions = initialSuggestions
        }
        
        // Update suggestions with animation
        withAnimation(.easeInOut(duration: 0.3)) {
            suggestedQuestions = newSuggestions
        }
    }
    
    func send() {
        let messageText = text.trimmingCharacters(in: .whitespaces)
        guard !messageText.isEmpty || selectedImageData != nil else { return }
        
        isSending = true
        
        // Create message with image if present
        var userMessage = Message(
            content: messageText,
            isUser: true,
            timestamp: Date(),
            isSending: true,
            imageData: selectedImageData
        )
        messages.append(userMessage)
        
        // Clear the input
        text = ""
        selectedImageData = nil
        selectedItem = nil
        
        // Simulate sending animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let index = messages.firstIndex(where: { $0.id == userMessage.id }) {
                messages[index].isSending = false
            }
        }
        
        // Only send text to ChatBot if there's a message
        if !messageText.isEmpty {
            chatBotObject.send(text: messageText) { response in
                DispatchQueue.main.async {
                    let botMessage = Message(content: response, isUser: false, timestamp: Date(), isTyping: true)
                    messages.append(botMessage)
                    
                    var currentIndex = 0
                    let chunkSize = 10
                    let animationInterval = 0.005
                    
                    let timer = Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { timer in
                        if let index = messages.firstIndex(where: { $0.id == botMessage.id }) {
                            if currentIndex < response.count {
                                let endIndex = min(currentIndex + chunkSize, response.count)
                                messages[index].displayedText = String(response.prefix(endIndex))
                                currentIndex = endIndex
                            } else {
                                messages[index].isTyping = false
                                timer.invalidate()
                                isSending = false
                            }
                        } else {
                            timer.invalidate()
                        }
                    }
                    timer.fire()
                }
            }
        } else {
            // If only image was sent, enable sending new messages immediately
            isSending = false
        }
    }
}

// Helper to clean up and format AI markdown
func formatAIText(_ text: String) -> String {
    var cleaned = text
    // Remove bold and italics markdown
    cleaned = cleaned.replacingOccurrences(of: "**", with: "")
    cleaned = cleaned.replacingOccurrences(of: "* ", with: "• ") // bullet points
    cleaned = cleaned.replacingOccurrences(of: "*", with: "")
    // Remove extra newlines
    while cleaned.contains("\n\n\n") {
        cleaned = cleaned.replacingOccurrences(of: "\n\n\n", with: "\n\n")
    }
    return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
}

struct MessageBubble: View {
    let message: Ai_interfaceView.Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if message.isUser {
                Spacer(minLength: 40)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                if let imageData = message.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 180, maxHeight: 180)
                        .cornerRadius(16)
                }
                
                if !message.content.isEmpty {
                    Text(message.isUser ? message.content : formatAIText(message.displayedText))
                        .font(.footnote)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            message.isUser ?
                                Color.indigo :
                                Color(UIColor.secondarySystemBackground)
                        )
                        .foregroundColor(message.isUser ? .white : .primary)
                        .cornerRadius(22)
                        .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
                        .frame(maxWidth: 320, alignment: message.isUser ? .trailing : .leading)
                }
                
                HStack(spacing: 6) {
                    if message.isUser {
                        Image(systemName: message.isSending ? "circle.fill" : "checkmark")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.9))
                    } else if message.isTyping {
                        HStack(spacing: 4) {
                            Circle().fill(Color.gray).frame(width: 4, height: 4).opacity(0.5)
                            Circle().fill(Color.gray).frame(width: 4, height: 4).opacity(0.7)
                            Circle().fill(Color.gray).frame(width: 4, height: 4)
                        }
                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: message.isTyping)
                    }
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
            
            if !message.isUser {
                Spacer(minLength: 40)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 2)
    }
}

#Preview {
    Ai_interfaceView()
}
