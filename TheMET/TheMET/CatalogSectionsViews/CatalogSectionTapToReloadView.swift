//
//  CatalogSectionTapToReloadView.swift
//  TheMET
//
//  Created by Анна Ситникова on 03/11/2023.
//

import Foundation
import UIKit

class CatalogSectionTapToReloadView: UIView {
    
    private let textLabel: UILabel = UILabel()
    private let button: UIButton = UIButton()
    private let container: UIStackView = UIStackView()
    
    var onButtonTap: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.container)
        self.container.addArrangedSubview(self.textLabel)
        self.container.addArrangedSubview(self.button)
        self.container.axis = .vertical
        self.container.distribution = .fill
        self.container.alignment = .center
        self.container.spacing = 30
        NSLayoutConstraint.activate([
            self.container.heightAnchor.constraint(equalToConstant: 150),
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 45)
        ])
        NSLayoutConstraint.activate([
            self.button.heightAnchor.constraint(equalToConstant: 60),
            self.button.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -100)
        ])
        NSLayoutConstraint.activate([
            self.textLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func constractView(configuration: CatalogSectionTapToReloadConfiguration) -> CatalogSectionTapToReloadView {
        let view = CatalogSectionTapToReloadView()
        view.setup(configuration: configuration)
        return view
    }
    
    private func setup(configuration: CatalogSectionTapToReloadConfiguration) {
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .center
        self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 18, title: configuration.text)
        self.button.apply(radius: 30, backgroundColor: UIColor(named: "blueberry"), fontColor: UIColor(named: "pear"), font: NSLocalizedString("san_serif_font", comment: ""), fontSize: 20, buttonTitle: configuration.buttonTitle, image: nil)
        self.button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func buttonDidTap() {
        self.onButtonTap()
    }
}

struct CatalogSectionTapToReloadConfiguration {
    
    let text: String
    
    let buttonTitle: String
    
    static let catalogSectionTapToReload: CatalogSectionTapToReloadConfiguration = CatalogSectionTapToReloadConfiguration(text: NSLocalizedString("catalog_section.loading_failed", comment: ""), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
}
