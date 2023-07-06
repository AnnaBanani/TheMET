//
//  FeaturedArtService.swift
//  TheMET
//
//  Created by Анна Ситникова on 03/07/2023.
//

import Foundation
import UIKit

class FeaturedArtService {
    
    private let metAPI = MetAPI(networkManager: NetworkManager.standard)
    
    private let artFileManager: ArtFileManager?
    
    private var isFeaturedArtLoading: Bool = false
    
    init() {
        guard let featuredFolderURL = URL.documentsSubfolderURL(folderName: "FeaturedArts"),
              let artFileManager = ArtFileManager(folderURL: featuredFolderURL) else {
            self.artFileManager = nil
            return
        }
        self.artFileManager = artFileManager
        self.updateFeaturedArt()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
//    MARK: - API
    enum FeaturedArt {
        case loaded(Art)
        case loading
        case failedToLoad
    }
    
    private (set) var featuredArt: FeaturedArt = .loading {
        didSet {
            self.onFeaturedArtDidChange()
        }
    }
    
    private var onFeaturedArtDidChange: () -> Void = {}
   
    @objc
    private func appDidBecomeActive() {
        switch self.featuredArt {
        case .failedToLoad:
            self.updateFeaturedArt()
        case .loading:
            return
        case .loaded(let art):
            guard let storedFeaturedArtData = self.readFeaturedArtDataFromStore(),
                  art.objectID == storedFeaturedArtData.artId,
                  self.isFeaturedArtDateActual(date: storedFeaturedArtData.date) else {
                self.forceUpdateFeaturedArt()
                return
            }
            return
        }
    }
    
    static let artIDKey: String = "artID"
    static let dateKey: String = "date"
    
    private func storeFeaturedArtData(artId: ArtID, date: Date) {
        UserDefaults.standard.set(artId, forKey: FeaturedArtService.artIDKey)
        let dateString = self.getDateString(date: date)
        UserDefaults.standard.set(dateString, forKey: FeaturedArtService.dateKey)
    }
    
    private func readFeaturedArtDataFromStore() -> (artId: ArtID, date: Date)? {
        let id = UserDefaults.standard.integer(forKey: FeaturedArtService.artIDKey)
        guard id != 0 else {
            return nil
        }
        guard let dateString = UserDefaults.standard.string(forKey: FeaturedArtService.dateKey),
              let date = self.getDate(dateString: dateString) else {
            return nil
        }
        return (id, date)
    }
    
    private func updateFeaturedArt() {
        guard let storedData = self.readFeaturedArtDataFromStore(),
        self.isFeaturedArtDateActual(date: storedData.date),
        let artFileManager = self.artFileManager else {
            self.forceUpdateFeaturedArt()
            return
        }
        artFileManager.readArt(id: storedData.artId, completion: { [weak self] art in
            guard let art = art else {
                self?.forceUpdateFeaturedArt()
                return
            }
            self?.featuredArt = .loaded(art)
        })
    }
    
    private func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func getDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: dateString)
    }
    
    private func isFeaturedArtDateActual(date: Date) -> Bool {
        let currentDateString = self.getDateString(date: Date.now)
        let dateString = self.getDateString(date: date)
        return currentDateString == dateString
    }
    
    private func forceUpdateFeaturedArt() {
        guard !self.isFeaturedArtLoading else {
            return
        }
        self.isFeaturedArtLoading = true
        self.metAPI.objects { [weak self] objecResponce in
            guard let objecResponce = objecResponce,
            let randomId = objecResponce.objectIDs.randomElement() else {
                self?.featuredArt = .failedToLoad
                self?.isFeaturedArtLoading = false
                return
            }
            self?.metAPI.object(id: randomId) {[weak self] object in
                guard let object = object else {
                    self?.featuredArt = .failedToLoad
                    self?.isFeaturedArtLoading = false
                    return
                }
                self?.storeFeaturedArtData(artId: randomId, date: Date.now)
                self?.artFileManager?.write(art: object)
                self?.featuredArt = .loaded(object)
                self?.isFeaturedArtLoading = false
            }
        }
    }
    
}

