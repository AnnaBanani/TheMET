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
    
    var onViewTapped: (() -> Void)?
    
    var title: String? {
        get { return self.titleLabel.attributedText?.string }
        set {
            if let newValue = newValue {
                self.titleLabel.apply(font: NSLocalizedString("san_serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 18, title: newValue)
            } else {
                self.titleLabel.attributedText = nil
            }
        }
    }
    
    var image: UIImage? {
        get { return self.imageView.image }
        set {
            if let newValue = newValue {
                self.imageView.image = newValue
            } else {
                self.imageView.image = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "blueberry")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
        self.addSubview(self.gradientView)
        self.addSubview(self.titleLabel)
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
            self.titleLabel.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -10)
        ])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapView(_ sender: UITapGestureRecognizer) {
        self.onViewTapped?()
    }
    
    private func highlightView() {
        self.imageView.alpha = 0.8
    }

    private func dehighlightView() {
        self.imageView.alpha = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.highlightView()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dehighlightView()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.dehighlightView()
    }
}
