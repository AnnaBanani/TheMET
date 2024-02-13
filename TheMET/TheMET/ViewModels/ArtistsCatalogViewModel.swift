//
//  ArtistsCatalogViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 13/02/2024.
//

import Foundation
import UIKit
import Combine
import MetAPI

class ArtistsCatalogViewModel {
    
    private let artistsService = ArtistsService.standart
    
    private var artistsServiceSubscriber: AnyCancellable?
    
    private let metAPI = MetAPI()
    
    @Published private(set) var loadedArtists: [FeaturedArtistsCellData] = []
    
    @Published private(set)var contentStatus:LoadingStatus<[FeaturedArtistsCellData]>
    
    private let presentingControllerProvider: () -> UIViewController?
    
    private var loadingArtistNames: [String] = []
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.loadedArtists = []
        self.contentStatus = .loading
        self.presentingControllerProvider = presentingControllerProvider
        self.artistsServiceSubscriber = self.artistsService.$artistsList
            .sink(receiveValue: { [weak self] newArtistsList in
                self?.reloadCatalog(artistsList: newArtistsList)
            })
    }
    
    private func reloadCatalog(artistsList: [String]) {
        self.contentStatus = .loading
        var artistsCellDataList: [FeaturedArtistsCellData] = []
        for artist in artistsList {
            let artistCellData: FeaturedArtistsCellData = FeaturedArtistsCellData(artistName: artist, artistData: .placeholder)
            artistsCellDataList.append(artistCellData)
        }
        self.loadedArtists = artistsCellDataList
        self.contentStatus = .loaded(artistsCellDataList)
    }
    
    func reloadButtonDidTap() {
        self.reloadCatalog(artistsList: self.artistsService.artistsList)
    }
    
    func artistsCellDidTap(_ artistName: String) {
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        let artistArtsViewController = ArtistArtsViewController()
        artistArtsViewController.artistName = artistName
        presentingController.navigationController?.pushViewController(artistArtsViewController, animated: true)
    }
    
    func loadParticularArtistCellDataIfNeeded(artistName: String) {
        guard case .loaded(let artistCellDataList) = self.contentStatus else {
            return
        }
        guard let artistCellData = artistCellDataList.first(where: { cellData in
            cellData.artistName == artistName
        }),
              case .placeholder = artistCellData.artistData,
              !self.loadingArtistNames.contains(artistName),
              let artist = self.loadedArtists.first(where: { artist in
                  artist.artistName == artistName
              })
        else { return }
        self.loadingArtistNames.append(artist.artistName)
        self.loadArtistCellData(artistName: artistName, completion: { [weak self] artistCellData in
            guard let self = self else { return }
            if case .loaded(var artistsCellDataList) = self.contentStatus,
               let artistCellDataIndex = artistsCellDataList.firstIndex(where: { $0.artistName == artistCellData.artistName}) {
                artistsCellDataList[artistCellDataIndex] = artistCellData
                self.contentStatus = .loaded(artistsCellDataList)
            }
            self.loadingArtistNames.removeAll { name in
                return name == artistName
            }
        })
    }
    
    private func loadArtistCellData(artistName: String, attempt: Int = 0, completion: @escaping (FeaturedArtistsCellData) -> Void) {
        let parameters:[SearchParameter] = [
            .artistOrCulture(true),
            .q(artistName)
        ]
        self.metAPI.search(parameters: parameters) { [weak self] searchResults in
            guard let self = self else {
                return
            }
            switch searchResults {
            case .failure(let error):
                guard case .nonDecodableData = error,
                      attempt > 5 else {
                    self.loadArtistCellData(artistName: artistName, attempt: attempt + 1, completion: completion)
                    return
                }
                let artistCellData = FeaturedArtistsCellData(artistName: artistName, artistData: .data(imageURL: nil, title: artistName, subTitle: nil))
                completion(artistCellData)
            case .success(let objects):
                self.loadArtistImageURL(objectsIDs: objects.objectIDs) { url in
                    let artistCellData = FeaturedArtistsCellData(artistName: artistName, artistData: .data(imageURL: url, title: artistName, subTitle: nil))
                    completion(artistCellData)
                }
            }
        }
    }
    
    private func loadArtistImageURL(objectsIDs: [ArtID], completion: @escaping (URL?) -> Void) {
        guard !objectsIDs.isEmpty else {
            completion(nil)
            return
        }
        self.loadObjectImageURL(objectId: objectsIDs[0]) { [weak self] url in
            if let imageURL = url {
                completion(imageURL)
            } else {
                let newObjectsIds: [ArtID] = Array(objectsIDs.dropFirst())
                self?.loadArtistImageURL(objectsIDs: newObjectsIds, completion: completion)
            }
        }
    }
    
    private func loadObjectImageURL(objectId: ArtID, completion: @escaping (URL?) -> Void){
        self.metAPI.object(id: objectId) { objectResult in
            switch objectResult {
            case .failure:
                completion(nil)
            case .success(let object):
                guard let imageURLstring = object.primaryImage else {
                    completion(nil)
                    return
                }
                completion(URL(string: imageURLstring))
            }
        }
    }
    
}
