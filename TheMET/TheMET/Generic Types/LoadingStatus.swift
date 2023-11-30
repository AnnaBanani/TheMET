//
//  State.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/07/2023.
//

import Foundation

enum LoadingStatus<LoadedData> {
    case loaded(LoadedData)
    case loading
    case failed(Error)
}



