//
//  ObjectResponse.swift
//  TheMET
//
//  Created by Анна Ситникова on 04/05/2023.
//

import Foundation
import UIKit

public class ObjectResponse: Decodable, Encodable {
    
    public enum DecodeError: Error {
        case dateNotConverted
    }

    public let objectID: ArtID

    public let isHighlight: Bool

    public let accessionNumber: String?

    public let accessionYear: String?

    public let isPublicDomain: Bool

    public let primaryImage: String?

    public let primaryImageSmall: String?

    public let additionalImages: [String]

    public let constituents: [Constituent]

    public let department: String?
    
    public let objectName: String?

    public let title: String?

    public let culture: String?

    public let period: String?

    public let dynasty: String?

    public let reign: String?

    public let portfolio: String?

    public let artistRole: String?
    
    public let artistPrefix: String?

    public let artistDisplayName: String?

    public let artistDisplayBio: String?

    public let artistSuffix: String?

    public let artistAlphaSort: String?

    public let artistNationality: String?

    public let artistBeginDate: String?

    public let artistEndDate: String?

    public let artistGender: String?

    public let artistWikidataUrl: String?

    public let artistUlanUrl: String?

    public let objectDate: String?

    public let objectBeginDate: Int?

    public let objectEndDate: Int?

    public let medium: String?

    public let dimensions: String?

    public let measurements: [Measurement]?

    public let creditLine: String?

    public let geographyType: String?

    public let city: String?

    public let state: String?

    public let county: String?

    public let country: String?

    public let region: String?

    public let subregion: String?

    public let locale: String?

    public let locus: String?

    public let excavation: String?

    public let river: String?

    public let classification: String?

    public let rightsAndReproduction: String?

    public let linkResource: String?

    public let metadataDate: Date

    public let repository: String?

    public let objectURL: String?

    public let tags: [Tag]?

    public let objectWikidataURL: String?

    public let isTimelineWork: Bool

    public let galleryNumber: String?
    
    public enum CodingKeys: String, CodingKey {
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
        case objectName
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.objectID, forKey: .objectID)
        try container.encode(self.isHighlight, forKey: .isHighlight)
        try container.encode(self.accessionNumber, forKey: .accessionNumber)
        try container.encode(self.accessionYear, forKey: .accessionYear)
        try container.encode(self.isPublicDomain, forKey: .isPublicDomain)
        try container.encode(self.primaryImage, forKey: .primaryImage)
        try container.encode(self.primaryImageSmall, forKey: .primaryImageSmall)
        try container.encode(self.additionalImages, forKey: .additionalImages)
        try container.encode(self.constituents, forKey: .constituents)
        try container.encode(self.department, forKey: .department )
        try container.encode(self.objectName, forKey: .objectName)
        try container.encode(self.title, forKey: .title )
        try container.encode(self.culture, forKey: .culture )
        try container.encode(self.period, forKey: .period)
        try container.encode(self.dynasty, forKey: .dynasty)
        try container.encode(self.reign, forKey: .reign)
        try container.encode(self.portfolio, forKey: .portfolio)
        try container.encode(self.artistRole, forKey: .artistRole)
        try container.encode(self.artistPrefix, forKey: .artistPrefix)
        try container.encode(self.artistDisplayName, forKey: .artistDisplayName)
        try container.encode(self.artistDisplayBio, forKey: .artistDisplayBio)
        try container.encode(self.artistSuffix, forKey: .artistSuffix)
        try container.encode(self.artistAlphaSort, forKey: .artistAlphaSort)
        try container.encode(self.artistNationality, forKey: .artistNationality)
        try container.encode(self.artistBeginDate, forKey: .artistBeginDate)
        try container.encode(self.artistEndDate, forKey: .artistEndDate)
        try container.encode(self.artistGender, forKey: .artistGender)
        try container.encode(self.artistWikidataUrl, forKey: .artistWikidataUrl)
        try container.encode(self.artistUlanUrl, forKey: .artistUlanUrl)
        try container.encode(self.objectDate, forKey: .objectDate)
        try container.encode(self.objectBeginDate, forKey: .objectBeginDate)
        try container.encode(self.objectEndDate, forKey: .objectEndDate)
        try container.encode(self.medium, forKey: .medium)
        try container.encode(self.dimensions, forKey: .dimensions)
        try container.encode(self.measurements, forKey: .measurements)
        try container.encode(self.creditLine, forKey: .creditLine)
        try container.encode(self.geographyType, forKey: .geographyType)
        try container.encode(self.city, forKey: .city)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.county, forKey: .county)
        try container.encode(self.country, forKey: .country)
        try container.encode(self.region, forKey: .region)
        try container.encode(self.subregion, forKey: .subregion)
        try container.encode(self.locale, forKey: .locale)
        try container.encode(self.locus, forKey: .locus)
        try container.encode(self.excavation, forKey: .excavation)
        try container.encode(self.river, forKey: .river)
        try container.encode(self.classification, forKey: .classification)
        try container.encode(self.rightsAndReproduction, forKey: .rightsAndReproduction)
        try container.encode(self.linkResource, forKey: .linkResource)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let metaDateString = dateFormatter.string(from: self.metadataDate)
        try container.encode(metaDateString, forKey: .metadataDate)
        try container.encode(self.repository, forKey: .repository)
        try container.encode(self.objectURL, forKey: .objectURL)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.objectWikidataURL, forKey: .objectWikidataURL)
        try container.encode(self.isTimelineWork, forKey: .isTimelineWork)
        try container.encode(self.galleryNumber, forKey: .galleryNumber)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectID = try container.decode(ArtID.self, forKey: .objectID)
        self.isHighlight = try container.decode(Bool.self, forKey: .isHighlight)
        self.accessionNumber = try container.decode(String?.self, forKey: .accessionNumber)
        self.accessionYear = try container.decode(String?.self, forKey: .accessionYear)
        self.isPublicDomain = try container.decode(Bool.self, forKey: .isPublicDomain)
        self.primaryImage = try container.decode(String?.self, forKey: .primaryImage)
        self.primaryImageSmall = try container.decode(String?.self, forKey: .primaryImageSmall)
        self.additionalImages = try container.decode([String].self, forKey: .additionalImages)
        do {
            self.constituents = try container.decode([Constituent].self, forKey: .constituents)
        } catch {
            self.constituents = []
        }
        self.department = try container.decode(String?.self, forKey: .department)
        self.objectName = try container.decode(String?.self, forKey: .objectName)
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

    public struct Constituent: Decodable, Encodable {
        private let constituentID: Int
        private let role: String?
        private let name: String?
        private let constituentULAN_URL: String?
        private let constituentWikidata_URL: String?
        private let gender: String?
    }

    public struct ElementMeasurement: Decodable, Encodable {
        private let height: Double?
        private let width: Double?
        private let length: Double?
        private let diameter: Double?
        
        public enum CodingKeys: String, CodingKey {
            case height = "Height"
            case width = "Width"
            case length = "Length"
            case diameter = "Diameter"
        }
    }

    public struct Measurement: Decodable, Encodable {
        private let elementName: String?
        private let elementDescription: String?
        private let elementMeasurements: ElementMeasurement
    }

    public struct Tag: Decodable, Encodable {
        private let term: String
        private let AAT_URL: String?
        private let Wikidata_URL: String?
    }
    
}
