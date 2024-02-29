//
//  FavoritesViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/02/2024.
//

import Foundation
import UIKit
import Combine
import MetAPI

enum FavoritesLoadingError: Error {
    case searchFailed
    case imageNotLoaded
}

struct FavoriteArtState {
    var objectID: Int
    fileprivate(set) var imageStatus: LoadingStatus<UIImage>
    let artistsName: String?
    let titleText: String?
    let dateText: String?
    let mediumText: String?
}

class FavoritesViewModel {
    @Published private(set) var title: String
    @Published private(set) var artStates: LoadingStatus<[FavoriteArtState]>
    
    private var lastSearchedText: String = ""
    
    private var artsWithImageLoading:[Int] = []
    
    private let presentingControllerProvider: () -> UIViewController?
    
    private let artFilter : ArtFilter = ArtFilter()
    
    private var displayArts: [Art] = []
    
    private var allFavoriteArts: [Art] = []
    
    private let favoriteService = FavoritesService.standart
    
    private var favoriteServiseSubscriber: AnyCancellable?
    
    private let imageLoader = ImageLoader()
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.title = NSLocalizedString("favories_screen_title", comment: "")
        self.artStates = .loading
        self.presentingControllerProvider = presentingControllerProvider
        self.favoriteServiseSubscriber = self.favoriteService.$favoriteArts
            .sink(receiveValue: { [weak self] newFavoriteArts in
                self?.favoriteServiceDidChange(favoriteArts: newFavoriteArts)
            })
    }
    
    private func favoriteServiceDidChange(favoriteArts: [Art]) {
        self.allFavoriteArts = favoriteArts
        self.displayArts = self.artFilter.filter(arts: favoriteArts, searchText: self.lastSearchedText)
        self.mapDisplyedArts(arts: self.displayArts)
    }
    
    func artWillBeDisplayed(art: FavoriteArtState) {
        switch art.imageStatus {
        case .loaded:
            return
        case .failed, .loading:
            self.loadImageIfNeeded(for: art.objectID)
        }
    }
    
    private func loadImageIfNeeded(for artID: Int) {
        guard !self.artsWithImageLoading.contains(artID) else { return }
        guard let loadingArt = self.allFavoriteArts.first (where: { art in
            art.objectID == artID
        }),
              let imageUrl = loadingArt.primaryImage else { return }
        self.artsWithImageLoading.append(artID)
        self.imageLoader.loadImage(urlString: imageUrl) { [weak self] image in
            self?.imageDidLoad(artID: artID, image: image)
        }
    }
    
    private func imageDidLoad(artID: Int, image: UIImage?) {
        let imageStatus: LoadingStatus<UIImage>
        if let image = image {
            imageStatus = .loaded(image)
        } else {
            imageStatus = .failed(FavoritesLoadingError.imageNotLoaded)
        }
        switch self.artStates {
        case .loaded(let favoriteArtStates):
            if let index = favoriteArtStates.firstIndex(where: { $0.objectID == artID }) {
                var favoriteArt = favoriteArtStates[index]
                favoriteArt.imageStatus = imageStatus
                var newArts: [FavoriteArtState] = favoriteArtStates
                newArts[index] = favoriteArt
                self.artStates = .loaded(newArts)
            }
        case .loading, .failed:
            return
        }
        self.artsWithImageLoading.removeAll(where: { $0 == artID })
    }
    
    func imageDidTap(image: UIImage) {
        guard let presentingController = self.presentingControllerProvider() else {return}
        let fullScreenViewController =  FullScreenPhotoViewController()
        fullScreenViewController.modalPresentationStyle = .fullScreen
        fullScreenViewController.image = image
        presentingController.present(fullScreenViewController, animated: true)
    }
    
    func onLikeButtonDidTap(id: Int) {
        self.favoriteService.removeArt(id: id)
    }
    
    func searchTextDidChange(searchText: String) {
        self.lastSearchedText = searchText
        guard !searchText.isEmpty else {
            self.mapDisplyedArts(arts: self.favoriteService.favoriteArts)
            return
        }
        self.displayArts = self.artFilter.filter(arts: self.favoriteService.favoriteArts, searchText: searchText)
        guard !self.displayArts.isEmpty else {
            self.artStates = .failed(FavoritesLoadingError.searchFailed)
            return
        }
        self.mapDisplyedArts(arts: self.displayArts)
    }
    
    private func mapDisplyedArts(arts: [Art]) {
        let displayArts: [FavoriteArtState] = arts.map { art in
            return FavoriteArtState(
                objectID: art.objectID,
                imageStatus: .loading,
                artistsName: art.artistDisplayName,
                titleText: art.title,
                dateText: art.objectDate,
                mediumText: art.medium
            )
        }
        self.artStates = .loaded(displayArts)
    }
}
