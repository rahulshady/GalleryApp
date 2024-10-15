//
//  ViewController.swift
//  ImageGalleryApp
//
//  Created by Mac on 15/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imagesCV: UICollectionView!

        private let imagesViewModel = ImagesViewModel()
        override func viewDidLoad() {
            super.viewDidLoad()
            getImages()
        }
    
    func getImages(){
        
        imagesViewModel.getUser { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.imagesCV.reloadData()
                }
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }

    }
        
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = imagesCV.frame.width / 4 - 10
        return CGSize(width: width , height: width)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesViewModel.imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imagesCV.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as? ImagesCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.imageView.setImage(with: URL(string: self.imagesViewModel.imageData[indexPath.row].thumbnailURL ?? ""),placeholder: UIImage(named: "default-image"))
        return cell
    }
    
}

