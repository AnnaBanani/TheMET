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
        "Rembrandt (Rembrandt van Rijn)",
        "Pierre Bonnard",
        "Giacomo Guardi",
        "Marsden Hartley",
        "Dagobert Peche",
        "Diego Rivera",
        "Joan Miró",
        "Henri de Toulouse-Lautrec",
        "Georges Braque",
        "William Kentridge",
        "John Marin",
        "Romare Bearden",
        "Jim Dine",
        "Amedeo Modigliani",
        "Abraham Rattner",
        "Ellsworth Kelly",
        "Pablo Picasso",
        "Raoul Dufy",
        "Hans Hofmann",
        "Andor Weininger",
        "Anselm Kiefer",
        "Boris Solotareff",
        "Maurice Brazil Prendergast",
        "Charles Demuth",
        "Henri Matisse",
        "Fernand Léger",
        "Abraham Walkowitz",
        "Mark Rothko",
        "aul Signac",
        "Andy Warhol",
        "Ardeshir Mohassess",
        "José Luis Cuevas",
        "Wiener Werkstätte",
        "Jackson Pollock",
        "Thomas Hart Benton",
        "Reginald Marsh",
        "Arthur Dove",
        "Max Beckmann",
        "Fairfield Porter",
        "Lucien Lévy-Dhurmer",
        "Paul Klee",
        "Jules Pascin",
        "Edvard Munch",
        "Raphael Soyer",
        "Robert Motherwell",
        "Gunta Stölzl",
        "Adolf Dehn",
        "Carlo Scarpa",
        "Egon Schiele",
        "Margarete Willers",
        "Jean Dubuffet",
        "Giovanni Battista Tiepolo",
        "Dorothy Liebes",
        "Anni Albers",
        "Giovanni Domenico Tiepolo",
        "Umberto Boccioni",
        "Joseph Urban"
    ]
    
    
    
}
