//
//  AIService.swift
//  LearnLock
//
//  Created by Adam Pascarella on 10/21/24.
//

import Foundation

enum AIServiceError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case missingAPIKey
}

class AIService {
    static let shared = AIService()
    
    private let apiKey: String
    private let baseURL = "https://api.anthropic.com/v1/chat/completions"
    
    private init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "CLAUDE_API_KEY") as? String else {
            fatalError("API Key not found. Ensure it's set in Config.xcconfig and linked in Info.plist")
        }
        self.apiKey = apiKey
    }
    
    func generateActionPlan(for book: String, goal: String, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = """
        Generate an action plan for reading the book "\(book)" with the goal of "\(goal)". 
        The action plan should include:
        1. A brief introduction
        2. 5-7 specific, actionable steps
        3. A conclusion summarizing the expected outcome
        
        Format the response in Markdown.
        """
        
        let messages = [
            ["role": "system", "content": "You are an AI assistant that creates personalized action plans for reading books."],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "claude-3-sonnet-20240229",
            "messages": messages,
            "max_tokens": 1000
        ]
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(AIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "x-api-key")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(AIServiceError.networkError(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(AIServiceError.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(AIServiceError.invalidResponse))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(AIServiceError.invalidResponse))
                }
            } catch {
                completion(.failure(AIServiceError.decodingError(error)))
            }
        }.resume()
    }
}
