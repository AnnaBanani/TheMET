//
//  LoadingImageView.swift
//  TheMET
//
//  Created by Анна Ситникова on 28/04/2023.
//

import Foundation
import UIKit

class LoadingImageView: UIView {
    
    enum State {
        case loading
        case failed
        case loaded(UIImage)
    }
    
    var state: State = .loading {
        didSet {
            self.resetStateView(state: self.state)
        }
    }
    
    private var imageView: UIImageView = UIImageView()
    
    private var failedImageView: UIImageView = UIImageView(image: UIImage(named: "Not Loaded Image"))
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.resetStateView(state: self.state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.failedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        self.addSubview(self.activityIndicator)
        self.addSubview(self.failedImageView)
        self.imageView.contentMode = .scaleToFill
        self.failedImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.failedImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.failedImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.failedImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.failedImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func resetStateView(state: State) {
        switch state {
        case .loading:
            self.imageView.image = nil
            self.imageView.isHidden = true
            self.failedImageView.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        case .failed:
            self.imageView.image = nil
            self.imageView.isHidden = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.failedImageView.isHidden = false
        case .loaded(let loadedImage):
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.image = loadedImage
            self.imageView.isHidden = false
            self.failedImageView.isHidden = true
        }
    }
}
    
