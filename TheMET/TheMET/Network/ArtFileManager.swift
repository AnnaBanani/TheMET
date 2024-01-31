//
//  ArtFileManager.swift
//  TheMET
//
//  Created by Анна Ситникова on 26/05/2023.
//

import Foundation
import UIKit
import MetAPI

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
        let fileManager = FileManager.default
        let fileURL = self.makeFileUrl(artId: art.objectID)
        DispatchQueue.global().async {
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
    
    func readArt(id: ArtID, completion: @escaping (Art?) -> Void) {
        let fileManager = FileManager.default
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
    
    func readArtIds(completion: @escaping ([ArtID]) -> Void) {
        var artIds:[ArtID] = []
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: self.folderURL.path(percentEncoded: false)) else {
            completion(artIds)
            return
        }
        DispatchQueue.global().async {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: self.folderURL, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    let fileName = (file.lastPathComponent).replacingOccurrences(of: file.pathExtension, with: "")
                    if let id: ArtID = ArtID(fileName) {
                        artIds.append(id)
                    }
                }
                DispatchQueue.main.async {
                    completion(artIds)
                }
            } catch {
                print("Could not search for urls of files in documents directory: \(error)")
            }
        }
    }
    
    func deleteArt(id: ArtID) {
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
    
    private func makeFileUrl(artId: ArtID) -> URL {
        var fileName: String = ""
        fileName.append(String(artId))
        fileName.append(".string")
        return self.folderURL.appending(component: fileName)
    }
}


