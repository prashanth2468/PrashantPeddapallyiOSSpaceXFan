//
//  SpaceXModel.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 15/08/21.
//

import Foundation

// MARK: - Welcome
struct SpaceXModel: Codable {
    let fairings: Fairings
    let links: Links
  
    let rocket: String
    let success: Bool
    let details: String
   
    enum CodingKeys: String, CodingKey {
        case fairings, links
        case  rocket, success, details
    }
}

// MARK: - Welcome

typealias upcomingSpaceX = [SpaceXUpcomingModel]


struct SpaceXUpcomingModel: Codable {
    let rocket: String
   
    enum CodingKeys: String, CodingKey {
        case  rocket
    }
}


// MARK: - Core
struct Core: Codable {
    let core: String
    let flight: Int
    let gridfins, legs, reused, landingAttempt: Bool
    let landingSuccess: Bool
    let landingType, landpad: String

    enum CodingKeys: String, CodingKey {
        case core, flight, gridfins, legs, reused
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
    }
}

// MARK: - Fairings
struct Fairings: Codable {
    let reused, recoveryAttempt, recovered: Bool
    let ships: [String]

    enum CodingKeys: String, CodingKey {
        case reused
        case recoveryAttempt = "recovery_attempt"
        case recovered, ships
    }
}

// MARK: - Links
struct Links: Codable {
    let patch: Patch
    let reddit: Reddit
    let flickr: Flickr
    let webcast: String
    let youtubeID: String

    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr, webcast
        case youtubeID = "youtube_id"
    
    }
}

// MARK: - Flickr
struct Flickr: Codable {
    let original: [String]
}

// MARK: - Patch
struct Patch: Codable {
    let small, large: String
}

// MARK: - Reddit
struct Reddit: Codable {
    let campaign, launch: String
     let recovery: String
}
