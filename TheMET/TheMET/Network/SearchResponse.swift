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

enum SearchParameter: Equatable {
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
    
    // Equatable
    static func == (lhs: SearchParameter, rhs: SearchParameter) -> Bool {
        switch (lhs, rhs) {
        case (.q(let string1), .q(let string2)):
            return string1 == string2
        case (.isHighlight(let bool1), .isHighlight(let bool2)):
            return bool1 == bool2
        case (.title(let bool1), .title(let bool2)):
            return bool1 == bool2
        case (.tags(let bool1), .tags(let bool2)):
            return bool1 == bool2
        case (.departmentId(let int1), .departmentId(let int2)):
            return int1 == int2
        case (.isOnView(let bool1), .isOnView(let bool2)):
            return bool1 == bool2
        case (.artistOrCulture(let bool1), .artistOrCulture(let bool2)):
            return bool1 == bool2
        case (.medium(let string1), .medium(let string2)):
            return string1 == string2
        case (.hasImages(let bool1), .hasImages(let bool2)):
            return bool1 == bool2
        case (.geoLocation(let string1), .geoLocation(let string2)):
            return string1 == string2
        case (.dates(let tuple1), .dates((let tuple2))):
            return tuple1.from == tuple2.from && tuple1.to == tuple2.to
        default:
            return false
        }
    }
}
