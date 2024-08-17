//
//  OpenAIManager.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 17/08/2024.
//

import Foundation

/// `OpenAIManager` is a singleton class responsible for managing interactions with the OpenAI API.
/// It securely loads the API key from an external `OpenAI-info.plist` file and provides methods to interact with the API, such as generating text completions.
class OpenAIManager {
    
    /// The shared singleton instance of `OpenAIManager`, allowing for centralized management of API requests.
    static let shared = OpenAIManager()
    
    /// The API key used to authenticate requests to the OpenAI API. This key is loaded from the `OpenAI-info.plist` file.
    private let apiKey: String
    
    /// Private initializer to enforce the singleton pattern. This initializer loads the API key from the
    /// `OpenAI-info.plist` file located in the app's main bundle.
    private init() {
        // Attempt to find and load the `OpenAI-info.plist` file from the app bundle.
        guard let path = Bundle.main.path(forResource: "OpenAI-info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["OpenAIAPIKey"] as? String else {
            fatalError("API Key not found in OpenAI-info.plist")
        }
        apiKey = key
    }
    
    /// Generates a completion from the OpenAI API based on the provided prompt.
    ///
    /// - Parameters:
    ///   - prompt: The text prompt to send to the OpenAI API for generating a completion.
    ///   - completion: A closure that is called with the API's response, which is either a generated completion string or `nil` in case of an error.
    func generateCompletion(for prompt: String, completion: @escaping (String?) -> Void) {
        // Ensure the API URL is valid
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            print("Invalid URL.")
            completion(nil)
            return
        }
        
        // Set up the HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Define the parameters for the API request
        let parameters: [String: Any] = [
            "model": "gpt-4o",      // Specify the model to use
            "prompt": prompt,       // The prompt provided by the user
            "max_tokens": 150,      // Limit the number of tokens in the response
            "temperature": 0.7      // Control the randomness of the output
        ]
        
        // Serialize the parameters to JSON and set the request body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Failed to serialize parameters: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        // Perform the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network errors
            guard error == nil, let data = data else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            // Parse the JSON response
            do {
                // Convert the response data to a dictionary
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                // Extract the completion text from the response
                let text = jsonResponse?["choices"] as? [[String: Any]]
                let result = text?.first?["text"] as? String
                
                // Trim whitespace and newlines from the response text
                completion(result?.trimmingCharacters(in: .whitespacesAndNewlines))
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // Start the network request
        task.resume()
    }
}
