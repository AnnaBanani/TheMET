//
//  ArtViewCell.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/07/2023.
//

import Foundation
import UIKit

class ArtViewCell: UITableViewCell {
    
    private let artView = ArtView()
    
    private var artViewBottomConstraint: NSLayoutConstraint?

    private var placeholderBottomConstraint: NSLayoutConstraint?

    private let placeHolderImageView = UIView()
    private let placeHolderTextView = UIView()
    
    static let artViewCellIdentifier = "CatalogCell"
    
    // MARK: - API
    var isPlaceholderVisible: Bool = false {
        didSet {
            self.setElementsVisibility()
        }
    }
    
    private func setElementsVisibility() {
        if self.isPlaceholderVisible {
            self.artView.isHidden = true
            self.placeHolderImageView.isHidden = false
            self.placeHolderTextView.isHidden = false
            self.artViewBottomConstraint?.isActive = false
            self.placeholderBottomConstraint?.isActive = true
        } else {
            self.artView.isHidden = false
            self.placeHolderImageView.isHidden = true
            self.placeHolderTextView.isHidden = true
            self.artViewBottomConstraint?.isActive = true
            self.placeholderBottomConstraint?.isActive = false
        }
    }
    
    var imageState: LoadingImageView.State {
        get { return self.artView.imageState }
        set { self.artView.imageState = newValue }
    }
    var isLiked: Bool {
        get { return self.artView.isLiked }
        set { self.artView.isLiked = newValue }
    }
    var text: String? {
        get { return self.artView.text }
        set { self.artView.text = newValue }
    }
    var onLikeButtonDidTap: (() -> Void)? {
        get {return self.artView.onLikeButtonDidTap }
        set {self.artView.onLikeButtonDidTap = newValue }
    }
    var tags: [String] {
        get { return self.artView.tags }
        set { self.artView.tags = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.artView.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolderTextView.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolderImageView.backgroundColor = UIColor(named: "blueberry")
        self.placeHolderTextView.backgroundColor = UIColor(named: "blueberry")
        self.contentView.addSubview(self.artView)
        let artViewBottomConstraint = self.artView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        NSLayoutConstraint.activate([
            self.artView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.artView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.artView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            artViewBottomConstraint
        ])
        self.artViewBottomConstraint = artViewBottomConstraint
        self.artViewBottomConstraint?.priority = .defaultHigh
        self.contentView.addSubview(self.placeHolderImageView)
        NSLayoutConstraint.activate([
            self.placeHolderImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.placeHolderImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.placeHolderImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.placeHolderImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        self.contentView.addSubview(self.placeHolderTextView)
        self.placeholderBottomConstraint = self.placeHolderTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        self.placeholderBottomConstraint?.priority = .defaultHigh
        NSLayoutConstraint.activate([
            self.placeHolderTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.placeHolderTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -80),
            self.placeHolderTextView.topAnchor.constraint(equalTo: self.placeHolderImageView.bottomAnchor, constant: 10),
            self.placeHolderTextView.heightAnchor.constraint(equalToConstant: 50),
        ])
        self.setElementsVisibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

