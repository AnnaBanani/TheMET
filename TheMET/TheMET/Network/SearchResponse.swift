//
//  SearchResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/05/2023.
//

import Foundation
import UIKit

class SearchResponse: Decodable {
    
    let total: Int
    let objectIDs:[ArtID]
    
}

enum SearchParameter {
    case q(String)
    case isHighlight(Bool)
    case title(Bool)
    case tags(Bool)
    case departmentId(Int)
    case isOnView(Bool)
    case artistOrCulture(Bool)
    case medium(String)
    case hasImages(Bool)
    case geoLocation(String)
    case dates((from: Int, to: Int))
}
