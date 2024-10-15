//
//  ApiManager.swift
//  ImageGalleryApp
//
//  Created by Mac on 15/10/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func request<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        // Perform the API request with the provided endpoint, method, and parameters
        
        let url = URL(string:endpoint)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            // Handle the API response
            let decoder = JSONDecoder()
                // Decode the API response data
                if let data = data {
                    do {
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            
        }.resume()
    }
}


