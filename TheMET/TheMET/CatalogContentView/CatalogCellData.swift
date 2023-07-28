//
//  CatalogCellData.swift
//  TheMET
//
//  Created by Анна Ситникова on 08/06/2023.
//

import Foundation
import UIKit

struct CatalogCellData {
    
    var departmentId: Int
    
    var departmentData: DepartmentData
    
    enum DepartmentData {
        case placeholder
        case data(imageURL: URL?, title: String, subTitle: String?)
    }
}
