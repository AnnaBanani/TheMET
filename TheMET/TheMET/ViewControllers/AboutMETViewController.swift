//
//  AboutMETViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 10/01/2024.
//

import Foundation
import UIKit
import MetAPI

class AboutMETViewController: UIViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "AboutIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "AboutIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("about_met_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        let aboutButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "AboutAppIcon"),
            style: .plain,
            target: self,
            action: #selector(aboutButtonDidTap)
        )
        aboutButton.tintColor = UIColor(named: "plum")
        self.navigationItem.rightBarButtonItem = aboutButton
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
