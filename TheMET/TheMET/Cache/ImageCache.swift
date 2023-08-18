//
//  ImageCache.swift
//  TheMET
//
//  Created by Анна Ситникова on 17/08/2023.
//

import Foundation
import UIKit

class ImageCache {
    
    private let imageFileNameGenerator: ImageFileNameGenerator = ImageFileNameGenerator()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cleanUpCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc
    private func cleanUpCache() {
        self.loadedImagesCollection = [:]
    }

    private var loadedImagesCollection: [URL : UIImage] = [:]
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let image = self.loadedImagesCollection[imageURL]  {
            completion(image)
        } else {
            DispatchQueue.global().sync {
                guard let fileURL = self.makeFileUrl(urlString: urlString),
                      let data = try? Data(contentsOf: fileURL),
                      let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self.loadedImagesCollection[imageURL] = image
                completion(image)
            }
        }
    }
    
    func putLoadedImageToCache(image: UIImage, for urlString: String) {
        guard let imageURL = URL(string: urlString) else {
            return
        }
        self.loadedImagesCollection[imageURL] = image
        DispatchQueue.global().sync {
            guard let fileURL = self.makeFileUrl(urlString: urlString) else { return }
            let fileManager = FileManager.default
            let data = image.pngData()
            fileManager.createFile(atPath: fileURL.path, contents: data)
        }
    }
    
    private func makeFileUrl(urlString: String) -> URL? {
        guard let folderURL = URL.cacheSubfolderURL,
              let imageName = self.imageFileNameGenerator.urlgenerateFilename(urlString: urlString) else {
            return nil
        }
        var fileName: String = ""
        fileName.append(imageName)
        return folderURL.appending(component: fileName)
    }
    
}
