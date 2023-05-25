//
//  CatalogViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit


class CatalogViewController: UIViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "CatalogIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "CatalogIconTapped")?.withRenderingMode(.alwaysOriginal))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("catalog_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        let  newView: TagListView = TagListView()
//        let newView = CatalogContentView.constructView()
//        newView.tags = [ "Винсент Ван Гог", "Живопись", "Арт", "Европа","Винсент Ван Гог", "Живопись", "Арт", "Европа", "Арт", "Европа"]
//        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.tags = [ "Vincent Van Goghl", "Painting","Vincent", "Painting", "Dutch", "Vincent Van Gogh", "Painting", "Vincent Van Gogh", "Vincent Van Goghl", "Painting","Vincent", "Painting", "Dutch", "Vincent Van Gogh", "Painting", "Vincent Van Gogh", "Vincent Van Goghl", "Painting","Vincent", "Painting", "Dutch", "Vincent Van Gogh", "Painting", "Vincent Van Gogh"]
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            newView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            newView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
//            newView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
}

