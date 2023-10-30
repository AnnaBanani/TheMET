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
    private let artistNameLabel: UILabel = UILabel()
    private let titleLable: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    private let mediumLabel: UILabel = UILabel()
    private var container: UIStackView = UIStackView()
    private let tagView: TagListView = TagListView()
    
    // MARK: - API
    var onImageDidTap: ((UIImage) -> Void)? 
    
    var imageState: LoadingImageView.State {
        get { return self.loadingImageView.state }
        set { self.loadingImageView.state = newValue }
    }
    var isLiked: Bool = false {
        didSet {
            self.updateLikeButton()
        }
    }
    var artistNameText: String? {
        get { return self.artistNameLabel.text }
        set { self.setLabelText(newValue, label: artistNameLabel, font: NSLocalizedString("serif_font_bold", comment: "")) }
    }
    var titleText: String? {
        get { return self.titleLable.text }
        set { self.setLabelText(newValue, label: titleLable, font: NSLocalizedString("serif_font", comment: ""))  }
    }
    var dateText: String? {
        get { return self.dateLabel.text }
        set { self.setLabelText(newValue, label: dateLabel, font: NSLocalizedString("serif_font", comment: ""))  }
    }
    var mediumText: String? {
        get { return self.mediumLabel.text }
        set { self.setLabelText(newValue, label: mediumLabel, font: NSLocalizedString("serif_font", comment: ""))  }
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
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageDidTap))
        self.loadingImageView.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func likeButtonDidTap(){
        self.onLikeButtonDidTap?()
    }

    @objc
    private func imageDidTap() {
        guard case .loaded(let image) = self.imageState else {
            return
        }
        self.onImageDidTap?(image)
    }
    
    private func updateLikeButton() {
        let buttonImageName: String
        if self.isLiked {
            buttonImageName = "FilledLikeIcon"
        } else {
            buttonImageName = "EmptyLikeIcon"
        }
        self.likeButton.apply(radius: 0, backgroundColor: .clear, fontColor: nil, font: "", fontSize: 0, buttonTitle: "", image: UIImage(named: buttonImageName))
    }
    
    private func setLabelText(_ text: String?, label: UILabel, font: String) {
        if let text = text {
            label.apply(font: font, color: UIColor(named: "plum"), fontSize: 16, title: text)
            label.numberOfLines = 0
            label.isHidden = false
        } else {
            label.text = nil
            label.isHidden = true
        }
    }
    
    private func setupLayout() {
        self.loadingImageView.contentMode = .scaleAspectFit
        self.loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
//    TODO: - tagView placement problem is going to be solved in the task 34
//        self.tagView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.loadingImageView)
        self.addSubview(self.likeButton)
//        self.addSubview(self.tagView)
        NSLayoutConstraint.activate([
            self.loadingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.loadingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.loadingImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.loadingImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        NSLayoutConstraint.activate([
            self.likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.likeButton.widthAnchor.constraint(equalToConstant: 20),
            self.likeButton.heightAnchor.constraint(equalToConstant: 20),
            self.likeButton.topAnchor.constraint(equalTo: self.loadingImageView.bottomAnchor, constant: 10)
        ])
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.container)
        self.container.addArrangedSubview(self.artistNameLabel)
        self.container.addArrangedSubview(self.titleLable)
        self.container.addArrangedSubview(self.dateLabel)
        self.container.addArrangedSubview(self.mediumLabel)
        self.container.axis = .vertical
        self.container.distribution = .fill
        self.container.alignment = .leading
        self.container.spacing = 0
        NSLayoutConstraint.activate([
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.container.topAnchor.constraint(equalTo: self.likeButton.bottomAnchor, constant: 10),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
//        NSLayoutConstraint.activate([
//            self.tagView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10),
//            self.tagView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            self.tagView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
//            self.tagView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 100),
//            self.tagView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
//            self.tagView.heightAnchor.constraint(equalToConstant: 50)
//        ])
    }
}
