//
//  ArtistsSectionViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 13/11/2023.
//

import Foundation
import UIKit
import MetAPI
import Combine

class ArtistsSectionViewController: UIViewController {
    
    private var viewModel: ArtistsSectionViewModel?
    private var titleSubscriber: AnyCancellable?
    private var imageSubscriber: AnyCancellable?
    private var subtitleSubscriber: AnyCancellable?
    
    private let featuredArtistsLabel: UILabel = UILabel()

    private let featuredArtistsView = FeaturedArtistsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.featuredArtistsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(featuredArtistsLabel)
        self.featuredArtistsLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            self.featuredArtistsLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.featuredArtistsLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.featuredArtistsLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.featuredArtistsLabel.heightAnchor.constraint(equalToConstant: 60)
            ])
        self.featuredArtistsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.featuredArtistsView)
        NSLayoutConstraint.activate([
            self.featuredArtistsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.featuredArtistsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.featuredArtistsView.topAnchor.constraint(equalTo: self.featuredArtistsLabel.bottomAnchor, constant: 0),
            self.featuredArtistsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.featuredArtistsView.onViewTapped = { [weak self] in
            self?.viewModel?.featuredArtistsViewDidTap()
        }
        self.setUpViewModel()
    }
    
    private func setUpViewModel() {
        let viewModel = ArtistsSectionViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title.sink(receiveValue: { newTitle in
            self.featuredArtistsLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: newTitle)
        })
        self.imageSubscriber = viewModel.$image.sink(receiveValue: { newImage in
            guard let image = newImage else { return self.featuredArtistsView.image = nil }
            self.featuredArtistsView.image = image
        })
        self.subtitleSubscriber = viewModel.$subtitle.sink(receiveValue: { newSubtitle in
            self.featuredArtistsView.title = newSubtitle
        })
    }
    
}
