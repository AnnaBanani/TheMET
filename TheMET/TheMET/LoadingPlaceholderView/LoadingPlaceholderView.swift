//
//  LoadingPlaceholderView.swift
//  TheMET
//
//  Created by Анна Ситникова on 08/08/2023.
//

import Foundation
import UIKit

class LoadingPlaceholderView: UIView {
    
    private let textLabel: UILabel = UILabel()
    private let animationView: ArtsLoadingIndicatorView = ArtsLoadingIndicatorView()
    
    static func construstView(configuration: LoadingPlaceholderConfiguration) -> LoadingPlaceholderView {
        let view = LoadingPlaceholderView()
        view.setup(configuration: configuration)
        return view
    }
    
    private func setup(configuration: LoadingPlaceholderConfiguration) {
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .center
        self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 18, title: configuration.text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.animationView)
        self.addSubview(self.textLabel)
        NSLayoutConstraint.activate([
            self.animationView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            self.animationView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            ])
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: self.animationView.bottomAnchor),
            self.textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct LoadingPlaceholderConfiguration {
    
    let text: String
    
    static let featuredLoading: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("featured_artwork.loading", comment: ""))
        static let catalogLoading: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("category_artworks.loading", comment: ""))
        static let categoryArtworksLoading: LoadingPlaceholderConfiguration =  LoadingPlaceholderConfiguration(text: NSLocalizedString("category_artworks.loading", comment: ""))
}
