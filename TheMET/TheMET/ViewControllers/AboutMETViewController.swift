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
import Combine

class AboutMETViewController: UIViewController {
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let emptyView: UIView = UIView()
    
    private let topLocationView: LocationView = LocationView()
    
    private let bottomLocationView: LocationView = LocationView()
    
    private var viewModel: AboutMETViewModel?
    
    private var titleSubscriber: AnyCancellable?
    
    private var topMapViewDataSubscriber: AnyCancellable?
    
    private var bottomMapViewDataSubscriber: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "AboutIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "AboutIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationRightButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "AboutAppIcon"),
            style: .plain,
            target: self,
            action: #selector(navigationRightButtonDidTap)
        )
        navigationRightButton.tintColor = UIColor(named: "plum")
        self.navigationItem.rightBarButtonItem = navigationRightButton
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
            locationView: self.topLocationView,
            topAnchorView: self.emptyView,
            contentGuide: contentGuide
        )
        self.setLocationView(
            locationView: self.bottomLocationView,
            topAnchorView: self.topLocationView,
            contentGuide: contentGuide
        )
        NSLayoutConstraint.activate([
            self.bottomLocationView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor)
        ])
        self.setupViewModel()
        self.topLocationView.onMapViewTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel?.topLocatonViewDidTap()
        }
        self.bottomLocationView.onMapViewTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel?.bottomLocatonViewDidTap()
        }
    }
    
    @objc
    private func navigationRightButtonDidTap() {
        self.viewModel?.navigationRightButtonTapped()
    }
    
    private func setupViewModel() {
        let viewModel = AboutMETViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title
            .sink(receiveValue: { [weak self] titleText in
            guard let self = self else {return}
            self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: titleText, color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        })
        self.topMapViewDataSubscriber = viewModel.$topMapViewData
            .sink(receiveValue: { [weak self] newMapViewData in
                guard let self = self else {return}
                self.topLocationView.titleText = newMapViewData.title
                self.topLocationView.addressText = newMapViewData.subtitle
                self.topLocationView.coordinate = CLLocationCoordinate2D(latitude: newMapViewData.latitude , longitude: newMapViewData.longitude)
            })
        self.bottomMapViewDataSubscriber = viewModel.$bottomMapViewData
            .sink(receiveValue: { [weak self] newMapViewData in
                guard let self = self else {return}
                self.bottomLocationView.titleText = newMapViewData.title
                self.bottomLocationView.addressText = newMapViewData.subtitle
                self.bottomLocationView.coordinate = CLLocationCoordinate2D(latitude: newMapViewData.latitude , longitude: newMapViewData.longitude)
            })
    }
    
    private func setLocationView(locationView: LocationView, topAnchorView: UIView,  contentGuide: UILayoutGuide) {
        locationView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(locationView)
        NSLayoutConstraint.activate([
            locationView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor, constant: 10),
            locationView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor, constant: -10),
            locationView.topAnchor.constraint(equalTo: topAnchorView.bottomAnchor, constant: 40)
        ])
    }
}

