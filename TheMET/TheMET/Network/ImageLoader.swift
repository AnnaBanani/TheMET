//
//  ImageLoader.swift
//  TheMET
//
//  Created by Анна Ситникова on 23/03/2023.
//

import Foundation
import UIKit

class ImageLoader {
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: urlString) else {
            completion(nil)
            return
        }
        DispatchQueue.global().async { [] in
            if let imageData = try? Data(contentsOf: imageURL),
               let loadedImage = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(loadedImage)
                }
            }
        }
    }
}

    

