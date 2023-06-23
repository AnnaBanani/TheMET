//
//  FavoritesViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "FavoriteIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "FavoriteIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("favories_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        let artView: ArtView = ArtView()
        artView.imageState = .loaded(UIImage(named: "Image2")!)
        artView.isLiked = true
        artView.tags = ["Egypt", "Van Gogh", "Painting", "Oil"]
        artView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
        artView.onLikeButtonDidTap = { [weak artView] in
            artView?.isLiked.toggle()
        }
        artView.translatesAutoresizingMaskIntoConstraints = false
       
        self.view.addSubview(artView)
        NSLayoutConstraint.activate([
            artView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            artView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            artView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            artView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        ])
        
       
    }
}
