//
//  State.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/07/2023.
//

import Foundation

enum LoadingStatus<LoadedData, FailedData> {
    case loaded(LoadedData)
    case loading
    case failed(FailedData)
}


enum FailedData {
    case noInternet
    case noSearchingResult
}
