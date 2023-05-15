//
//  CatalogCell.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/05/2023.
//

import Foundation
import UIKit

class CatalogCell: UICollectionViewCell {
    
    private let imageView: LoadingImageView = LoadingImageView()
    private let cardsTitleLabel: UILabel = UILabel()
    private let cardsSubTitleLabel: UILabel = UILabel()
    private let gradientView: VerticalGradientView = VerticalGradientView()
    
    var title: String? {
        get {
            return self.cardsTitleLabel.attributedText?.string
        }
        set {
            self.reapplyTitleStyle(text: newValue)
        }
    }
    var subtitle: String? {
        get {
            return self.cardsSubTitleLabel.text
        }
        set {
            self.reapplySubTitleStyle(text: newValue)
        }
    }
    var backgroundState: LoadingImageView.State {
        get {
            return self.imageView.state
        }
        set {
            self.imageView.state = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.cardsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cardsSubTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.gradientView)
        self.contentView.addSubview(self.cardsTitleLabel)
        self.contentView.addSubview(self.cardsSubTitleLabel)
        
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.gradientView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.gradientView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.gradientView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.gradientView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.cardsTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.cardsTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.cardsTitleLabel.bottomAnchor.constraint(equalTo: self.cardsSubTitleLabel.topAnchor, constant: -4)
        ])
        NSLayoutConstraint.activate([
            self.cardsSubTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.cardsSubTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.cardsSubTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
   
    
    private func reapplyTitleStyle(text: String?) {
        guard let text = text else {
            self.cardsTitleLabel.attributedText = nil
            return
        }
        self.cardsTitleLabel.apply(font: NSLocalizedString("san_serif_font_bold", comment: ""), color: UIColor(named: "pear"), fontSize: 14, title: text)
    }
    
    private func reapplySubTitleStyle(text: String?) {
        guard let text = text else {
            self.cardsTitleLabel.attributedText = nil
            return
        }
        self.cardsSubTitleLabel.apply(font: NSLocalizedString("san_serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 12, title: text)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title = nil
        self.subtitle = nil
        self.backgroundState = .loading
    }
    

}
