//
//  CatalogSectionLoadingView.swift
//  TheMET
//
//  Created by Анна Ситникова on 03/11/2023.
//

import Foundation
import UIKit

class CatalogSectionLoadingView: UIView {
    
    private let textLabel: UILabel = UILabel()
    private let animationView: ArtsLoadingIndicatorView = ArtsLoadingIndicatorView()
    private let container: UIStackView = UIStackView()
    
    static func constractView (configuration: CatalogSectionLoadingConfiguration) -> CatalogSectionLoadingView {
        let view = CatalogSectionLoadingView()
        view.setup(configuration: configuration)
        return view
    }
    
    private func setup(configuration: CatalogSectionLoadingConfiguration) {
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .left
        self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 16, title: configuration.text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.container)
        self.container.addArrangedSubview(self.animationView)
        self.container.addArrangedSubview(self.textLabel)
        self.container.axis = .horizontal
        self.container.distribution = .fill
        self.container.alignment = .center
        self.container.spacing = 40
        NSLayoutConstraint.activate([
            self.container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.container.heightAnchor.constraint(equalToConstant: 150),
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            self.container.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -50),
            ])
        NSLayoutConstraint.activate([
            self.animationView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CatalogSectionLoadingConfiguration {
    
    let text: String
    
    static let catalogSectionLoading: CatalogSectionLoadingConfiguration = CatalogSectionLoadingConfiguration(text: NSLocalizedString("category_artworks.loading", comment: ""))
}
