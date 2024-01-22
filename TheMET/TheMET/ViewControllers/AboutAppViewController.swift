//
//  AboutAppViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/10/2023.
//

import Foundation
import UIKit
import SafariServices
import Combine

class AboutAppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var viewModel: AboutAppViewModel?
    
    private var titleSubscriber: AnyCancellable?
    private var topImageSubscriber: AnyCancellable?
    private var versionTextSubscriber: AnyCancellable?
    private var versionNumberTextSubscriber: AnyCancellable?
    private var privatePolicyLeftTextSubscriber: AnyCancellable?
    private var termsAndConditionsLeftTextSubscriber: AnyCancellable?
    private var copyRightTextSubscriber: AnyCancellable?
    
    private let rightVersionLabel: UILabel = UILabel()
    private let leftVersionLabel: UILabel = UILabel()
    private let copyRightLabel: UILabel = UILabel()
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let imageView: UIImageView = UIImageView()
    
    private let privacyPolicyCellHeight: CGFloat = 53.67
    private let useAPICellHeight: CGFloat = 130
    
    private var privatePolicyText: String = ""
    private var useAPIText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: "", color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.view.backgroundColor = UIColor(named: "blackberry")
        self.addLabel(_ : self.rightVersionLabel)
        self.addLabel(_ : self.leftVersionLabel)
        self.addLabel(_ : self.copyRightLabel)
        self.imageView.backgroundColor = .clear
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30 ),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            self.leftVersionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.leftVersionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5, constant: 0),
            
            self.leftVersionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,constant: 30)
        ])
        NSLayoutConstraint.activate([
            self.rightVersionLabel.leadingAnchor.constraint(equalTo: self.leftVersionLabel.trailingAnchor),
            self.rightVersionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.rightVersionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,constant: 30)
        ])
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.leftVersionLabel.bottomAnchor,constant: 15),
            self.tableView.heightAnchor.constraint(equalToConstant: self.privacyPolicyCellHeight + self.useAPICellHeight)
        ])
        NSLayoutConstraint.activate([
            self.copyRightLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.copyRightLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.copyRightLabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 15)
        ])
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(AboutAppViewCell.self, forCellReuseIdentifier: AboutAppViewCell.aboutAppViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let viewModel = AboutAppViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title
            .sink(receiveValue: { [weak self] titleText in
            guard let self = self else {return}
                self.title = titleText
        })
        self.topImageSubscriber = viewModel.$topImage
            .sink(receiveValue: { [weak self] image in
                guard let self = self,
                      let image = image else { return }
                self.imageView.image = image
            })
        self.versionTextSubscriber = viewModel.$versionText
            .sink(receiveValue: { [weak self] text in
                guard let self = self else {return}
                self.leftVersionLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), alignment: .left, fontSize: 16, title: text)
            })
        self.versionNumberTextSubscriber = viewModel.$versionNumberText
            .sink(receiveValue: { [weak self] text in
                guard let self = self else {return}
                self.rightVersionLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), alignment: .right, fontSize: 16, title: text)
            })
        self.copyRightTextSubscriber = viewModel.$copyRightText
            .sink(receiveValue: { [weak self] text in
                guard let self = self else {return}
                self.copyRightLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "blueberry"), alignment: .left, fontSize: 16, title: text)
            })
        self.privatePolicyLeftTextSubscriber = viewModel.$privatePolicyText
            .sink(receiveValue: { [weak self] text in
                guard let self = self else {return}
                self.privatePolicyText = text
                self.tableView.reloadData()
        })
        self.termsAndConditionsLeftTextSubscriber = viewModel.$termAndPolicyLeftText
            .sink(receiveValue: { [weak self] text in
                guard let self = self else {return}
                self.useAPIText = text
                self.tableView.reloadData()
        })
    }
    
    private func addLabel(_ label : UILabel) {
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
    }
    
    //  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppViewCell.aboutAppViewCellIdentifier, for: indexPath) as? AboutAppViewCell else {
            print ("cell did not get")
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        guard self.viewModel != nil else { return cell}
        if indexPath.row == 0 {
            cell.set(titleText: self.privatePolicyText)
        } else {
            cell.set(titleText: self.useAPIText)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return self.useAPICellHeight
        default:
            return self.privacyPolicyCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.viewModel?.secondLeftDidTap()
        } else {
            self.viewModel?.thirdLeftDidTap()
        }
    }
}
