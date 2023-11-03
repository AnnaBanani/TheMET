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
    
    static func constractView () -> CatalogSectionLoadingView {
        let view = CatalogSectionLoadingView()
        view.textLabel.numberOfLines = 0
        view.textLabel.textAlignment = .left
        view.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 16, title: NSLocalizedString("category_artworks.loading", comment: ""))
        return view
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
            self.container.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        NSLayoutConstraint.activate([
            self.animationView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            self.animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
