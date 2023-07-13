//
//  FeaturedArtViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit


class FeaturedArtViewController: UIViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "FeaturedIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "FeaturedIconTapped")?.withRenderingMode(.alwaysOriginal))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("random_artwork_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "blackberry")
        self.edgesForExtendedLayout = []
        let newView = LoadingPlaceholderView.constructView(configuration: .featuredLoading)
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            newView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            newView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            newView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
}
