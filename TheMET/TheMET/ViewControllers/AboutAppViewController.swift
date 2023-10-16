//
//  AboutAppViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/10/2023.
//

import Foundation
import UIKit
import SafariServices

class AboutAppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private let rightVersionLabel: UILabel = UILabel()
    private let leftVersionLabel: UILabel = UILabel()
    private let copyRightLabel: UILabel = UILabel()
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("about_app_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.view.backgroundColor = UIColor(named: "blackberry")
        let appVersion = self.getAppVersion()
        self.addLabel(_ : self.rightVersionLabel, color: UIColor(named: "blueberry"), title: appVersion, textAlignment: .right)
        self.addLabel(_ : self.leftVersionLabel, color: UIColor(named: "plum"), title: NSLocalizedString("about_screen_left_version_label", comment: ""), textAlignment: .left)
        self.addLabel(_ : self.copyRightLabel, color: UIColor(named: "blueberry"), title: NSLocalizedString("about_scree_copyright_label", comment: ""), textAlignment: .left)
        self.imageView.backgroundColor = .clear
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.image = UIImage(named: "AboutMETIcon")
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
            self.tableView.heightAnchor.constraint(equalToConstant: 130 + 53.67)
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
    }
    
    private func addLabel(_ label : UILabel,color: UIColor?, title: String, textAlignment: NSTextAlignment) {
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(font: NSLocalizedString("serif_font", comment: ""), color: color, fontSize: 16, title: title)
        label.textAlignment = textAlignment
        self.view.addSubview(label)
    }
    
    private func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    func showSafariPage(urlString: String) {
        guard let url = URL(string: urlString) else {
            print ("url did not create")
            return
        }
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        present(safariViewController, animated: true)
    }
    
    //  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppViewCell.aboutAppViewCellIdentifier, for: indexPath) as? AboutAppViewCell else {
            print ("cell did not get")
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.set(titleText: NSLocalizedString("privacy_policy_label", comment: ""))
        } else {
            cell.set(titleText: NSLocalizedString("the_use_of_met_api_label", comment: ""))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 130
        default:
            return 53.67
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString = String()
        if indexPath.row == 0 {
            urlString = NSLocalizedString("privacy_policy_url_sring", comment: "")
        } else {
            urlString = "https://www.metmuseum.org/information/terms-and-conditions"
        }
        self.showSafariPage(urlString: urlString)
    }
   
}
