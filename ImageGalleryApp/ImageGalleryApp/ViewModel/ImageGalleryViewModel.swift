//
//  ImageGalleryViewModel.swift
//  ImageGalleryApp
//
//  Created by Mac on 15/10/24.
//

import Foundation

class UserViewModel {
    var imageData = [ImagesModel]()
    
    func getUser(completion: @escaping (Result<[ImagesModel], Error>) -> Void) {
        let endpoint = "https://jsonplaceholder.typicode.com/photos"
        
        APIManager.shared.request(endpoint: endpoint, method: "GET", parameters: nil) { [weak self] (result: Result<[ImagesModel], Error>) in
            switch result {
            case .success(let data):
                self?.imageData = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

}
