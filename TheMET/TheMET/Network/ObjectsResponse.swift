//
//  ObjectResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/04/2023.
//

import Foundation

class ObjectsResponse: Decodable {
    
    var total: Int
    var objectIDs: [Int]
    
}
