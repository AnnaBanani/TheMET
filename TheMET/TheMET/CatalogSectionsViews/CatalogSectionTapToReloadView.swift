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
            self.container.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        NSLayoutConstraint.activate([
            self.button.heightAnchor.constraint(equalToConstant: 60),
            self.button.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 50),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50)
        ])
        NSLayoutConstraint.activate([
            self.textLabel.heightAnchor.constraint(equalToConstant: 60),
            self.textLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 50),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func constractView() -> CatalogSectionTapToReloadView {
        let view = CatalogSectionTapToReloadView()
        view.textLabel.numberOfLines = 0
        view.textLabel.textAlignment = .center
        view.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 18, title: NSLocalizedString("catalog_section.loading_failed", comment: ""))
        view.button.apply(radius: 30, backgroundColor: UIColor(named: "blueberry"), fontColor: UIColor(named: "pear"), font: NSLocalizedString("san_serif_font", comment: ""), fontSize: 20, buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""), image: nil)
        view.button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        return view
    }
    
    @objc
    private func buttonDidTap() {
        self.onButtonTap()
    }
}
