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
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let scrollContainer: UIView = UIView()
    
    private let departmentsSectionViewController: DepartmentsSectionViewController = DepartmentsSectionViewController()
    
    private let featuredArtistsViewController: ArtistsSectionViewController = ArtistsSectionViewController()
    
    private let culturesSectionViewController: CulturesSectionViewController = CulturesSectionViewController()
     
    
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
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        let contentGuide = self.scrollView.contentLayoutGuide
        let frameGuide = self.scrollView.frameLayoutGuide
        self.scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.scrollContainer)
        NSLayoutConstraint.activate([
            self.scrollContainer.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            self.scrollContainer.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            self.scrollContainer.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            self.scrollContainer.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            self.scrollContainer.leadingAnchor.constraint(equalTo: frameGuide.leadingAnchor),
            self.scrollContainer.trailingAnchor.constraint(equalTo: frameGuide.trailingAnchor),
            self.scrollContainer.heightAnchor.constraint(equalToConstant: 800)
        ])
        
        self.navigationItem.rightBarButtonItem = aboutButton
        self.departmentsSectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.scrollContainer.addSubview(self.departmentsSectionViewController.view)
        NSLayoutConstraint.activate([
            self.departmentsSectionViewController.view.leadingAnchor.constraint(equalTo: self.scrollContainer.leadingAnchor),
            self.departmentsSectionViewController.view.trailingAnchor.constraint(equalTo: self.scrollContainer.trailingAnchor),
            self.departmentsSectionViewController.view.heightAnchor.constraint(equalToConstant: 240),
            self.departmentsSectionViewController.view.topAnchor.constraint(equalTo: self.scrollContainer.topAnchor)
        ])
        self.addChild(self.departmentsSectionViewController)
        self.departmentsSectionViewController.didMove(toParent: self)
        self.featuredArtistsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollContainer.addSubview(self.featuredArtistsViewController.view)
        NSLayoutConstraint.activate([
            self.featuredArtistsViewController.view.leadingAnchor.constraint(equalTo: self.scrollContainer.leadingAnchor),
            self.featuredArtistsViewController.view.trailingAnchor.constraint(equalTo: self.scrollContainer.trailingAnchor),
            self.featuredArtistsViewController.view.heightAnchor.constraint(equalToConstant: 240),
            self.featuredArtistsViewController.view.topAnchor.constraint(equalTo: self.departmentsSectionViewController.view.bottomAnchor)
        ])
        self.addChild(self.featuredArtistsViewController)
        self.featuredArtistsViewController.didMove(toParent: self)
        self.culturesSectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollContainer.addSubview(self.culturesSectionViewController.view)
        NSLayoutConstraint.activate([
            self.culturesSectionViewController.view.leadingAnchor.constraint(equalTo: self.scrollContainer.leadingAnchor),
            self.culturesSectionViewController.view.trailingAnchor.constraint(equalTo: self.scrollContainer.trailingAnchor),
            self.culturesSectionViewController.view.heightAnchor.constraint(equalToConstant: 240),
            self.culturesSectionViewController.view.topAnchor.constraint(equalTo: self.featuredArtistsViewController.view.bottomAnchor)
        ])
        self.addChild(self.culturesSectionViewController)
        self.culturesSectionViewController.didMove(toParent: self)
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
