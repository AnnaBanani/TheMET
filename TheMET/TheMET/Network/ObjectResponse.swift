//
//  ObjectResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 04/05/2023.
//

import Foundation
import UIKit

class ObjectResponse: Decodable {
    
    enum DecodeError: Error {
        
        case dateNotConverted
    }

    let objectID: Int

    let isHighlight: Bool

    let accessionNumber: String?

    let accessionYear: String?

    let isPublicDomain: Bool

    let primaryImage: String?

    let primaryImageSmall: String?

    let additionalImages: [String]

    let constituents: [Constituent]

    let department: String?

    let title: String?

    let culture: String?

    let period: String?

    let dynasty: String?

    let reign: String?

    let portfolio: String?

    let artistRole: String?
    
    let artistPrefix: String?

    let artistDisplayName: String?

    let artistDisplayBio: String?

    let artistSuffix: String?

    let artistAlphaSort: String?

    let artistNationality: String?

    let artistBeginDate: String?

    let artistEndDate: String?

    let artistGender: String?

    let artistWikidataUrl: String?

    let artistUlanUrl: String?

    let objectDate: String?

    let objectBeginDate: Int?

    let objectEndDate: Int?

    let medium: String?

    let dimensions: String?

    let measurements: [Measurement]?

    let creditLine: String?

    let geographyType: String?

    let city: String?

    let state: String?

    let county: String?

    let country: String?

    let region: String?

    let subregion: String?

    let locale: String?

    let locus: String?

    let excavation: String?

    let river: String?

    let classification: String?

    let rightsAndReproduction: String?

    let linkResource: String?

    let metadataDate: Date

    let repository: String?

    let objectURL: String?

    let tags: [Tag]?

    let objectWikidataURL: String?

    let isTimelineWork: Bool

    let galleryNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case objectID
        case isHighlight
        case accessionNumber
        case accessionYear
        case isPublicDomain
        case primaryImage
        case primaryImageSmall
        case additionalImages
        case constituents
        case department
        case title
        case culture
        case period
        case dynasty
        case reign
        case portfolio
        case artistRole
        case artistPrefix
        case artistDisplayName
        case artistDisplayBio
        case artistSuffix
        case artistAlphaSort
        case artistNationality
        case artistBeginDate
        case artistEndDate
        case artistGender
        case artistWikidataUrl = "artistWikidata_URL"
        case artistUlanUrl = "artistULAN_URL"
        case objectDate
        case objectBeginDate
        case objectEndDate
        case medium
        case dimensions
        case measurements
        case creditLine
        case geographyType
        case city
        case state
        case county
        case country
        case region
        case subregion
        case locale
        case locus
        case excavation
        case river
        case classification
        case rightsAndReproduction
        case linkResource
        case metadataDate
        case repository
        case objectURL
        case tags
        case objectWikidataURL = "objectWikidata_URL"
        case isTimelineWork
        case galleryNumber = "GalleryNumber"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectID = try container.decode(Int.self, forKey: .objectID)
        self.isHighlight = try container.decode(Bool.self, forKey: .isHighlight)
        self.accessionNumber = try container.decode(String?.self, forKey: .accessionNumber)
        self.accessionYear = try container.decode(String?.self, forKey: .accessionYear)
        self.isPublicDomain = try container.decode(Bool.self, forKey: .isPublicDomain)
        self.primaryImage = try container.decode(String?.self, forKey: .primaryImage)
        self.primaryImageSmall = try container.decode(String?.self, forKey: .primaryImageSmall)
        self.additionalImages = try container.decode([String].self, forKey: .additionalImages)
        self.constituents = try container.decode([Constituent].self, forKey: .constituents)
        self.department = try container.decode(String?.self, forKey: .department)
        self.title = try container.decode(String?.self, forKey: .title)
        self.culture = try container.decode(String?.self, forKey: .culture)
        self.period = try container.decode(String?.self, forKey: .period)
        self.dynasty = try container.decode(String?.self, forKey: .dynasty)
        self.reign = try container.decode(String?.self, forKey: .reign)
        self.portfolio = try container.decode(String?.self, forKey: .portfolio)
        self.artistRole = try container.decode(String?.self, forKey: .artistRole)
        self.artistPrefix = try container.decode(String?.self, forKey: .artistPrefix)
        self.artistDisplayName = try container.decode(String?.self, forKey: .artistDisplayName)
        self.artistDisplayBio = try container.decode(String?.self, forKey: .artistDisplayBio)
        self.artistSuffix = try container.decode(String?.self, forKey: .artistSuffix)
        self.artistAlphaSort = try container.decode(String?.self, forKey: .artistAlphaSort)
        self.artistNationality = try container.decode(String?.self, forKey: .artistBeginDate)
        self.artistBeginDate = try container.decode(String?.self, forKey: .artistBeginDate)
        self.artistEndDate = try container.decode(String?.self, forKey: .artistEndDate)
        self.artistGender = try container.decode(String?.self, forKey: .artistGender)
        self.artistWikidataUrl = try container.decode(String?.self, forKey: .artistWikidataUrl)
        self.artistUlanUrl = try container.decode(String?.self, forKey: .artistUlanUrl)
        self.objectDate = try container.decode(String?.self, forKey: .objectDate)
        self.objectBeginDate = try container.decode(Int?.self, forKey: .objectBeginDate)
        self.objectEndDate = try container.decode(Int?.self, forKey: .objectEndDate)
        self.medium = try container.decode(String?.self, forKey: .medium)
        self.dimensions = try container.decode(String?.self, forKey: .dimensions)
        self.measurements = try container.decode(([Measurement]?).self, forKey: .measurements)
        self.creditLine = try container.decode(String?.self, forKey: .creditLine)
        self.geographyType = try container.decode(String?.self, forKey: .geographyType)
        self.city = try container.decode(String?.self, forKey: .city)
        self.state = try container.decode(String?.self, forKey: .state)
        self.county = try container.decode(String?.self, forKey: .county)
        self.country = try container.decode(String?.self, forKey: .country)
        self.region = try container.decode(String?.self, forKey: .region)
        self.subregion = try container.decode(String?.self, forKey: .subregion)
        self.locale = try container.decode(String?.self, forKey: .locale)
        self.locus = try container.decode(String?.self, forKey: .locus)
        self.excavation = try container.decode(String?.self, forKey: .excavation)
        self.river = try container.decode(String?.self, forKey: .river)
        self.classification = try container.decode(String?.self, forKey: .classification)
        self.rightsAndReproduction = try container.decode(String?.self, forKey: .rightsAndReproduction)
        self.linkResource = try container.decode(String?.self, forKey: .linkResource)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let metadataDateString = try container.decode(String.self, forKey: .metadataDate)
        guard let metadataDate = dateFormatter.date(from: metadataDateString) else {
            throw DecodeError.dateNotConverted
        }
        self.metadataDate = metadataDate
        self.repository = try container.decode(String?.self, forKey: .repository)
        self.objectURL = try container.decode(String?.self, forKey: .objectURL)
        self.tags = try container.decode([Tag]?.self, forKey: .tags)
        self.objectWikidataURL = try container.decode(String?.self, forKey: .objectWikidataURL)
        self.isTimelineWork = try container.decode(Bool.self, forKey: .isTimelineWork)
        self.galleryNumber = try container.decode(String?.self, forKey: .galleryNumber)
    }

    struct Constituent: Decodable {
        private let constituentID: Int
        private let role: String?
        private let name: String?
        private let constituentULAN_URL: String?
        private let constituentWikidata_URL: String?
        private let gender: String?
    }

    struct ElementMeasurement: Decodable {
        private let height: Double
        private let width: Double
    }

    struct Measurement: Decodable {
        private let elementName: String?
        private let elementDescription: String?
        private let elementMeasurements: ElementMeasurement
    }

    struct Tag: Decodable {
        private let term: String
        private let AAT_URL: String?
        private let Wikidata_URL: String?
    }
    
}
