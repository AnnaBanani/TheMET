//
//  ArtFilter.swift
//  TheMET
//
//  Created by Анна Ситникова on 10/08/2023.
//

import Foundation
import UIKit

class ArtFilter {
    func filter(arts: [Art], searchText: String?) -> [Art] {
        guard let searchText = searchText, !searchText.isEmpty else {
            return arts
        }
        var filteredArts:[Art] = []
        for art in arts {
            if self.filter(artProperty: art.artistDisplayName, searchText: searchText) ||
                self.filter(artProperty: art.department, searchText: searchText) ||
                self.filter(artProperty: art.medium, searchText: searchText) ||
                self.filter(artProperty: art.objectName, searchText: searchText) ||
                self.filter(artProperty: art.title, searchText: searchText) {
                filteredArts.append(art)
            }
        }
        return filteredArts
    }
    
    private func filter(artProperty: String?, searchText: String) -> Bool {
        if let artProperty = artProperty,
           artProperty.range(of: searchText, options: .caseInsensitive) != nil {
            return true
        } else {
            return false
        }
    }
    
}
