//
//  AboutAppViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 19/01/2024.
//

import Foundation
import UIKit
import Combine

class AboutAppViewModel {

    @Published private(set) var title: String
    @Published private(set) var topImage: UIImage?
    @Published private(set) var firstLeftText: String
    @Published private(set) var firstRightText: String
    @Published private(set) var secondLeftText: String
    @Published private(set) var thirdLeftText: String
    @Published private(set) var bottomText: String
    
    init() {
        self.title = NSLocalizedString("about_app_screen_title", comment: "")
        self.topImage = UIImage(named: "AboutMETIcon")
        self.firstLeftText = NSLocalizedString("about_screen_left_version_label", comment: "")
        self.firstRightText = AboutAppViewModel.getAppVersion()
        self.secondLeftText = NSLocalizedString("privacy_policy_label", comment: "")
        self.thirdLeftText = NSLocalizedString("the_use_of_met_api_label", comment: "")
        self.bottomText = NSLocalizedString("about_scree_copyright_label", comment: "")
    }
    
    private static func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }
    
}
