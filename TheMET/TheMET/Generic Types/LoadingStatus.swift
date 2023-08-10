//
//  State.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/07/2023.
//

import Foundation

enum LoadingStatus<T> {
    case loaded(T)
    case loading
    case failed
}