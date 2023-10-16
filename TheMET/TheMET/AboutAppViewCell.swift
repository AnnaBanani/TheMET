//
//  AboutAppViewCell.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/10/2023.
//

import Foundation
import UIKit

class AboutAppViewCell: UITableViewCell {
    
    private let label: UILabel = UILabel()
    private let chevronView: UIImageView = UIImageView()
    static let aboutAppViewCellIdentifier = "AboutCell"
    
    func set(titleText: String) {
        self.label.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), alignment: .left, fontSize: 16, title: titleText)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.backgroundColor = .clear
        self.label.numberOfLines = 0
        self.chevronView.backgroundColor = .clear
        self.chevronView.translatesAutoresizingMaskIntoConstraints = false
        self.chevronView.image = UIImage(named: "chevron")
        self.addSubview(self.chevronView)
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.label.trailingAnchor.constraint(equalTo: self.chevronView.leadingAnchor, constant: -20),
            self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            self.chevronView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.chevronView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.chevronView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
