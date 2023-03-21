//
//  Art.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class Art: Decodable {
    
    let objectID: Int
    
    let primaryImage: String?
    
    let department: Department
    
    let objectName: String?
    
    let title: String?
    
    let culture: String?
    
    let period: String?
    
    let artistDisplayName: String?
    
    let artistNationality: String?
    
    let objectDate: String?
    
    let medium: String?
    
    let creditLine: String?
    
    let country: String?
    
    let classification: String?
    
    required init(from decoder: Decoder) throws {
        <#code#>
    }
    

    
}
