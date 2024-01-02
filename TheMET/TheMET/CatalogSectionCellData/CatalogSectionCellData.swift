//
//  CatalogSectionCellData.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/12/2023.
//

import Foundation
import UIKit

struct CatalogSectionCellData <T> {
    
    var sectionIdentificator: T
    
    var data: SectionData
    
    enum SectionData {
        case placeholder
        case data(imageURL: URL?, title: String, subTitle: String?)
    }
}
