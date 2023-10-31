//
//  FeaturedArtistsView.swift
//  TheMET
//
//  Created by Анна Ситникова on 31/10/2023.
//

import Foundation
import UIKit

class FeaturedArtistsView: UIView {
    
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let gradientView: VerticalGradientView = VerticalGradientView()
    
    var title: String? {
        get { return self.titleLabel.attributedText?.string }
        set {
            if let newValue = newValue {
                self.titleLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 18, title: newValue)
            } else {
                self.titleLabel.attributedText = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "blueberry")
        self.imageView.image = UIImage(named: "FeaturedArtistsCover")
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.gradientView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.gradientView.topAnchor.constraint(equalTo: self.topAnchor),
            self.gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 8),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -8),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
