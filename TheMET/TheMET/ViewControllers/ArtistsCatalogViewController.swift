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
    
    private var viewModel: ArtistsCatalogViewModel?
    
    private let loadingArtistsCatalogView = LoadingPlaceholderView.construstView(configuration: .catalogLoading)
    private let failedArtitstCatalogView = FailedPlaceholderView.constructView(configuration: .catalogFailed)
    private let loadedArtistsCatalogView = FeaturedArtistsContentView.constructView()
    
    private var loadedArtistsSubscriber: AnyCancellable?
    private var contentStatusSubscriber: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.add(artistsCatalogSubview: self.failedArtitstCatalogView)
        self.add(artistsCatalogSubview: self.loadedArtistsCatalogView)
        self.add(artistsCatalogSubview: self.loadingArtistsCatalogView)
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let viewModel = ArtistsCatalogViewModel { [weak self] in
            return self
        }
        self.viewModel = viewModel
        self.loadedArtistsSubscriber = viewModel.$loadedArtists
            .sink(receiveValue: { [weak self] newLoadedArtists in
                guard let self = self else {return}
                self.loadedArtistsCatalogView.content = newLoadedArtists
            })
        self.contentStatusSubscriber = viewModel.$contentStatus
            .sink(receiveValue: { [weak self] newContentStatus in
                guard let self = self else {return}
                switch newContentStatus {
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
            })
        self.failedArtitstCatalogView.onButtonTap = { [weak self] in
            self?.viewModel?.reloadButtonDidTap()
        }
        self.loadedArtistsCatalogView.onFeaturedArtistsCellTap = { [weak self] artistName in
            self?.viewModel?.artistsCellDidTap(artistName
            )
        }
        self.loadedArtistsCatalogView.onFeaturedArtistsCellWillDisplay = { [weak self] artistName in
            self?.viewModel?.loadParticularArtistCellDataIfNeeded(artistName: artistName)
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
    
}
