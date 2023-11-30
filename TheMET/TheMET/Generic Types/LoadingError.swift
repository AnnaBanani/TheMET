//
//  LoadingError.swift
//  TheMET
//
//  Created by Анна Ситникова on 29/11/2023.
//

import Foundation

enum ArtsLoadingError: Error {
    case noSearchResult
}

enum ArtImageLoadingError: Error {
    case imageCannotBeLoadedFromURL
    case invalidImageURL
}
