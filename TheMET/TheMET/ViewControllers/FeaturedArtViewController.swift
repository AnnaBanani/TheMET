//
//  FeaturedArtViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit
import Combine

class FeaturedArtViewController: UIViewController {
    
    private let loadingFeaturedArtView = LoadingPlaceholderView.construstView(configuration: .featuredLoading)
    private let failedFeaturedArtView = FailedPlaceholderView.constructView(configuration: .featuredFailed)

    private let scrollView: UIScrollView = UIScrollView()

    private let artView: ArtView = ArtView()

    private let imageLoader = ImageLoader()

    private let favoriteService = FavoritesService.standart
    
    private var favoriteServiceSubscriber: AnyCancellable?

    private let featuredArtService = FeaturedArtService()
    
    private var featuredArtServiceSubscriber: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "FeaturedIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "FeaturedIconTapped")?.withRenderingMode(.alwaysOriginal))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("random_artwork_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.favoriteServiceSubscriber = self.favoriteService.$favoriteArts
            .sink(receiveValue: { [weak self] newFavoriteArts in
                self?.favoriteServiceDidChange(favoritesArts: newFavoriteArts)
        })
        self.add(featuredSubView: self.loadingFeaturedArtView)
        self.add(featuredSubView: self.failedFeaturedArtView)
        self.add(featuredSubView: self.scrollView)
        let contentGuide = self.scrollView.contentLayoutGuide
        self.scrollView.addSubview(self.artView)
        self.artView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.artView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.artView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.artView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.artView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentGuide.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        self.failedFeaturedArtView.onButtonTap = { [weak self] in
            self?.featuredArtService.forceUpdateFeaturedArt()
        }
        self.featuredArtServiceSubscriber = self.featuredArtService.$featuredArt
            .sink(receiveValue: { [weak self] newFeaturedArt in
                self?.displayFeaturedArt(newFeaturedArt)
            })
    }
    
    private func favoriteServiceDidChange(favoritesArts: [Art]) {
        guard case .loaded(let art) = self.featuredArtService.featuredArt else {
            return
        }
        guard favoritesArts.contains(where: { favoriteArt in
            return favoriteArt.objectID == art.objectID
        }) else {
            self.artView.isLiked = false
            return
        }
        self.artView.isLiked = true
    }

    private func add(featuredSubView: UIView) {
            featuredSubView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(featuredSubView)
            let constraints: [NSLayoutConstraint] = [
                featuredSubView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                featuredSubView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                featuredSubView.topAnchor.constraint(equalTo: self.view.topAnchor),
                featuredSubView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
    }

    private func displayFeaturedArt(_ featuredArt: LoadingStatus<Art>) {
        switch featuredArt {
        case .failed:
            self.failedFeaturedArtView.isHidden = false
            self.loadingFeaturedArtView.isHidden = true
            self.scrollView.isHidden = true
        case .loading:
            self.failedFeaturedArtView.isHidden = true
            self.loadingFeaturedArtView.isHidden = false
            self.scrollView.isHidden = true
        case .loaded(let art):
            if let urlString = art.primaryImage {
                self.artView.imageState = .loading
                self.imageLoader.loadImage(urlString: urlString) { [weak self] image in
                    guard let self = self else {
                      return
                    }
                    switch self.featuredArtService.featuredArt {
                    case .failed, .loading:
                        return
                    case .loaded(let currentArt):
                        guard art.objectID == currentArt.objectID else {
                            return
                        }
                        if let image = image {
                            self.artView.imageState = .loaded(image)
                        } else {
                            self.artView.imageState = .failed
                        }
                    }
                }
            } else {
                self.artView.imageState = .failed
            }
            if self.favoriteService.favoriteArts.contains(where: { favoriteArt in
                return favoriteArt.objectID == art.objectID
            }) {
                self.artView.isLiked = true
            } else {
                self.artView.isLiked = false
            }
            self.artView.artistNameText = String.artistNameText(art: art)
            self.artView.titleText = String.titleText(art: art)
            self.artView.dateText = String.dateText(art: art)
            self.artView.mediumText = String.mediumText(art: art)
            self.artView.onLikeButtonDidTap = { [weak self] in
                self?.likeButtonDidTap(art: art)
            }
            self.artView.onImageDidTap = { [weak self] image in
                self?.imageDidTap(image: image)
            }
//            TODO tags
            self.failedFeaturedArtView.isHidden = true
            self.loadingFeaturedArtView.isHidden = true
            self.scrollView.isHidden = false
        }
    }

    private func likeButtonDidTap(art: Art) {
        if self.artView.isLiked {
            self.favoriteService.removeArt(id: art.objectID)
        } else {
            self.favoriteService.addFavoriteArt(art)
        }
    }
    
    private func imageDidTap(image: UIImage) {
        let fullScreenViewController = FullScreenPhotoViewController()
        fullScreenViewController.modalPresentationStyle = .fullScreen
        fullScreenViewController.image = image
        self.present(fullScreenViewController, animated: true)
    }

}
