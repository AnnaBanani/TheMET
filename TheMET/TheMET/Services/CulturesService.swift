//
//  CulturesService.swift
//  TheMET
//
//  Created by Анна Ситникова on 12/12/2023.
//


import Foundation
import UIKit
import Combine
import MetAPI

class CulturesService {
    
    static let standart: CulturesService = CulturesService()
    
    private init() {
    }
    
    @Published private(set) var culturesList: [String] = [
        "Japanese",
        "Chinese",
        "Indonesia",
        "Italian",
        "American",
        "German",
        "Swiss",
        "Belgian",
        "French",
        "Thailand",
        "Assyrian",
        "Spanish",
        "Portuguese",
        "European",
        "Cypriot",
        "Russian",
        "Mexican",
        "Greek",
        "Babylonian",
        "Iranian",
        "Sasanian",
        "British",
        "Roman",
        "Coptic",
        "Austrian",
        "Moche",
        "Byzantine",
        "Etruscan"
        ]
        
}
