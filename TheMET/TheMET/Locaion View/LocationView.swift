//
//  LocationView.swift
//  TheMET
//
//  Created by Анна Ситникова on 12/01/2024.
//

import Foundation
import UIKit
import MapKit

class LocationView: UIView {
    
    private let titleLabel: UILabel = UILabel()
    
    private let addressLabel: UILabel = UILabel()
    
    let mapView: MKMapView = MKMapView()
    
    private var container: UIStackView = UIStackView()
    
    var titleText: String? {
        get { return self.titleLabel.text }
        set { self.setLabel(label: self.titleLabel, font: NSLocalizedString("san_serif_font_bold", comment: ""), title: newValue) }
    }
    var addressText: String? {
        get { return self.titleLabel.text }
        set { self.setLabel(label: self.addressLabel, font: NSLocalizedString("san_serif_font", comment: ""), title: newValue) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContainerLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLabel(label: UILabel, font: String, title: String?) {
        if let title = title {
            label.apply(font: font, color: UIColor(named: "plum"), alignment: .left, fontSize: 16, title: title)
            label.numberOfLines = 0
            label.isHidden = false
        } else {
            label.text = nil
            label.isHidden = true
        }
    }
    
    private func setMapView() {
        NSLayoutConstraint.activate([
            self.mapView.heightAnchor.constraint(equalToConstant: 200),
            self.mapView.widthAnchor.constraint(equalTo: self.container.widthAnchor)
        ])
    }
    
    private func setContainerLayout() {
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.container)
        NSLayoutConstraint.activate([
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.container.topAnchor.constraint(equalTo: self.topAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.container.addArrangedSubview(self.titleLabel)
        self.container.addArrangedSubview(self.addressLabel)
        self.container.addArrangedSubview(self.mapView)
        self.setMapView()
        self.container.axis = .vertical
        self.container.distribution = .fill
        self.container.alignment = .leading
        self.container.spacing = 15
    }
}

extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
