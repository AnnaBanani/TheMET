//
//  CatalogSectionCellData.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/12/2023.
//

import Foundation
import UIKit

struct CatalogSectionCellData <T> {
    
    var identificator: T
    
    var data: CellData
    
    enum CellData {
        case placeholder
        case data(imageURL: URL?, title: String, subTitle: String?)
    }
}
