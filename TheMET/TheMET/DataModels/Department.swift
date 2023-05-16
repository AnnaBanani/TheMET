//
//  Department.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class Department: Decodable {
    
    let departmentId: Int
    
    let displayName: String
    
    init(departmentId: Int, displayName: String) {
        self.departmentId = departmentId
        self.displayName = displayName
    }
    
}
