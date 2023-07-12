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
    
    static let artViewCellIdentifier = "CatalogCell"
    
    // MARK: - API
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
        self.contentView.addSubview(self.artView)
        NSLayoutConstraint.activate([
            self.artView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.artView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.artView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.artView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

