//
//  Department.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class Department: Decodable {
    
    let departmentId: Int
    
    let displayName: DisplayName
    
    let imageURL: URL?
    
    let numberOfObjects: Int
    
    required init(from decoder: Decoder) throws {
        <#code#>
    }
    
    enum DisplayName: String {
        case id_1 = "American Decorative Arts"
        case id_3 = "Ancient Near Eastern Art"
        case id_4 = "Arms and Armor"
        case id_5 = "Arts of Africa, Oceania, and the Americas"
        case id_6 = "Asian Art"
        case id_7 = "The Cloisters"
        case id_8 = "The Costume Institute"
        case id_9 = "Drawings and Prints"
        case id10 = "Egyptian Art"
        case id_11 = "European Paintings"
        case id_12 = "European Sculpture and Decorative Arts"
        case id_13 = "Greek and Roman Art"
        case id_14 = "Islamic Art"
        case id_15 = "The Robert Lehman Collection"
        case id_16 = "The Libraries"
        case id_17 = "Medieval Art"
        case id_18 = "Musical Instruments"
        case id_19 = "Photographs"
        case id_21 = "Modern Art"
    }
    
}
