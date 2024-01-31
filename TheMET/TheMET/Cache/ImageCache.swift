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
        self.loadedImagesCollectionQueue.async {
            self.loadedImagesCollection = [:]
        }
    }

    private var loadedImagesCollection: [URL : UIImage] = [:]
    
    private let loadedImagesCollectionQueue = DispatchQueue(label: "loadedImagesCollectionQueue")
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        self.loadedImagesCollectionQueue.async {
            guard let imageURL = URL(string: urlString) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            if let image = self.loadedImagesCollection[imageURL]  {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.global().async {
                    guard let fileURL = self.makeFileUrl(urlString: urlString),
                          let data = try? Data(contentsOf: fileURL),
                          let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    self.loadedImagesCollectionQueue.async {
                        self.loadedImagesCollection[imageURL] = image
                    }
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    func putLoadedImageToCache(image: UIImage, for urlString: String) {
        self.loadedImagesCollectionQueue.async {
            guard let imageURL = URL(string: urlString) else {
                return
            }
            self.loadedImagesCollection[imageURL] = image
            DispatchQueue.global().async {
                guard let fileURL = self.makeFileUrl(urlString: urlString) else { return }
                let fileManager = FileManager.default
                let data = image.pngData()
                fileManager.createFile(atPath: fileURL.path, contents: data)
            }
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
