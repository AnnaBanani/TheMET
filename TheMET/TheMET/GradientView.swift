//
//  GradientView.swift
//  TheMET
//
//  Created by Анна Ситникова on 12/05/2023.
//

import Foundation
import UIKit

class VerticalGradientView: UIView {
    
    private var didGradientSet: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupIfNeeded()
    }
    
    override var bounds: CGRect {
        didSet {
            self.setupIfNeeded()
        }
    }
    
    private func setupIfNeeded() {
        guard self.frame.width > 0,
              self.frame.height > 0,
        !self.didGradientSet else {
            return
        }
        self.setup()
        self.didGradientSet = true
    }
    
    private func setup() {
        self.backgroundColor = .clear
        let gradientLayer = self.gradient()
        self.layer.addSublayer(gradientLayer)
    }
    
    private func gradient() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.startPoint = CGPoint(x: 0, y: 0.9)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.colors = [
            UIColor.black.withAlphaComponent(0.4).cgColor,UIColor.clear.cgColor]
        return layer
    }
}
