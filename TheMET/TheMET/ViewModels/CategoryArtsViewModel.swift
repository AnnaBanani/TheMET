//
//  CategoryArtsViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/03/2024.
//

import Foundation
import UIKit
import Combine
import MetAPI

enum CategoryArtState {
    
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

class CategoryArtsViewModel {
    
    @Published private(set) var categoryArtStatesList: LoadingStatus<[CategoryArtState]>
    @Published private(set) var searchText: String
    private let presentingControllerProvider: () -> UIViewController?
    
    private var categoryArtList: [CategoryArtState] = []
    
    private let metAPI = MetAPI()
    
    private var imageLoader: ImageLoader = ImageLoader()
    
    private let favoriteService = FavoritesService.standart
    
    private var favoriteServiseSubscriber: AnyCancellable?
    
    private var departmentId: Int?
    private var loadingArtIds: [ArtID] = []
    private var loadedArts:[Art] = []
    private var artsWithImageLoading:[Int] = []
    
    init(presentingControllerProvider: @escaping () -> UIViewController?, departmentID: Int?) {
        self.categoryArtStatesList = .loading
        self.searchText = ""
        self.presentingControllerProvider = presentingControllerProvider
        self.favoriteServiseSubscriber = self.favoriteService.$favoriteArts
            .sink(receiveValue: { [weak self] newFavoriteArts in
                self?.favoriteServiceDidChange(newFavoriteArts: newFavoriteArts)
            })
        self.departmentId = departmentID
        self.reloadCategory()
    }
    
    private func favoriteServiceDidChange(newFavoriteArts: [Art]) {
        switch self.categoryArtStatesList {
        case .loaded(let oldArtStates):
            var newArtStates: [CategoryArtState] = []
            for artState in oldArtStates {
                let newArtState: CategoryArtState
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
            self.categoryArtStatesList = .loaded(newArtStates)
        case .loading, .failed:
            return
        }
    }
    
    func reloadButtonDidTap() {
        self.reloadCategory()
    }
    
    func searchTextDidChange(searchText: String) {
        self.searchText = searchText
        self.reloadCategory()
    }
    
    private func reloadCategory() {
        self.categoryArtStatesList = .loading
        self.loadArtCellDataList()
    }
    
    private func loadArtCellDataList() {
        guard let id = self.departmentId else {
            self.categoryArtStatesList = .failed(CategoryViewControllerError.departmentIdNotFound)
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
                self.loadSearchResponse(searchTextBeforeLoading: searchTextBeforeLoading, departmentId: id)
            } else {
                self.loadObjects(departmentId: id)
            }
        })
    }
    
    func artWillBeDisplayed(artState: CategoryArtState.LoadedArtState) {
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
        switch self.categoryArtStatesList {
        case .loaded(let statesList):
            if let index = statesList.firstIndex(where: { categoryArtState in
                switch categoryArtState {
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
                    var newArts: [CategoryArtState] = statesList
                    newArts[index] = loadedArt
                    self.categoryArtStatesList = .loaded(newArts)
                }
            }
        case .loading, .failed:
            return
        }
        self.artsWithImageLoading.removeAll(where: { $0 == artID })
    }
    
    func artWillBeDisplayed(categoryArtState: CategoryArtState) {
        guard case .placeholder(let artID) = categoryArtState,
              !self.loadingArtIds.contains(artID) else { return }
        self.loadingArtIds.append(artID)
        self.loadArtCellData(artID: artID) { [weak self] categoryCellData in
            if let categoryCellData = categoryCellData,
               let contentStatus = self?.categoryArtStatesList,
               case .loaded(var categoryStatesList) = contentStatus,
               let artCellDataIndex = categoryStatesList.firstIndex(where: { categoryArtState in
                   switch categoryArtState {
                   case .placeholder(let placeholderArtID):
                       return placeholderArtID == artID
                   case .loaded(let artState):
                       return artState.objectID == artID
                   }
               }) {
                categoryStatesList[artCellDataIndex] = categoryCellData
                self?.categoryArtStatesList = .loaded(categoryStatesList)
            }
            self?.removeLoadingArtId(artId: artID)
        }
    }
    
    private func loadArtCellData(artID: ArtID, completion: @escaping (CategoryArtState?) -> Void) {
        self.metAPI.object(id: artID) {objectResult in
            switch objectResult {
            case .failure:
                completion(nil)
            case .success(let object):
                self.loadedArts.append(object)
                let artCellData = CategoryArtState.loaded(
                    artState: CategoryArtState.LoadedArtState(
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
    
    private func isArtLiked(artId: ArtID) -> Bool {
        return self.favoriteService.favoriteArts.contains(where: { favoriteArt in
            return favoriteArt.objectID == artId
        })
    }
    
    private func removeLoadingArtId(artId: ArtID) {
        self.loadingArtIds.removeAll { id in
            return id == artId
        }
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
    
    private func loadObjects(departmentId: Int) {
        self.metAPI.objects(departmentIds: [departmentId]) { [weak self] objectsResponseResult in
            guard let self = self,
                  self.searchText == "" else {
                return
            }
            switch objectsResponseResult {
            case .failure(let error):
                self.categoryArtStatesList = .failed(error)
            case.success(let objectsResponse):
                let  artCellDataList = self.handleLoadingResponse(objectIDs: objectsResponse.objectIDs)
                self.categoryArtList = artCellDataList
                self.categoryArtStatesList = .loaded(artCellDataList)
            }
        }
    }
    
    private func loadSearchResponse(searchTextBeforeLoading: String, departmentId: Int) {
        let parameters:[SearchParameter] = [
            .departmentId(departmentId),
            .q(searchTextBeforeLoading)
        ]
        self.metAPI.search(parameters: parameters) { [weak self] searchResponseResult in
            guard let self = self else { return }
            guard searchTextBeforeLoading == self.searchText else {
                return
            }
            switch searchResponseResult {
            case . failure:
                self.categoryArtStatesList = .failed(ArtsLoadingError.noSearchResult)
            case .success(let searchResponse):
                let filteredArtCellDataList = self.filterArtCellDataList(objectIDs: searchResponse.objectIDs)
                self.categoryArtStatesList = .loaded(filteredArtCellDataList)
            }
        }
    }
    
    private func filterArtCellDataList(objectIDs: [ArtID]) -> [CategoryArtState] {
        var filteredArtCellDataList: [CategoryArtState] = []
        for artID in objectIDs {
            if self.categoryArtList.contains(where: { categoryArtState in
                switch categoryArtState {
                case .placeholder(let placeholderArtID):
                    return placeholderArtID == artID
                case .loaded(let artState):
                    return artState.objectID == artID
                }
            }) {
                let filteredArtCellData = CategoryArtState.placeholder(artID: artID)
                filteredArtCellDataList.append(filteredArtCellData)
            }
        }
        return filteredArtCellDataList
    }
    
    private func handleLoadingResponse(objectIDs: [ArtID]) -> [CategoryArtState] {
        var filteredArtCellDataList: [CategoryArtState] = []
        for artId in objectIDs {
            let filteredArtCellData  = CategoryArtState.placeholder(artID: artId)
            filteredArtCellDataList.append(filteredArtCellData)
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
    
}
