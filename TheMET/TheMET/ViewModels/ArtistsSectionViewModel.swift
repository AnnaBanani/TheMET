//
//  ArtistsSectionViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 29/02/2024.
//

import Foundation
import UIKit
import Combine
import MetAPI

class ArtistsSectionViewModel {
    
    private let artistService = ArtistsService.standart
    
    private var artistsServiceSubscriber: AnyCancellable?
    
    @Published private(set) var title: String
    @Published private(set) var image: UIImage?
    @Published private(set) var subtitle: String
    
    private let presentingControllerProvider: () -> UIViewController?
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.title = NSLocalizedString("catalog_screen_feaured_artists_section_title", comment: "")
        self.image = UIImage(named: "FeaturedArtistsCover")
        self.presentingControllerProvider = presentingControllerProvider
        self.subtitle = ""
        self.artistsServiceSubscriber = self.artistService.$artistsList
            .sink(receiveValue: { [weak self] newArtistsList in
                let count = newArtistsList.count
                self?.subtitle = (self?.featuredArtistsViewTitle(artistsCount: count))!
                
            })
    }
    
    func featuredArtistsViewDidTap() {
        guard let presentingController = presentingControllerProvider() else {
            return
        }
        let artistsViewController = ArtistsCatalogViewController()
        presentingController.navigationController?.pushViewController(artistsViewController, animated: true)
    }
    
    private func featuredArtistsViewTitle(artistsCount: Int) -> String {
        let formatString: String = NSLocalizedString("artists count", comment: "")
        return String.localizedStringWithFormat(formatString, artistsCount)
    }
    
}

