//
//  ChatBot.swift
//  Weeloo
//
//  Created by TEDDY 237 on 28/04/2025.
//

import Foundation
import SwiftUI

// MARK: - Response Models
struct ChatResponse: Codable {
    let id: String?
    let choices: [Choice]?
    let created: Int?
    let model: String?
    let usage: Usage?
    let error: ErrorResponse?
}

struct ErrorResponse: Codable {
    let message: String
    let code: Int
    let metadata: ErrorMetadata?
}

struct ErrorMetadata: Codable {
    let providerName: String?
    
    enum CodingKeys: String, CodingKey {
        case providerName = "provider_name"
    }
}

struct Choice: Codable {
    let message: Message
    let index: Int
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case index
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Custom Errors
enum ChatBotError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    case emptyResponse
    case serverError(String)
    case apiError(message: String, code: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let code):
            return "Server returned invalid response code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .emptyResponse:
            return "Server returned empty response"
        case .serverError(let message):
            return "Server error: \(message)"
        case .apiError(let message, let code):
            return "API Error (\(code)): \(message)"
        }
    }
}

final class ChatBot: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // Replace with your OpenRouter API key
    private let apiKey = "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"
    
    func send(text: String, completion: @escaping (String) -> Void) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
            handleError(.invalidURL, completion: completion)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("https://github.com/MpondoTeddy-237/Weeloo", forHTTPHeaderField: "HTTP-Referer")
        request.addValue("Weeloo", forHTTPHeaderField: "X-Title")
        
        let requestBody: [String: Any] = [
            "model": "google/gemini-pro-1.5",
            "messages": [
                ["role": "user", "content": text]
            ],
            "max_tokens": 4000 // Limiting max tokens to avoid credit issues
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            handleError(.decodingError(error), completion: completion)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.handleError(.networkError(error), completion: completion)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.handleError(.invalidResponse(0), completion: completion)
                    return
                }
                
                guard let data = data else {
                    self?.handleError(.emptyResponse, completion: completion)
                    return
                }
                
                // Debug print for raw response
                print("Raw Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ChatResponse.self, from: data)
                    
                    // Check for API error response
                    if let error = response.error {
                        self?.handleError(.apiError(message: error.message, code: error.code), completion: completion)
                        return
                    }
                    
                    // Check for valid response with choices
                    guard let choices = response.choices,
                          let firstChoice = choices.first else {
                        self?.handleError(.emptyResponse, completion: completion)
                        return
                    }
                    
                    completion(firstChoice.message.content)
                } catch {
                    print("Decoding Error: \(error)")
                    self?.handleError(.decodingError(error), completion: completion)
                }
            }
        }.resume()
    }
    
    private func handleError(_ error: ChatBotError, completion: @escaping (String) -> Void) {
        self.isLoading = false
        self.errorMessage = error.errorDescription
        completion("Error: \(error.errorDescription ?? "Unknown error")")
    }
}
