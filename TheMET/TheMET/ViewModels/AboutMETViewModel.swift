//
//  AboutMETViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/01/2024.
//

import Foundation
import Combine
import UIKit

class AboutMETViewModel {
    
    struct MapViewData {
        let title: String?
        let subtitle: String?
        let latitude: Double
        let longitude: Double
    }
    
    @Published private(set) var title: String
    
    @Published private(set) var topMapViewData: MapViewData
    
    @Published private(set) var bottomMapViewData: MapViewData
    
    private let presentingControllerProvider: () -> UIViewController?
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.title = NSLocalizedString("about_met_screen_title", comment: "")
        self.topMapViewData = .fifthAvenue
        self.bottomMapViewData = .cloisters
        self.presentingControllerProvider = presentingControllerProvider
    }
    
    func navigationRightButtonTapped() {
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        let aboutAppViewController: AboutAppViewController = AboutAppViewController()
        aboutAppViewController.modalPresentationStyle = .automatic
        aboutAppViewController.modalTransitionStyle = .coverVertical
        let aboutAppNavigationController = UINavigationController(rootViewController: aboutAppViewController)
        presentingController.present(aboutAppNavigationController, animated: true)
    }
    
    func topLocatonViewDidTap() {
        print ("top")
    }
    
    func bottomLocatonViewDidTap() {
        print ("bottom")
    }
}

private extension AboutMETViewModel.MapViewData {
    static let fifthAvenue = AboutMETViewModel.MapViewData(
        title: NSLocalizedString("about_met_the_met_fifth_avenue_title_lable", comment: ""),
        subtitle: NSLocalizedString("about_met_the_met_fifth_avenue_address_lable", comment: ""),
        latitude: 40.77962342752392,
        longitude: -73.96326546117187
    )
    static let cloisters = AboutMETViewModel.MapViewData(
        title: NSLocalizedString("about_met_the_met_cloisters_title_lable", comment: ""),
        subtitle: NSLocalizedString("about_met_the_met_cloisters_address_lable", comment: ""),
        latitude: 40.86502504586118,
        longitude: -73.93174886116802
    )
}
