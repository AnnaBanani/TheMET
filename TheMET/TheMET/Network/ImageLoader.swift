//
//  ImageLoader.swift
//  TheMET
//
//  Created by Анна Ситникова on 23/03/2023.
//

import Foundation
import UIKit

class ImageLoader {
    
    private var loadedImagesCollection: [URL : UIImage] = [:]
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cleanUpCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc
    private func cleanUpCache() {
        self.loadedImagesCollection = [:]
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let image = self.loadedImagesCollection[imageURL]  {
            completion(image)
            return
        }
        DispatchQueue.global().async {
            let executeComplitionOnMain: (UIImage?) -> Void = { image in
                DispatchQueue.main.async {
                    self.loadedImagesCollection[imageURL] = image
                    completion(image)
                }
            }
            if let imageData = try? Data(contentsOf: imageURL),
               let loadedImage = UIImage(data: imageData) {
                executeComplitionOnMain(loadedImage)
            } else {
                executeComplitionOnMain(nil)
            }
        }
    }
}

    

