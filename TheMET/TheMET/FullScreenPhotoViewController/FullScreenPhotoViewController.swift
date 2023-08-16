//
//  FullScreenPhotoViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 16/08/2023.
//

import Foundation
import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    private let imageView: UIImageView = UIImageView()
    private let closeButton: UIButton = UIButton()
    var image: UIImage? {
        set { self.imageView.image = newValue }
        get { self.imageView.image }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.closeButton)
        self.view.backgroundColor = UIColor(named: "blackberry")
        self.imageView.contentMode = .scaleAspectFit
        self.closeButton.apply(radius: 0, backgroundColor: .clear, fontColor: nil, font: "", fontSize: 0, buttonTitle: "", image: UIImage(named: "CloseButton"))
        self.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.closeButton.widthAnchor.constraint(equalToConstant: 20),
            self.closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
}
