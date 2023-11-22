//
//  ArtistsService.swift
//  TheMET
//
//  Created by Анна Ситникова on 13/11/2023.
//

import Foundation
import UIKit
import Combine
import MetAPI

class ArtistsService {
    
    static let standart: ArtistsService = ArtistsService()
    
    private init() {
    }
    
    @Published private(set) var artistsList: [String] = [
        "Gustave Courbet",
        "Rembrandt",
        "Giovanni Battista Tiepolo",
        "Henri de Toulouse-Lautrec",
        "Camille Pissarro",
        "Anthony van Dyck",
        "Edgar Degas",
        "Auguste Renoir",
        "Camille Corot",
        "Vincent van Gogh",
        "Claude Monet",
        "Peter Paul Rubens",
        "Paul Cézanne",
        "Edouard Manet",
        "Giacomo Guardi",
        "Amedeo Modigliani",
        "Wiener Werkstätte",
        "Thomas Hart Benton",
        "Egon Schiele",
        "Giovanni Domenico Tiepolo",
        "Umberto Boccioni"
    ]
    
}
