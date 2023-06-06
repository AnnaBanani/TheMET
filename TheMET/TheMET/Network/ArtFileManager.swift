//
//  ArtFileManager.swift
//  TheMET
//
//  Created by Анна Ситникова on 26/05/2023.
//

import Foundation
import UIKit

class ArtFileManager {
    
    private let folderURL: URL
    
    init?(folderURL: URL) {
        if folderURL.isFileURL,
           folderURL.hasDirectoryPath {
           self.folderURL = folderURL
       } else {
           return nil
       }
    }
    
    func write(art: Art) {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(art) else {
            return
        }
        guard String(data: jsonData, encoding: .utf8) != nil else {
            return
        }
        let fileManager = FileManager.default
        let fileURL = self.makeFileUrl(artId: art.objectID)
        DispatchQueue.global().sync {
            if !fileManager.fileExists(atPath: self.folderURL.path) {
                do {
                    try fileManager.createDirectory(at: self.folderURL, withIntermediateDirectories: true)
                } catch {
                    return
                }
            }
            fileManager.createFile(atPath: fileURL.path(), contents: jsonData)
        }
    }
    
    func readArt(id: Int, completion: @escaping (Art?) -> Void) {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: self.folderURL.path(percentEncoded: false)) else {
            completion(nil)
            return
        }
        let idFileURL = self.folderURL.appending(component: "\(id).string")
        guard fileManager.fileExists(atPath: idFileURL.path()) else {
            completion(nil)
            return
        }
        DispatchQueue.global().async {
            let executeComplitionOnMain: (Art?) -> Void = { art in
                DispatchQueue.main.async {
                    completion(art)
                }
            }
            let decoder = JSONDecoder()
            if let artData = try? Data(contentsOf: idFileURL),
               let loadedArt = try? decoder.decode(Art.self, from: artData) {
                executeComplitionOnMain(loadedArt)
            } else {
                executeComplitionOnMain(nil)
            }
        }
    }
    
    func readArtIds(completion: @escaping ([Int]) -> Void) {
        var filesIds:[Int] = []
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: self.folderURL.path(percentEncoded: false)) else {
            completion(filesIds)
            return
        }
        DispatchQueue.global().async {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: self.folderURL, includingPropertiesForKeys: nil, options: [])
                let folderURLString = self.folderURL.path(percentEncoded: false)
                let urlStringSuffix: String = ".string"
                for file in directoryContents {
                    let contentString = file.path(percentEncoded: false)
                    var modifiedContentString = contentString.replacingOccurrences(of: folderURLString, with: "")
                    modifiedContentString = modifiedContentString.replacingOccurrences(of: urlStringSuffix, with: "")
                    if let id: Int = Int(modifiedContentString) {
                        filesIds.append(id)
                    }
                }
                completion(filesIds)
            } catch {
                print("Could not search for urls of files in documents directory: \(error)")
            }
        }
    }
    
    func deleteArt(id: Int) {
        let fileManager = FileManager.default
        let fileToDeleteUrl = self.makeFileUrl(artId: id)
        guard fileManager.fileExists(atPath: fileToDeleteUrl.path(percentEncoded: false)) else {
            return
        }
        DispatchQueue.global().async {
            do {
                try fileManager.removeItem(at: fileToDeleteUrl)
            } catch {
                print("Could not search for urls of files in documents directory: \(error)")
            }
        }
    }
    
    private func makeFileUrl(artId: Int) -> URL {
        var fileName: String = ""
        fileName.append(String(artId))
        fileName.append(".string")
        return self.folderURL.appending(component: fileName)
    }
}


