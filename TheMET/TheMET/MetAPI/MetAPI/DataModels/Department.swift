//
//  Department.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

public class Department: Decodable {
    
    public let id: Int
    
    public let displayName: String
    
    public enum CodingKeys: String, CodingKey {
        case id = "departmentId"
        case displayName
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.displayName = try container.decode(String.self, forKey: .displayName)
    }
    
}
