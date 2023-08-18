//
//  URL+getFolderURL.swift
//  TheMET
//
//  Created by Анна Ситникова on 27/06/2023.
//

import Foundation
import UIKit

extension URL {
    static func documentsSubfolderURL(folderName: String) -> URL? {
        let fileManager = FileManager.default
        guard let homeDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return homeDirectory.appending(component: folderName)
    }
    
    static var cacheSubfolderURL: URL? {
        let fileManager = FileManager.default
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
}



