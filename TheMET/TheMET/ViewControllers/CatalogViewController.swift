//
//  CatalogViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit
import MetAPI


class CatalogViewController: UIViewController {
    
    private let aboutButton: UIButton = UIButton()
    
    private let departmentsSectionViewController: DepartmentsSectionViewController = DepartmentsSectionViewController()
    
    private let featuredArtistsViewController: ArtistsSectionViewController = ArtistsSectionViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "CatalogIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "CatalogIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("catalog_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        let aboutButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "AboutAppIcon"),
            style: .plain,
            target: self,
            action: #selector(aboutButtonDidTap)
        )
        aboutButton.tintColor = UIColor(named: "plum")
        self.navigationItem.rightBarButtonItem = aboutButton
        self.departmentsSectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.departmentsSectionViewController.view)
        NSLayoutConstraint.activate([
            self.departmentsSectionViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.departmentsSectionViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.departmentsSectionViewController.view.heightAnchor.constraint(equalToConstant: 240),
            self.departmentsSectionViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        self.addChild(self.departmentsSectionViewController)
        self.departmentsSectionViewController.didMove(toParent: self)
        self.featuredArtistsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.featuredArtistsViewController.view)
        NSLayoutConstraint.activate([
            self.featuredArtistsViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.featuredArtistsViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.featuredArtistsViewController.view.heightAnchor.constraint(equalToConstant: 240),
            self.featuredArtistsViewController.view.topAnchor.constraint(equalTo: self.departmentsSectionViewController.view.bottomAnchor)
        ])
    }
    
    @objc
    private func aboutButtonDidTap() {
        let aboutAppViewController: AboutAppViewController = AboutAppViewController()
        aboutAppViewController.modalPresentationStyle = .automatic
        aboutAppViewController.modalTransitionStyle = .coverVertical
        let aboutAppNavigationController = UINavigationController(rootViewController: aboutAppViewController)
        self.present(aboutAppNavigationController, animated: true)
    }
}
