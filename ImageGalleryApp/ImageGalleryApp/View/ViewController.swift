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
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
          cell.alpha = 1
          cell.transform = .identity
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageDetailVC") as! ImageDetailVC
        vc.imageData = self.imagesViewModel.imageData
        vc.index = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

