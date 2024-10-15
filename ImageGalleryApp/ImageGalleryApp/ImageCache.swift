//
//  ImageCache.swift
//  ImageGalleryApp
//
//  Created by Mac on 15/10/24.
//

import UIKit

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0

    private var savedTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var savedUrl: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        // cancel prior task, if any
        weak var oldTask = savedTask
        savedTask = nil
        oldTask?.cancel()
        // reset image view’s image
        self.image = placeholder
        // allow supplying of `nil` to remove old image and then return immediately
        guard let url else { return }
        // check cache
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            print("cache image")
            return
        }
        savedUrl = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.savedTask = nil
            if let error {
                if (error as? URLError)?.code == .cancelled {
                    return
                }
                print(error)
                return
            }
            guard let data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: url.absoluteString)
            if url == self?.savedUrl {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }
        savedTask = task
        task.resume()
    }
}


class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol?

    static let shared = ImageCache()

    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

//class ImageCache: UIImageView
//{
//
//    private let imageCache = NSCache<AnyObject, UIImage>()
//
//    func loadImage(fromURL imageURL: URL, placeHolderImage: String)
//    {
//        self.image = UIImage(named: placeHolderImage)
//
//        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
//        {
//            print("image loaded from cache for =\(imageURL)")
//            self.image = cachedImage
//            return
//        }
//
//        DispatchQueue.global().async {
//            [weak self] in
//
//            if let imageData = try? Data(contentsOf: imageURL)
//            {
//                debugPrint("image downloaded from server...")
//                if let image = UIImage(data: imageData)
//                {
//                    DispatchQueue.main.async {
//                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
