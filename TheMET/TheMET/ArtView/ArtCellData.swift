//
//  ArtCellData.swift
//  TheMET
//
//  Created by Анна Ситникова on 28/07/2023.
//

import Foundation


struct ArtCellData {
    
    var artID: ArtID
    
    var artData: ArtData
    
    enum ArtData {
        case placeholder
        case data(art: Art)
    }
}
