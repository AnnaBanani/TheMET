//
//  AboutMETViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 10/01/2024.
//

import Foundation
import UIKit
import MetAPI
import MapKit

class AboutMETViewController: UIViewController {
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let emptyView: UIView = UIView()
    
    private let fifthAvenueLocationView: LocationView = LocationView()
    
    private let cloistersLocationView: LocationView = LocationView()
    
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
        NSLayoutConstraint.activate([
            contentGuide.leadingAnchor.constraint(equalTo: frameGuide.leadingAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: frameGuide.trailingAnchor)
        ])
        
        self.emptyView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.emptyView)
        NSLayoutConstraint.activate([
            self.emptyView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1),
            self.emptyView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            self.emptyView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor)
        ])
        self.setLocationView(
            locationView: self.fifthAvenueLocationView, 
            title: NSLocalizedString("about_met_the_met_fifth_avenue_title_lable", comment: ""),
            address: NSLocalizedString("about_met_the_met_fifth_avenue_address_lable", comment: ""),
            topAnchorView: self.emptyView,
            contentGuide: contentGuide
        )
        self.setLocationView(
            locationView: self.cloistersLocationView,
            title: NSLocalizedString("about_met_the_met_cloisters_title_lable", comment: ""),
            address: NSLocalizedString("about_met_the_met_cloisters_address_lable", comment: ""),
            topAnchorView: self.fifthAvenueLocationView,
            contentGuide: contentGuide
        )
        NSLayoutConstraint.activate([
            self.cloistersLocationView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor)
        ])
        self.fifthAvenueLocationView.coordinate = CLLocationCoordinate2D.fifthAvenuLocation
        self.cloistersLocationView.coordinate = CLLocationCoordinate2D.cloistersLocation
    }
    
    @objc
    private func aboutButtonDidTap() {
        let aboutAppViewController: AboutAppViewController = AboutAppViewController()
        aboutAppViewController.modalPresentationStyle = .automatic
        aboutAppViewController.modalTransitionStyle = .coverVertical
        let aboutAppNavigationController = UINavigationController(rootViewController: aboutAppViewController)
        self.present(aboutAppNavigationController, animated: true)
    }
    
    private func setLocationView(locationView: LocationView, title: String, address: String, topAnchorView: UIView,  contentGuide: UILayoutGuide) {
        locationView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(locationView)
        locationView.titleText = title
        locationView.addressText = address
        NSLayoutConstraint.activate([
            locationView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor, constant: 10),
            locationView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor, constant: -10),
            locationView.topAnchor.constraint(equalTo: topAnchorView.bottomAnchor, constant: 40)
        ])
    }
}

extension CLLocationCoordinate2D {
    static let fifthAvenuLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.77962342752392, longitude: -73.96326546117187)
    static let cloistersLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.86502504586118, longitude: -73.93174886116802)
}

