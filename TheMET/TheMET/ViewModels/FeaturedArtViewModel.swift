//
//  FeaturedArtViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 05/02/2024.
//

import Foundation
import UIKit
import Combine
import MetAPI

struct FeaturedArtState {
    fileprivate let objectID: Int
    let imageStatus: LoadingStatus<UIImage>
    let artistsName: String
    let titleText: String
    let dateText: String
    let mediumText: String
    let isLiked: Bool
}

class FeaturedArtViewModel {
    @Published private(set) var title: String
    @Published private(set) var artState: LoadingStatus<FeaturedArtState>
    
    private let imageLoader = ImageLoader()
    
    private let presentingControllerProvider: () -> UIViewController?
    
    private let favoriteService = FavoritesService.standart
    
    private var favoriteServiceSubscriber: AnyCancellable?
    
    private let featuredArtService = FeaturedArtService()
    
    private var featuredArtServiceSubscriber: AnyCancellable?
    
    private var currentlyDisplayedArt: Art?
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.presentingControllerProvider = presentingControllerProvider
        self.title = NSLocalizedString("random_artwork_screen_title", comment: "")
        self.artState = .loading
        self.favoriteServiceSubscriber = self.favoriteService.$favoriteArts
            .sink(receiveValue: { [weak self] newFavoriteArts in
                self?.favoriteServiceDidChange(favoritesArts: newFavoriteArts)
            })
        self.featuredArtServiceSubscriber = self.featuredArtService.$featuredArt
            .sink(receiveValue: { [weak self] newFeaturedArt in
                self?.setUpFeaturedArt(newFeaturedArt)
            })
    }
  
    private func setUpFeaturedArt(_ featuredArt: LoadingStatus<Art>) {
        switch featuredArt {
        case .failed(let error):
            self.currentlyDisplayedArt = nil
            self.artState = .failed(error)
        case .loading:
            self.currentlyDisplayedArt = nil
            self.artState = .loading
        case .loaded(let art):
            let imageStatus: LoadingStatus<UIImage>
            if let urlString = art.primaryImage {
                imageStatus = .loading
                self.imageLoader.loadImage(urlString: urlString) { [weak self] image in
                    self?.imageDidLoad(image: image, art: art)
                }
            } else {
                imageStatus = .failed(ArtImageLoadingError.invalidImageURL)
            }
            let isLiked: Bool = self.favoriteService.favoriteArts.contains(where: { favoriteArt in
                return favoriteArt.objectID == art.objectID
            })
            let newState = FeaturedArtState(
                objectID: art.objectID,
                imageStatus: imageStatus,
                artistsName: String.artistNameText(art: art),
                titleText: String.titleText(art: art),
                dateText: String.dateText(art: art),
                mediumText: String.mediumText(art: art),
                isLiked: isLiked
            )
            self.currentlyDisplayedArt = art
            self.artState = .loaded(newState)
        }
    }
    
    private func imageDidLoad(image: UIImage?, art: Art) {
        switch self.featuredArtService.featuredArt {
        case .failed, .loading:
            return
        case .loaded(let currentArt):
            guard art.objectID == currentArt.objectID else {
                return
            }
            switch self.artState {
            case .loaded(let currentDisplayedData):
                guard currentDisplayedData.objectID == art.objectID else { return }
                let imageStatus: LoadingStatus<UIImage>
                if let image = image {
                    imageStatus = .loaded(image)
                } else {
                    imageStatus = .failed(ArtImageLoadingError.imageCannotBeLoadedFromURL)
                }
                let newState = FeaturedArtState(
                    objectID: art.objectID,
                    imageStatus: imageStatus,
                    artistsName: currentDisplayedData.artistsName,
                    titleText: currentDisplayedData.titleText,
                    dateText: currentDisplayedData.dateText,
                    mediumText: currentDisplayedData.mediumText,
                    isLiked: currentDisplayedData.isLiked
                )
                self.artState = .loaded(newState)
            case .loading:
                break
            case .failed:
                break
            }
        }
    }
    
   func likeButtonDidTap() {
       guard let currentlyDisplayedArt = self.currentlyDisplayedArt else {
           return
       }
       switch self.artState {
       case .loaded(let currentDisplayedData):
           if currentDisplayedData.isLiked {
               self.favoriteService.removeArt(id: currentDisplayedData.objectID)
           } else {
               self.favoriteService.addFavoriteArt(currentlyDisplayedArt)
           }
       case .loading:
           break
       case .failed:
           break
       }
    }
    
   func imageDidTap() {
       let image: UIImage
       switch self.artState {
       case .loaded(let currentDisplayedData):
           switch currentDisplayedData.imageStatus {
           case .failed:
               return
           case .loading:
               return
           case .loaded(let displayedImage):
               image = displayedImage
           }
       case .loading:
           return
       case .failed:
           return
       }
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        let fullScreenViewController = FullScreenPhotoViewController()
        fullScreenViewController.modalPresentationStyle = .fullScreen
        fullScreenViewController.image = image
        presentingController.present(fullScreenViewController, animated: true)
    }

   func favoriteServiceDidChange(favoritesArts: [Art]) {
        guard case .loaded(let art) = self.featuredArtService.featuredArt else {
            return
        }
        guard favoritesArts.contains(where: { favoriteArt in
            return favoriteArt.objectID == art.objectID
        }) else {
            self.setDisplayedLike(to: false)
            return
        }
       self.setDisplayedLike(to: true)
    }
    
    private func setDisplayedLike(to isLiked: Bool) {
        switch self.artState {
        case .loaded(let currentDisplayedData):
            let newState = FeaturedArtState(
                objectID: currentDisplayedData.objectID,
                imageStatus: currentDisplayedData.imageStatus,
                artistsName: currentDisplayedData.artistsName,
                titleText: currentDisplayedData.titleText,
                dateText: currentDisplayedData.dateText,
                mediumText: currentDisplayedData.mediumText,
                isLiked: isLiked
            )
            self.artState = .loaded(newState)
        case .loading:
            break
        case .failed:
            break
        }
    }
}


enum FeaturedArtLoadingError: Error {
    case imageCannotBeLoadedFromURL
    case invalidImageURL
}
