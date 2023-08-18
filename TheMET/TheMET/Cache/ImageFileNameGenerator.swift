//
//  ImageFileNameGenerator.swift
//  TheMET
//
//  Created by Анна Ситникова on 17/08/2023.
//

import Foundation

class ImageFileNameGenerator {
    
    func urlgenerateFilename(urlString: String) -> String? {
        guard var urlName = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else {
            return nil
        }
        var fileName: String = ""
        let splitedString = urlName.split(separator: ".")
        let count = splitedString.count
        for (index, string) in splitedString.enumerated() {
            if index == count - 1 {
                fileName.append(".")
            }
            fileName.append(String(string))
        }
        return fileName
    }
    
}
