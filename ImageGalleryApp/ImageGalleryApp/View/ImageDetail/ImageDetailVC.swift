//
//  ImageDetailVC.swift
//  ImageGalleryApp
//
//  Created by Mac on 16/10/24.
//

import UIKit

class ImageDetailVC: UIViewController {
    
    @IBOutlet weak var imageDetailCV: UICollectionView!
    
    var imageData = [ImagesModel]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        {
            self.imageDetailCV.scrollToItem(at: NSIndexPath(item: self.index, section: 0) as IndexPath,at: [],animated: false)
        }
    }
    
}

extension ImageDetailVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = imageDetailCV.frame.width
        let height = (imageDetailCV.frame.height - 100)
        return CGSize(width: width , height: height)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageDetailCV.dequeueReusableCell(withReuseIdentifier: "ImageDetailCollectionViewCell", for: indexPath) as? ImageDetailCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.imageView.setImage(with: URL(string: self.imageData[indexPath.row].thumbnailURL ?? ""),placeholder: UIImage(named: "default-image"))
        cell.titleLbl.text = self.imageData[indexPath.row].title ?? ""
        return cell
    }
    
    
}

