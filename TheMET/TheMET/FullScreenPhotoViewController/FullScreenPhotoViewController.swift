//
//  FullScreenPhotoViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 16/08/2023.
//

import Foundation
import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    private let imageView: UIImageView = UIImageView()
    private let closeButton: UIButton = UIButton()
    var image: UIImage? {
        set { self.imageView.image = newValue }
        get { self.imageView.image }
    }
    
    private var scale: CGFloat = 1
    private var currentGestureScale: CGFloat = 1
    private let maxScale: CGFloat = 2
    private let minScale: CGFloat = 0.5
    private var transX: CGFloat = 0
    private var transY: CGFloat = 0
    private var currentGestureTransX: CGFloat = 0
    private var currentGestureTransY: CGFloat = 0
    private var viewSize: CGSize {
        get {
            return self.view.bounds.size
        }
    }
    
    private var imageSize: CGSize {
        get {
            guard let imageRawSize = self.image?.size else { return CGSize(width: 0, height: 0) }
            let imageAspectRatio = imageRawSize.width/imageRawSize.height
            let viewAspectRatio = self.viewSize.width/self.viewSize.height
            if imageAspectRatio < viewAspectRatio {
                return CGSize(width: (self.viewSize.width * imageRawSize.height)/self.viewSize.height, height: self.viewSize.height)
            } else {
                return CGSize(width: self.viewSize.width, height: (self.viewSize.width * self.viewSize.height)/imageRawSize.width)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.closeButton)
        self.view.backgroundColor = UIColor(named: "blackberry")
        self.imageView.contentMode = .scaleAspectFit
        self.closeButton.apply(radius: 0, backgroundColor: .clear, fontColor: nil, font: "", fontSize: 0, buttonTitle: "", image: UIImage(named: "CloseButton"))
        self.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.closeButton.widthAnchor.constraint(equalToConstant: 20),
            self.closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.currentGestureScale = self.scale
        case .ended:
            break
        case .changed:
            let scale = self.currentGestureScale * recognizer.scale
            self.applyTransform(transX: self.transX, transY: self.transY, scale: scale)
        case .failed, .cancelled:
            self.scale = self.currentGestureScale
            self.tranformImageView()
        default: break
        }
    }
    
    @objc
    private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.currentGestureTransX = self.transX
            self.currentGestureTransY = self.transY
        case .ended: break
        case .changed:
            let tranform = recognizer.translation(in: self.view)
            let transX = self.currentGestureTransX + tranform.x/self.scale
            let transY = self.currentGestureTransY + tranform.y/self.scale
            self.applyTransform(transX: transX, transY: transY, scale: self.scale)
        case .failed, .cancelled:
            self.transX = self.currentGestureTransX
            self.transY = self.currentGestureTransY
            self.tranformImageView()
        default: break
        }
    }
    
    private func applyTransform(transX: CGFloat, transY: CGFloat, scale: CGFloat) {
        self.scale = CGFloat.value(original: scale, max: self.maxScale, min: self.minScale)
        let imageSize = self.imageSize
        let viewSize = self.viewSize
        let permissibleTransX: CGFloat = self.calculatePermissibleTrans(viewSize: viewSize.width, imageSize: imageSize.width)
        let permissibleTransY: CGFloat = self.calculatePermissibleTrans(viewSize: viewSize.height, imageSize: imageSize.height)
        self.transX = CGFloat.value(original: transX, max: permissibleTransX, min: -permissibleTransX)
        self.transY = CGFloat.value(original: transY, max: permissibleTransY, min: -permissibleTransY)
        self.tranformImageView()
    }
    
    private func calculatePermissibleTrans(viewSize: CGFloat, imageSize: CGFloat ) -> CGFloat {
        let restRelWidth = 0.1 + (self.scale*(viewSize - imageSize)/2)/viewSize
        let relOffsetWidth = ((viewSize + ((viewSize * self.scale) - viewSize)/2))/(viewSize * self.scale)
        let correctedRelOffsetWidth = relOffsetWidth - restRelWidth/self.scale
        return correctedRelOffsetWidth * viewSize
    }
    
    private func tranformImageView () {
        let transform = CGAffineTransform.identity
            .scaledBy(x: self.scale, y: self.scale)
            .translatedBy(x: self.transX, y: self.transY)
        self.imageView.transform = transform
    }
}

private extension CGFloat {
    static func value (original: CGFloat, max: CGFloat, min: CGFloat) -> CGFloat {
        if original > max {
            return max
        } else if original < min {
            return min
        } else {
            return original
        }
    }
    
}
