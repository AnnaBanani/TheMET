//
//  descriptionText.swift
//  TheMET
//
//  Created by Анна Ситникова on 20/07/2023.
//

import Foundation
import UIKit

extension String {
    static  func artistNameText(art: Art) -> String {
        var cellText: String = ""
        if let artistDisplayName = art.artistDisplayName,
           artistDisplayName.isEmpty == false {
            cellText.append(artistDisplayName)
        }
        return cellText
    }
    static  func titleText(art: Art) -> String {
        var cellText: String = ""
        if let title = art.title,
           title.isEmpty == false {
            cellText.append("\"\(title)\"")
        }
        return cellText
    }
    static  func dateText(art: Art) -> String {
        var cellText: String = ""
        if let objectDate = art.objectDate,
           objectDate.isEmpty == false {
            cellText.append(objectDate)
        }
        return cellText
    }
    static  func mediumText(art: Art) -> String {
        var cellText: String = ""
        if let medium = art.medium,
           medium.isEmpty == false {
            cellText.append(medium)
        }
        return cellText
    }
}

