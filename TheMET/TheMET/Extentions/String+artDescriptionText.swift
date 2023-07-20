//
//  descriptionText.swift
//  TheMET
//
//  Created by Анна Ситникова on 20/07/2023.
//

import Foundation
import UIKit

extension String {
    static  func artDescriptionText(art: Art) -> String {
        var cellText: String = ""
        if let artistDisplayName = art.artistDisplayName,
           artistDisplayName.isEmpty == false {
            cellText.append(artistDisplayName + "\n")
        }
        if let title = art.title,
           title.isEmpty == false {
            cellText.append(title + "\n")
        }
        if let objectDate = art.objectDate,
           objectDate.isEmpty == false {
            cellText.append(objectDate + "\n")
        }
        if let medium = art.medium,
           medium.isEmpty == false {
            cellText.append(medium + "\n")
        }
        return cellText
    }
}

