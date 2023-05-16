//
//  Department.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class Department: Decodable {
    
    let id: Int
    
    let displayName: String
    
    init(id: Int, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
    
}
