//
//  DepartmentsResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 16/05/2023.
//

import Foundation
import UIKit

public class DepartmentsResponse: Decodable {
    
    public let departments: [Department]
    
    public enum CodingKeys: String, CodingKey {
        case departments
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.departments = try container.decode([Department].self, forKey: .departments)
    }
}
