//
//  ArtView.swift
//  TheMET
//
//  Created by Анна Ситникова on 22/06/2023.
//

import Foundation
import UIKit

class ArtView: UIView {
    // MARK: - Subviews
    private let loadingImageView: LoadingImageView = LoadingImageView()
    private let likeButton: UIButton = UIButton()
    private let textLabel: UILabel = UILabel()
    private let tagView: TagListView = TagListView()
    
    // MARK: - API
    var imageState: LoadingImageView.State {
        get { return self.loadingImageView.state }
        set { self.loadingImageView.state = newValue }
    }
    var isLiked: Bool = false {
        didSet {
            self.updateLikeButton()
        }
    }
    var text: String? {
        get { return self.textLabel.text }
        set { self.setArtText(newValue) }
    }
    var onLikeButtonDidTap: (() -> Void)?
    var tags: [String] {
        get { return self.tagView.tags }
        set { self.tagView.tags = newValue }
    }
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateLikeButton()
        self.likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func likeButtonDidTap(){
        self.onLikeButtonDidTap?()
    }
    
    private func updateLikeButton() {
        let buttonImageName: String
        if self.isLiked {
            buttonImageName = "EmptyLikeIcon"
        } else {
            buttonImageName = "FilledLikeIcon"
        }
        self.likeButton.apply(radius: 0, backgroundColor: .clear, fontColor: nil, font: "", fontSize: 0, buttonTitle: "", image: UIImage(named: buttonImageName))
    }
    
    private func setArtText(_ text: String?) {
        if let text = text {
            self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 16, title: text)
            self.textLabel.numberOfLines = 0
        } else {
            self.textLabel.text = nil
        }
    }
    
    private func setupLayout() {
        self.loadingImageView.contentMode = .scaleAspectFit
        self.loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tagView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.loadingImageView)
        self.addSubview(self.likeButton)
        self.addSubview(self.textLabel)
        self.addSubview(self.tagView)
        NSLayoutConstraint.activate([
//            self.loadingImageView.heightAnchor.constraint(equalToConstant: 150),
            self.loadingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.loadingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.loadingImageView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        NSLayoutConstraint.activate([
            self.likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.likeButton.widthAnchor.constraint(equalToConstant: 20),
            self.likeButton.heightAnchor.constraint(equalToConstant: 20),
            self.likeButton.topAnchor.constraint(equalTo: self.loadingImageView.bottomAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.textLabel.topAnchor.constraint(equalTo: self.likeButton.bottomAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            self.tagView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tagView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tagView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10)
        ])
    }
}
