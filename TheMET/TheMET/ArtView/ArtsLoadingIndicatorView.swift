//
//  ArtsLoadingIndicatorView.swift
//  TheMET
//
//  Created by Анна Ситникова on 02/08/2023.
//

import Foundation
import UIKit

class ArtsLoadingIndicatorView: UIView {
    
    let artIndicatorViewContainer: ArtsLoadingIndicatorContainerView = ArtsLoadingIndicatorContainerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.artIndicatorViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.artIndicatorViewContainer)
        let heightConstraint: NSLayoutConstraint = self.artIndicatorViewContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        let widthConstraint: NSLayoutConstraint = self.artIndicatorViewContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        widthConstraint.priority = .defaultHigh
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            self.artIndicatorViewContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.artIndicatorViewContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.artIndicatorViewContainer.heightAnchor.constraint(equalTo: self.artIndicatorViewContainer.widthAnchor, multiplier: 1.07),
            self.artIndicatorViewContainer.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.9),
            self.artIndicatorViewContainer.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.8),
            heightConstraint,
            widthConstraint
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
   
    
class ArtsLoadingIndicatorContainerView: UIView {
    
    let frameOneImageView: UIImageView = UIImageView(image: UIImage(named: "Frame1"))
    let frameTwoImageView: UIImageView = UIImageView(image: UIImage(named: "Frame2"))
    let frameThreeImageView: UIImageView = UIImageView(image: UIImage(named: "Frame3"))
    let frameFourImageView: UIImageView = UIImageView(image: UIImage(named: "Frame4"))
    let invisibleViewOne: UIView = UIView()
    let invisibleViewTwo: UIView = UIView()
    let invisibleViewThree: UIView = UIView()
    let invisibleViewFour: UIView = UIView()
    let invisibleViewFive: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frameOneImageView.translatesAutoresizingMaskIntoConstraints = false
        self.frameTwoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.frameThreeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.frameFourImageView.translatesAutoresizingMaskIntoConstraints = false
        self.invisibleViewOne.translatesAutoresizingMaskIntoConstraints = false
        self.invisibleViewTwo.translatesAutoresizingMaskIntoConstraints = false
        self.invisibleViewThree.translatesAutoresizingMaskIntoConstraints = false
        self.invisibleViewFour.translatesAutoresizingMaskIntoConstraints = false
        self.invisibleViewFive.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.frameOneImageView)
        self.addSubview(self.frameTwoImageView)
        self.addSubview(self.frameThreeImageView)
        self.addSubview(self.frameFourImageView)
        self.addSubview(self.invisibleViewOne)
        self.addSubview(self.invisibleViewTwo)
        self.addSubview(self.invisibleViewThree)
        self.addSubview(self.invisibleViewFour)
        self.addSubview(self.invisibleViewFive)
        NSLayoutConstraint.activate([
            self.invisibleViewOne.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.invisibleViewOne.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            self.invisibleViewOne.topAnchor.constraint(equalTo: self.topAnchor),
            self.invisibleViewOne.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08)
        ])
        NSLayoutConstraint.activate([
            self.frameOneImageView.leadingAnchor.constraint(equalTo: self.invisibleViewOne.trailingAnchor),
            self.frameOneImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.47),
            self.frameOneImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.frameOneImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.38)
        ])
        NSLayoutConstraint.activate([
            self.invisibleViewTwo.leadingAnchor.constraint(equalTo: self.frameOneImageView.trailingAnchor),
            self.invisibleViewTwo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            self.invisibleViewTwo.topAnchor.constraint(equalTo: self.topAnchor),
            self.invisibleViewTwo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.09)
        ])
        NSLayoutConstraint.activate([
            self.frameTwoImageView.leadingAnchor.constraint(equalTo: self.invisibleViewTwo.trailingAnchor),
            self.frameTwoImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35),
            self.frameTwoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.frameTwoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.37)
        ])
        NSLayoutConstraint.activate([
            self.invisibleViewThree.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.invisibleViewThree.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05),
            self.invisibleViewThree.topAnchor.constraint(equalTo: self.frameOneImageView.bottomAnchor),
            self.invisibleViewThree.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1)
        ])
        NSLayoutConstraint.activate([
            self.frameThreeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.frameThreeImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.43),
            self.frameThreeImageView.topAnchor.constraint(equalTo: self.invisibleViewThree.bottomAnchor),
            self.frameThreeImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
        ])
        NSLayoutConstraint.activate([
            self.invisibleViewFour.leadingAnchor.constraint(equalTo:  self.frameOneImageView.trailingAnchor),
            self.invisibleViewFour.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07),
            self.invisibleViewFour.topAnchor.constraint(equalTo: self.frameTwoImageView.bottomAnchor),
            self.invisibleViewFour.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1)
        ])
        NSLayoutConstraint.activate([
            self.invisibleViewFive.leadingAnchor.constraint(equalTo: self.frameThreeImageView.trailingAnchor),
            self.invisibleViewFive.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            self.invisibleViewFive.topAnchor.constraint(equalTo: self.frameOneImageView.bottomAnchor),
            self.invisibleViewFive.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.09)
        ])
        NSLayoutConstraint.activate([
            self.frameFourImageView.leadingAnchor.constraint(equalTo: self.invisibleViewFive.trailingAnchor),
            self.frameFourImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.58),
            self.frameFourImageView.topAnchor.constraint(equalTo: self.invisibleViewFour.bottomAnchor),
            self.frameFourImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.51)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.startAnimationIfNeeded()
        }
    }

    private func startAnimationIfNeeded() {
        guard self.window != nil,
        self.bounds != .zero else {
            return
        }
        self.frameOneImageView.setAnchorPoint(CGPoint(x: 0.5, y: 0))
        self.frameOneImageView.transform = CGAffineTransform(rotationAngle: .pi/10)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.frameOneImageView.transform = CGAffineTransform(rotationAngle: -.pi/10)
        }
        self.frameTwoImageView.setAnchorPoint(CGPoint(x: 0.5, y: 0))
        self.frameTwoImageView.transform = CGAffineTransform(rotationAngle: .pi/10)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.frameTwoImageView.transform = CGAffineTransform(rotationAngle: -.pi/10)
        }
        self.frameThreeImageView.setAnchorPoint(CGPoint(x: 0.5, y: 0))
        self.frameThreeImageView.transform = CGAffineTransform(rotationAngle: .pi/10)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.frameThreeImageView.transform = CGAffineTransform(rotationAngle: -.pi/10)
        }
        self.frameFourImageView.setAnchorPoint(CGPoint(x: 0.5, y: 0))
        self.frameFourImageView.transform = CGAffineTransform(rotationAngle: .pi/10)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.frameFourImageView.transform = CGAffineTransform(rotationAngle: -.pi/10)
        }
    }
}

private extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
