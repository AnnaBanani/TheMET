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
    
    private var viewModel: FeaturedArtViewModel?
    
    private let loadingFeaturedArtView = LoadingPlaceholderView.construstView(configuration: .featuredLoading)
    private let failedFeaturedArtView = FailedPlaceholderView.constructView(configuration: .featuredFailed)
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let artView: ArtView = ArtView()
    
    private var titleSubscriber:AnyCancellable?
    private var artStateSubscriber:AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "FeaturedIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "FeaturedIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: "", color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
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
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let viewModel = FeaturedArtViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title.sink(receiveValue: { [weak self] newTitle in
            self?.title = newTitle
        })
        self.artStateSubscriber = viewModel.$artState.sink(receiveValue: { [weak self] newState in
            guard let self = self else { return }
            switch newState {
            case .failed:
                self.failedFeaturedArtView.isHidden = false
                self.loadingFeaturedArtView.isHidden = true
                self.scrollView.isHidden = true
            case .loading:
                self.failedFeaturedArtView.isHidden = true
                self.loadingFeaturedArtView.isHidden = false
                self.scrollView.isHidden = true
            case .loaded(let artState):
                self.failedFeaturedArtView.isHidden = true
                self.loadingFeaturedArtView.isHidden = true
                self.scrollView.isHidden = false
                self.artView.imageState = artState.imageStatus
                self.artView.artistNameText = artState.artistsName
                self.artView.titleText = artState.titleText
                self.artView.dateText = artState.dateText
                self.artView.mediumText = artState.mediumText
                self.artView.isLiked = artState.isLiked
            }
        })
        self.artView.onLikeButtonDidTap = {[weak self] in
            self?.viewModel?.likeButtonDidTap()
        }
        self.artView.onImageDidTap = { [weak self] _ in
            self?.viewModel?.imageDidTap()
        }
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
    
}
