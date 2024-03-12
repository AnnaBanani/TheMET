//
//  CultureArtsViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 01/03/2024.
//

import Foundation
import UIKit
import Combine
import MetAPI

enum CultureArtState {
    
    struct LoadedArtState {
        let objectID: Int
        let artistsName: String?
        let titleText: String?
        let dateText: String?
        let mediumText: String?
        var isLiked: Bool
        fileprivate(set) var imageStatus: LoadingStatus<UIImage>
    }
    
    case placeholder(artID: ArtID)
    case loaded(artState: LoadedArtState)
}

class CultureArtsViewModel {
    
    @Published private(set) var cultureArtStatesList: LoadingStatus<[CultureArtState]>
    @Published private(set) var searchText: String
    private let presentingControllerProvider: () -> UIViewController?
    
    private let metAPI = MetAPI()
    
    private var imageLoader: ImageLoader = ImageLoader()
    
    private let favoriteService = FavoritesService.standart
    
    private var favoriteServiseSubscriber: AnyCancellable?
    
    private let culture: String?
    
    private var loadingArtIds: [ArtID] = []
    
    private var cultureArtsList: [CultureArtState] = []
    
    private var isSearchFailed: Bool = false
    
    private let departmentIDs: [Int] = [11, 15, 21]
    
    private var artsWithImageLoading:[Int] = []
    
    private var loadedArts:[Art] = []
    
    init(culture: String?, presentingControllerProvider: @escaping () -> UIViewController?) {
        self.cultureArtStatesList = .loading
        self.presentingControllerProvider = presentingControllerProvider
        self.searchText = ""
        self.culture = culture
        self.favoriteServiseSubscriber = self.favoriteService.$favoriteArts
            .sink(receiveValue: { [weak self] newFavoriteArts in
                self?.favoriteServiceDidChange(newFavoriteArts: newFavoriteArts)
            })
    }
    private func favoriteServiceDidChange(newFavoriteArts: [Art]) {
        
        switch self.cultureArtStatesList {
        case .loaded(let oldArtStates):
            var newArtStates: [CultureArtState] = []
            for artState in oldArtStates {
                let newArtState: CultureArtState
                switch artState {
                case .placeholder:
                    newArtState = artState
                case .loaded(var loadedArtState):
                    if newFavoriteArts.contains(where: ({art in
                        art.objectID == loadedArtState.objectID
                    })) {
                        loadedArtState.isLiked = true
                    }  else {
                        loadedArtState.isLiked = false
                    }
                    newArtState = .loaded(artState: loadedArtState)
                }
                newArtStates.append(newArtState)
            }
            self.cultureArtStatesList = .loaded(newArtStates)
        case .loading, .failed:
            return
        }
    }
    
    func reloadButtonDidTap() {
        self.reloadCategory()
    }
    
    func reloadCategory() {
        self.cultureArtStatesList = .loading
        self.loadArtCellDataList()
    }
    
    private func loadArtCellDataList() {
        guard let culture = self.culture else {
            self.cultureArtStatesList = .failed(CultureArtsLoadingError.cultureNameNotFound)
            return
        }
        let searchTextBeforeWaiting = self.searchText
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] () -> Void in
            guard let self = self,
                  searchTextBeforeWaiting == self.searchText else {
                return
            }
            let searchTextBeforeLoading = self.searchText
            if !searchTextBeforeLoading.isEmpty {
                self.loadSearchResponse(searchTextBeforeLoading: searchTextBeforeLoading, culture: culture)
            } else {
                self.loadObjects(culture: culture)
            }
        })
    }
    
    private func loadObjects(culture: String) {
        let parameters:[SearchParameter] = [
            .artistOrCulture(true),
            .q(culture)
        ]
        self.metAPI.search(parameters: parameters) { [weak self] searchResponseResult in
            guard let self = self else { return }
            switch searchResponseResult {
            case . failure(let error):
                self.cultureArtStatesList = .failed(error)
            case .success(let searchResponse):
                let artCellDataList = self.handleLoadingResponse(objectIDs: searchResponse.objectIDs)
                self.cultureArtsList = artCellDataList
                self.cultureArtStatesList = .loaded(artCellDataList)
            }
        }
    }
    
    private func loadSearchResponse(searchTextBeforeLoading: String, culture: String) {
        let parameters:[SearchParameter] = [
            .title(true),
            .q(searchTextBeforeLoading)
        ]
        self.metAPI.search(parameters: parameters) { [weak self] searchResponseResult in
            guard let self = self else { return }
            guard searchTextBeforeLoading == self.searchText else {
                return
            }
            switch searchResponseResult {
            case . failure:
                self.cultureArtStatesList = .failed(ArtsLoadingError.noSearchResult)
            case .success(let searchResponse):
                let filteredArtCellDataList = self.filterArtCellDataList(objectIDs: searchResponse.objectIDs)
                print ("search text \(searchTextBeforeLoading) search responce success \(filteredArtCellDataList.count)")
                self.cultureArtStatesList = .loaded(filteredArtCellDataList)
            }
        }
    }
    
    private func handleLoadingResponse(objectIDs: [ArtID]) -> [CultureArtState] {
        var filteredArtCellDataList: [CultureArtState] = []
        for artId in objectIDs {
            let filteredArtCellData = CultureArtState.placeholder(artID: artId)
            filteredArtCellDataList.append(filteredArtCellData)
        }
        return filteredArtCellDataList
    }
    
    private func filterArtCellDataList(objectIDs: [ArtID]) -> [CultureArtState] {
        var filteredArtCellDataList: [CultureArtState] = []
        for artID in objectIDs {
            if self.cultureArtsList.contains(where: { cultureArtState in
                switch cultureArtState {
                case .placeholder(let placeholderArtID):
                    return placeholderArtID == artID
                case .loaded(let artState):
                    return artState.objectID == artID
                }
            }) {
                let filteredArtCellData = CultureArtState.placeholder(artID: artID)
                filteredArtCellDataList.append(filteredArtCellData)
            }
        }
        return filteredArtCellDataList
    }
    
    func imageDidTap(image: UIImage) {
        guard let presentingController = self.presentingControllerProvider() else { return }
        let fullScreenViewController =  FullScreenPhotoViewController()
        fullScreenViewController.modalPresentationStyle = .fullScreen
        fullScreenViewController.image = image
        presentingController.present(fullScreenViewController, animated: true)
    }
    
    private func loadArtCellData(artID: ArtID, completion: @escaping (CultureArtState?) -> Void) {
        self.metAPI.object(id: artID) {objectResult in
            switch objectResult {
            case .failure:
                completion(nil)
            case .success(let object):
                self.loadedArts.append(object)
                let artCellData = CultureArtState.loaded(
                    artState: CultureArtState.LoadedArtState(
                        objectID: artID,
                        artistsName: object.artistDisplayName,
                        titleText: object.title,
                        dateText: object.objectDate,
                        mediumText: object.medium,
                        isLiked: self.isArtLiked(artId: object.objectID),
                        imageStatus: .loading
                    )
                )
                completion(artCellData)
            }
        }
    }
    
    func artWillBeDisplayed(artState: CultureArtState.LoadedArtState) {
        if case .loaded = artState.imageStatus {
            return
        }
        let artID = artState.objectID
        guard !self.artsWithImageLoading.contains(artID) else { return }
        if let art = self.loadedArts.first(where: {$0.objectID == artID}) {
            guard let imageURL = art.primaryImage else {
                return
            }
            self.artsWithImageLoading.append(art.objectID)
            self.imageLoader.loadImage(urlString: imageURL) { [weak self] image in
                self?.imageDidLoad(artID: art.objectID, image: image)
                
            }
        }
    }
    
    private func imageDidLoad(artID: Int, image: UIImage?) {
        let imageStatus: LoadingStatus<UIImage>
        if let image = image {
            imageStatus = .loaded(image)
        } else {
            imageStatus = .failed(FavoritesLoadingError.imageNotLoaded)
        }
        switch self.cultureArtStatesList {
        case .loaded(let statesList):
            if let index = statesList.firstIndex(where: { cultureArtState in
                switch cultureArtState {
                case .placeholder(let placeholderArtID):
                    return placeholderArtID == artID
                case .loaded(let artState):
                    return artState.objectID == artID
                }
            }) {
                var loadedArt = statesList[index]
                switch loadedArt{
                case .placeholder:
                    break
                case .loaded(var loadedArtState):
                    loadedArtState.imageStatus = imageStatus
                    loadedArt = .loaded(artState: loadedArtState)
                    var newArts: [CultureArtState] = statesList
                    newArts[index] = loadedArt
                    self.cultureArtStatesList = .loaded(newArts)
                }
            }
        case .loading, .failed:
            return
        }
        self.artsWithImageLoading.removeAll(where: { $0 == artID })
    }
    
    private func removeLoadingArtId(artId: ArtID) {
        self.loadingArtIds.removeAll { id in
            return id == artId
        }
    }
    
    private func isArtLiked(artId: ArtID) -> Bool {
        return self.favoriteService.favoriteArts.contains(where: { favoriteArt in
            return favoriteArt.objectID == artId
        })
    }
    
    func likeButtonDidTap(artID: ArtID) {
        if self.favoriteService.favoriteArts.contains(where: { $0.objectID == artID }) {
            self.favoriteService.removeArt(id: artID)
        } else {
            if let art = self.loadedArts.first(where: {$0.objectID == artID}) {
                self.favoriteService.addFavoriteArt(art)
            }
        }
    }
    
    func tableViewWillDisplay(cultureArtState: CultureArtState) {
        guard case .placeholder(let artID) = cultureArtState,
              !self.loadingArtIds.contains(artID) else { return }
        self.loadingArtIds.append(artID)
        self.loadArtCellData(artID: artID) { [weak self] cultureCellData in
            if let cultureCellData = cultureCellData,
               let contentStatus = self?.cultureArtStatesList,
               case .loaded(var cultureStatesList) = contentStatus,
               let artCellDataIndex = cultureStatesList.firstIndex(where: { cultureArtState in
                   switch cultureArtState {
                   case .placeholder(let placeholderArtID):
                       return placeholderArtID == artID
                   case .loaded(let artState):
                       return artState.objectID == artID
                   }
               }) {
                cultureStatesList[artCellDataIndex] = cultureCellData
                self?.cultureArtStatesList = .loaded(cultureStatesList)
            }
            self?.removeLoadingArtId(artId: artID)
        }
    }
    
}
