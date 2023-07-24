//
//  FavoritesService.swift
//  TheMET
//
//  Created by Анна Ситникова on 26/06/2023.
//

import Foundation
import UIKit

class FavoritesService {
    
    private let artFileManager: ArtFileManager?

    static let standart: FavoritesService = FavoritesService()
    
    private init() {
        guard let favoriteFolderURL = URL.documentsSubfolderURL(folderName: "FavoritesArt/"),
           let artFileManager = ArtFileManager(folderURL: favoriteFolderURL) else {
            self.artFileManager = nil
            return
        }
        self.artFileManager = artFileManager
        let group = DispatchGroup()
        var arts: [Art] = []
        artFileManager.readArtIds { ids in
            for id in ids {
                group.enter()
                artFileManager.readArt(id: id) { art in
                    guard let art = art else {
                        return
                    }
                   arts.append(art)
                    group.leave()
                }
            }
            group.notify(queue: .main) { [weak self] in
                self?.favoriteArts = arts
                NotificationCenter.default.post(name: FavoritesService.didChangeFavoriteArtsNotificationName, object: nil)
            }
        }
    }
    
    static let didChangeFavoriteArtsNotificationName = NSNotification.Name(rawValue: "didChangeFavoriteArts")
    
//    MARK: - API
    
    private (set) var favoriteArts: [Art] = []
    
    func addFavoriteArt(_ art: Art) {
        self.artFileManager?.write(art: art)
        self.favoriteArts.append(art)
        NotificationCenter.default.post(name: FavoritesService.didChangeFavoriteArtsNotificationName, object: nil)
    }
    
    func removeArt(id: ArtID) {
        self.artFileManager?.deleteArt(id: id)
        self.favoriteArts.removeAll { art in
            return art.objectID == id
        }
        NotificationCenter.default.post(name: FavoritesService.didChangeFavoriteArtsNotificationName, object: nil)
    }
}
