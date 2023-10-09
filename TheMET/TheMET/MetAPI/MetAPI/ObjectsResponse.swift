//
//  ObjectResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/04/2023.
//

import Foundation

public class ObjectsResponse: Decodable {
    
    public var total: Int
    public var objectIDs: [ArtID]
    
}
