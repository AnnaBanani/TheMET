//
//  AboutMETViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/01/2024.
//

import Foundation
import Combine
import UIKit
import MapKit

class AboutMETViewModel {
    
    struct MapViewData {
        let title: String?
        let subtitle: String?
        let coordinate: CLLocationCoordinate2D
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
        self.locationViewDidTap(coordinate: self.topMapViewData.coordinate, name: NSLocalizedString("about_met_the_met_fifth_avenue_title_lable", comment: ""), address: "The+Metropolitan+Museum+of+Art,+1000+Fifth+Avenue+New+York,+NY+10028")
    }
    
    func bottomLocatonViewDidTap() {
        self.locationViewDidTap(coordinate: self.bottomMapViewData.coordinate, name: NSLocalizedString("about_met_the_met_cloisters_title_lable", comment: ""), address: "The+Met+Cloisters,+99+Margaret+Corbin+Drive+Fort+Tryon+Park+New+York,+NY+10040")
    }
    
    private func locationViewDidTap(coordinate: CLLocationCoordinate2D, name: String, address: String) {
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        guard UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) else {
            self.openInAppleMap(coordinate: coordinate, name: name)
            return
        }
            let alertController = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )
            let googleAction = UIAlertAction(
                title: NSLocalizedString("about_met_google_maps_presents_cta", comment: ""),
                style: .default,
                handler: { _ in
                    self.openInGoogleMap(coordinate: coordinate, address: address)
                }
            )
            let appleMapAction = UIAlertAction(
                title: NSLocalizedString("about_met_apple_maps_presents_cta", comment: ""),
                style: .default
            ) { _ in
                self.openInAppleMap(coordinate: coordinate, name: name)
            }
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("about_met_cancel_cta", comment: ""),
                style: .cancel
            )
            alertController.addAction(googleAction)
            alertController.addAction(appleMapAction)
            alertController.addAction(cancelAction)
            presentingController.present(alertController, animated: true)
    }
    
    private func openInAppleMap(coordinate: CLLocationCoordinate2D, name:  String) {
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options: [String : Any] = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func openInGoogleMap(coordinate: CLLocationCoordinate2D, address:  String) {
        UIApplication.shared.open(
            URL(
                string:
                    "comgooglemaps://?q=\(address)&center=\(coordinate.latitude),\(coordinate.longitude)&zoom=14"
            )!
        )
    }
}



private extension AboutMETViewModel.MapViewData {
    static let fifthAvenue = AboutMETViewModel.MapViewData(
        title: NSLocalizedString("about_met_the_met_fifth_avenue_title_lable", comment: ""),
        subtitle: NSLocalizedString("about_met_the_met_fifth_avenue_address_lable", comment: ""),
        coordinate: CLLocationCoordinate2D(latitude: 40.77962342752392, longitude: -73.96326546117187)
    )
    static let cloisters = AboutMETViewModel.MapViewData(
        title: NSLocalizedString("about_met_the_met_cloisters_title_lable", comment: ""),
        subtitle: NSLocalizedString("about_met_the_met_cloisters_address_lable", comment: ""),
        coordinate: CLLocationCoordinate2D(latitude: 40.86502504586118, longitude: -73.93174886116802)
    )
}
