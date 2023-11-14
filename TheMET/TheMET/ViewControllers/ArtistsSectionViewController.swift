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
    
    private let artistService = ArtistsService.standart
    
    private var artistsServiceSubscriber: AnyCancellable?
    
    private let featuredArtistsLabel: UILabel = UILabel()

    private let featuredArtistsView = FeaturedArtistsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.featuredArtistsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(featuredArtistsLabel)
        self.featuredArtistsLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: NSLocalizedString("catalog_screen_feaured_artists_section_title", comment: ""))
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
            self?.featuredArtistsViewDidTap()
        }
        self.artistsServiceSubscriber = self.artistService.$artistsList
            .sink(receiveValue: { [weak self] newArtistsList in
                let count = newArtistsList.count
                self?.featuredArtistsView.title = self?.featuredArtistsViewTitle(artistsCount: count)
            })
    }
    
    private func featuredArtistsViewDidTap() {
        let artistsViewController = ArtistsCatalogViewController()
        self.navigationController?.pushViewController(artistsViewController, animated: true)
    }
    
    private func featuredArtistsViewTitle(artistsCount: Int) -> String {
        let formatString: String = NSLocalizedString("artists count", comment: "")
        return String.localizedStringWithFormat(formatString, artistsCount)
    }
    
}
