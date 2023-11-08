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
    
    private let departmentsSectionViewController: DepartmentsSectionViewController = DepartmentsSectionViewController()
    
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
        self.view.addSubview(self.departmentsSectionViewController.view)
        self.addChild(self.departmentsSectionViewController)
        self.departmentsSectionViewController.didMove(toParent: self)
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
