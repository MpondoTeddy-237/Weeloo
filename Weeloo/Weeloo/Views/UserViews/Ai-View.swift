// //
// //  Ai-View.swift
// //  Weeloo
// //
// //  Created by TEDDY 237 on 28/04/2025.
// //
// 
// import SwiftUI
// import GoogleGenerativeAI
// import _PhotosUI_SwiftUI
// 
// struct Ai_View: View {
//     @State private var messages: [Message] = []
//     @State private var inputText = ""
//     @State private var isSending = false
//     @State private var showMap = false
//     @State private var showHome = false
//     @State private var selectedImageData: Data?
//     @State private var selectedItem: PhotosPickerItem?
//     @State private var isTyping = false
//     @State private var showSuggestions = true
//     
//     // Sample question suggestions
//     let suggestions = [
//         "How do I schedule a car maintenance?",
//         "What are the common car maintenance services?",
//         "How much does an oil change cost?",
//         "What should I do if my check engine light is on?",
//         "How often should I service my car?"
//     ]
//     
//     struct Message: Identifiable, Equatable {
//         let id = UUID()
//         let content: String
//         let isUser: Bool
//         let timestamp: Date
//         var isSending: Bool = false
//         var displayedText: String = ""
//         var imageData: Data?
// 
//         static func == (lhs: Message, rhs: Message) -> Bool {
//             lhs.id == rhs.id &&
//             lhs.content == rhs.content &&
//             lhs.isUser == rhs.isUser &&
//             lhs.timestamp == rhs.timestamp &&
//             lhs.isSending == rhs.isSending &&
//             lhs.displayedText == rhs.displayedText &&
//             lhs.imageData == rhs.imageData
//         }
//     }
//     
//     var body: some View {
//         ZStack(alignment: .top) {
//             // Background gradient
//             LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.1), Color.orange.opacity(0.05)]),
//                           startPoint: .top, endPoint: .bottom)
//                 .ignoresSafeArea()
//             
//             VStack(spacing: 0) {
//                 // Header
//                 HStack {
//                     Button(action: { showHome = true }) {
//                         Image(systemName: "chevron.left")
//                             .font(.system(size: 18, weight: .bold))
//                             .foregroundColor(.indigo)
//                             .padding(8)
//                             .background(Color.white.opacity(0.8))
//                             .clipShape(Circle())
//                             .shadow(color: .indigo.opacity(0.08), radius: 2, x: 0, y: 1)
//                     }
//                     .padding(.leading, 12)
//                     
//                     Spacer()
//                     
//                     Button(action: { showMap = true }) {
//                         Image(systemName: "location.fill")
//                             .font(.system(size: 18, weight: .bold))
//                             .foregroundColor(.orange)
//                             .padding(8)
//                             .background(Color.white.opacity(0.8))
//                             .clipShape(Circle())
//                             .shadow(color: .orange.opacity(0.08), radius: 2, x: 0, y: 1)
//                     }
//                     .padding(.trailing, 12)
//                 }
//                 .padding(.top, 16)
//                 
//                 // Logo and Title
//                 VStack(spacing: 8) {
//                     Image("assistant-ia")
//                         .resizable()
//                         .scaledToFit()
//                         .frame(width: 100, height: 90)
//                         .padding(.top, 10)
//                     
//                     Text("WeeAi Assistant")
//                         .font(.title)
//                         .fontWeight(.bold)
//                         .foregroundColor(.indigo)
//                     
//                     Text("Your Personal Garage Expert")
//                         .font(.subheadline)
//                         .foregroundColor(.gray)
//                 }
//                 .padding(.bottom, 20)
//                 
//                 // Question Suggestions
//                 if showSuggestions && messages.isEmpty {
//                     ScrollView(.horizontal, showsIndicators: false) {
//                         HStack(spacing: 12) {
//                             ForEach(suggestions, id: \.self) { suggestion in
//                                 Button(action: {
//                                     inputText = suggestion
//                                     showSuggestions = false
//                                 }) {
//                                     Text(suggestion)
//                                         .font(.subheadline)
//                                         .padding(.horizontal, 16)
//                                         .padding(.vertical, 8)
//                                         .background(Color.indigo.opacity(0.1))
//                                         .foregroundColor(.indigo)
//                                         .cornerRadius(20)
//                                 }
//                             }
//                         }
//                         .padding(.horizontal)
//                     }
//                     .padding(.bottom, 16)
//                 }
//                 
//                 // Messages
//                 ScrollViewReader { proxy in
//                     ScrollView {
//                         LazyVStack(spacing: 12) {
//                             ForEach(messages) { message in
//                                 AiMessageBubble(message: message)
//                                     .id(message.id)
//                             }
//                         }
//                         .padding()
//                     }
//                     .onChange(of: messages) { _ in
//                         if let lastMessage = messages.last {
//                             withAnimation {
//                                 proxy.scrollTo(lastMessage.id, anchor: .bottom)
//                             }
//                         }
//                     }
//                 }
//                 
//                 VStack(spacing: 0) {
//                     Divider()
//                     
//                     if let imageData = selectedImageData,
//                        let uiImage = UIImage(data: imageData) {
//                         HStack(spacing: 8) {
//                             Image(uiImage: uiImage)
//                                 .resizable()
//                                 .scaledToFit()
//                                 .frame(width: 40, height: 40)
//                                 .cornerRadius(8)
//                             
//                             Button(action: {
//                                 selectedImageData = nil
//                                 selectedItem = nil
//                             }) {
//                                 Image(systemName: "xmark.circle.fill")
//                                     .font(.system(size: 16))
//                                     .foregroundColor(.gray)
//                             }
//                         }
//                         .padding(.horizontal, 12)
//                         .padding(.vertical, 8)
//                     }
//                     
//                     HStack(spacing: 12) {
//                         PhotosPicker(selection: $selectedItem,
//                                    matching: .images) {
//                             Image(systemName: "plus.circle.fill")
//                                 .font(.system(size: 24))
//                                 .foregroundColor(.indigo)
//                         }
//                         
//                         TextField("Message...", text: $inputText, axis: .vertical)
//                             .textFieldStyle(PlainTextFieldStyle())
//                             .padding(.horizontal, 12)
//                             .padding(.vertical, 8)
//                             .background(
//                                 Capsule()
//                                     .fill(Color.gray.opacity(0.1))
//                             )
//                             .frame(minHeight: 36, maxHeight: 80)
//                             .lineLimit(1...4)
//                         
//                         Button(action: sendMessage) {
//                             Image(systemName: "arrow.up.circle.fill")
//                                 .font(.system(size: 25))
//                                 .foregroundColor(.white)
//                                 .background(
//                                     Circle()
//                                         .fill(Color.indigo)
//                                         .frame(width: 32, height: 32)
//                                 )
//                         }
//                         .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty && selectedImageData == nil || isSending)
//                     }
//                     .padding(.horizontal, 12)
//                     .padding(.vertical, 8)
//                 }
//                 .background(Color.white)
//             }
//             .navigationBarBackButtonHidden(true)
//             .navigationDestination(isPresented: $showHome) {
//                 HomeView()
//             }
//             .navigationDestination(isPresented: $showMap) {
//                 ClientMapView()
//             }
//         }
//         .onChange(of: selectedItem) { item in
//             Task {
//                 if let data = try? await item?.loadTransferable(type: Data.self) {
//                     selectedImageData = data
//                 }
//             }
//         }
//     }
//     
//     func sendMessage() {
//         let messageText = inputText.trimmingCharacters(in: .whitespaces)
//         guard !messageText.isEmpty || selectedImageData != nil else { return }
//         
//         isSending = true
//         showSuggestions = false
//         
//         let userMessage = Message(
//             content: messageText,
//             isUser: true,
//             timestamp: Date(),
//             isSending: true,
//             imageData: selectedImageData
//         )
//         messages.append(userMessage)
//         
//         inputText = ""
//         selectedImageData = nil
//         selectedItem = nil
//         
//         // Simulate sending animation
//         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//             if let index = messages.firstIndex(where: { $0.id == userMessage.id }) {
//                 messages[index].isSending = false
//             }
//         }
//         
//         // Simulate AI response
//         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//             let botMessage = Message(
//                 content: "I'm here to help you with your car and garage needs. How can I assist you today?",
//                 isUser: false,
//                 timestamp: Date()
//             )
//             messages.append(botMessage)
//             isSending = false
//         }
//     }
// }
// 
// struct AiMessageBubble: View {
//     let message: Ai_View.Message
//     
//     var body: some View {
//         HStack {
//             if message.isUser {
//                 Spacer()
//             }
//             
//             VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
//                 if let imageData = message.imageData,
//                    let uiImage = UIImage(data: imageData) {
//                     Image(uiImage: uiImage)
//                         .resizable()
//                         .scaledToFit()
//                         .frame(maxWidth: 200, maxHeight: 200)
//                         .cornerRadius(16)
//                 }
//                 
//                 if !message.content.isEmpty {
//                     Text(message.isUser ? message.content : message.displayedText)
//                         .padding(12)
//                         .background(
//                             message.isUser ?
//                             Color.indigo :
//                             Color.white
//                         )
//                         .foregroundColor(message.isUser ? .white : .primary)
//                         .cornerRadius(20)
//                         .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
//                 }
//                 
//                 Text(message.timestamp, style: .time)
//                     .font(.caption2)
//                     .foregroundColor(.gray)
//             }
//             
//             if !message.isUser {
//                 Spacer()
//             }
//         }
//         .scaleEffect(message.isSending ? 0.95 : 1.0)
//         .opacity(message.isSending ? 0.8 : 1.0)
//     }
// }
// 
// #Preview {
//     Ai_View() 
// }
