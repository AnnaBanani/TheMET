//
//  ArtistsCatalogViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 13/11/2023.
//

import Foundation
import UIKit
import Combine
import MetAPI

class ArtistsCatalogViewController: UIViewController {
    
    private let artistsService = ArtistsService.standart
    
    private var artistsServiceSubscriber: AnyCancellable?
   
    private let searchBar: UISearchBar = UISearchBar()
    
    private let metAPI = MetAPI()
    
    private let loadingArtistsCatalogView = LoadingPlaceholderView.construstView(configuration: .catalogLoading)
    private let failedArtitstCatalogView = FailedPlaceholderView.constructView(configuration: .catalogFailed)
    private let loadedArtistsCatalogView = FeaturedArtistsContentView.constructView()
    
    private var loadedArtists: [FeaturedArtistsCellData] = []
    
    var loadingArtistNames: [String] = []
    
    var contentStatus:LoadingStatus<[FeaturedArtistsCellData]> = .loading {
        didSet {
            self.updateContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistsServiceSubscriber = self.artistsService.$artistsList
            .sink(receiveValue: { [weak self] newArtistsList in
                self?.reloadCatalog(artistsList: newArtistsList)
            })
        self.add(artistsCatalogSubview: self.failedArtitstCatalogView)
        self.add(artistsCatalogSubview: self.loadedArtistsCatalogView)
        self.add(artistsCatalogSubview: self.loadingArtistsCatalogView)
        self.failedArtitstCatalogView.onButtonTap = { [weak self] in
            self?.reloadButtonDidTap()
        }
        self.loadedArtistsCatalogView.onFeaturedArtistsCellTap = { [weak self] artistName in
            self?.artistsCellDidTap(artistName)
        }
        self.loadedArtistsCatalogView.onFeaturedArtistsCellWillDisplay = { [weak self] artistName in
            self?.loadParticularArtistCellDataIfNeeded(artistName: artistName)
        }
        self.reloadCatalog(artistsList: self.artistsService.artistsList)
    }
    
    private func updateContent() {
        switch contentStatus {
        case .failed:
            self.loadedArtistsCatalogView.content = []
            self.loadingArtistsCatalogView.isHidden = true
            self.failedArtitstCatalogView.isHidden = false
            self.loadedArtistsCatalogView.isHidden = true
        case .loaded(let catalogCellDataList):
            self.loadedArtistsCatalogView.content = catalogCellDataList
            self.loadingArtistsCatalogView.isHidden = true
            self.failedArtitstCatalogView.isHidden = true
            self.loadedArtistsCatalogView.isHidden = false
        case .loading:
            self.loadedArtistsCatalogView.content = []
            self.loadingArtistsCatalogView.isHidden = false
            self.failedArtitstCatalogView.isHidden = true
            self.loadedArtistsCatalogView.isHidden = true
        }
    }
    
    private func add(artistsCatalogSubview: UIView) {
        artistsCatalogSubview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(artistsCatalogSubview)
        NSLayoutConstraint.activate([
            artistsCatalogSubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            artistsCatalogSubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            artistsCatalogSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            artistsCatalogSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func reloadButtonDidTap() {
        self.reloadCatalog(artistsList: self.artistsService.artistsList)
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
    
    private func artistsCellDidTap(_ artistName: String) {
        let artistArtsViewController = ArtistArtsViewController()
        artistArtsViewController.artistName = artistName
        self.navigationController?.pushViewController(artistArtsViewController, animated: true)
    }
    
    private func loadParticularArtistCellDataIfNeeded(artistName: String) {
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
               if let contentStatus = self?.contentStatus,
               case .loaded(var artistsCellDataList) = contentStatus,
               let artistCellDataIndex = artistsCellDataList.firstIndex(where: { $0.artistName == artistCellData.artistName}) {
                   artistsCellDataList[artistCellDataIndex] = artistCellData
                self?.contentStatus = .loaded(artistsCellDataList)
            }
            self?.loadingArtistNames.removeAll { name in
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
                let subtitle: String = self.subtitle(objectsCount: objects.total)
                self.loadArtistImageURL(objectsIDs: objects.objectIDs) { url in
                    let artistCellData = FeaturedArtistsCellData(artistName: artistName, artistData: .data(imageURL: url, title: artistName, subTitle: subtitle))
                    completion(artistCellData)
                }
            }
        }
    }
    
        
    private func subtitle(objectsCount: Int) -> String {
        let formatString: String = NSLocalizedString("objects count", comment: "")
        return String.localizedStringWithFormat(formatString, objectsCount)
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
