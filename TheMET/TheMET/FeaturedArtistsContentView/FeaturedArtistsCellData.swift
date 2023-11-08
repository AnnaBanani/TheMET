//
//  FeaturedArtistsCellData.swift
//  TheMET
//
//  Created by Анна Ситникова on 07/11/2023.
//

import Foundation
import UIKit

struct FeaturedArtistsCellData {
    
    var artistId: Int
    
    var artistData: ArtistData
    
    enum ArtistData {
        case placeholder
        case data(imageURL: URL?, title: String, subTitle: String?)
    }
    
}
