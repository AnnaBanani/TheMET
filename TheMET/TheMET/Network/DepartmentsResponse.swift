//
//  DepartmentsResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 16/05/2023.
//

import Foundation
import UIKit

class DepartmentsResponse: Decodable {
    
    let departments: [Department]
    
    enum CodingKeys: String, CodingKey {
        case departments
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.departments = try container.decode([Department].self, forKey: .departments)
    }
}
