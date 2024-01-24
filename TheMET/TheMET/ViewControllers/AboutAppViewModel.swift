//
//  AboutAppViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 19/01/2024.
//

import Foundation
import UIKit
import Combine
import SafariServices

class AboutAppViewModel {

    @Published private(set) var title: String
    @Published private(set) var topImage: UIImage?
    @Published private(set) var versionText: String
    @Published private(set) var versionNumberText: String
    @Published private(set) var privatePolicyText: String
    @Published private(set) var termAndPolicyLeftText: String
    @Published private(set) var copyRightText: String
    
    private let presentingControllerProvider: () -> UIViewController?
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.title = NSLocalizedString("about_app_screen_title", comment: "")
        self.topImage = UIImage(named: "AboutMETIcon")
        self.versionText = NSLocalizedString("about_screen_left_version_label", comment: "")
        self.versionNumberText = AboutAppViewModel.getAppVersion()
        self.privatePolicyText = NSLocalizedString("privacy_policy_label", comment: "")
        self.termAndPolicyLeftText = NSLocalizedString("the_use_of_met_api_label", comment: "")
        self.copyRightText = NSLocalizedString("about_scree_copyright_label", comment: "")
        self.presentingControllerProvider = presentingControllerProvider
    }
    
    private static func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    func privatePolicyButtonDidTap() {
        self.showSafariPage(url: .privatePolicyURL)
    }
    
    func termsAndConditionsButtonDidTap() {
        self.showSafariPage(url: .termsAndConditionsURL)
    }
    
    private func showSafariPage(url: URL?) {
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        guard let url = url else {
            print ("url did not create")
            return
        }
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        presentingController.present(safariViewController, animated: true)
    }
}

private extension URL {
    static let privatePolicyURL: URL? = URL(string: NSLocalizedString("privacy_policy_url_sring", comment: ""))
    static let termsAndConditionsURL: URL? = URL(string:"https://www.metmuseum.org/information/terms-and-conditions")
}
