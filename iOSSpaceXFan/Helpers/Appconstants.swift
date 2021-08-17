//
//  Appconstants.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 16/08/21.
//

import Foundation


class SpaceXConfig {
    /// the singleton
    static let sharedInstance = SpaceXConfig()
    // This prevents others from using the default '()' initializer for this class.
    fileprivate init() {
        loadConfig()
    }
    /// the config dictionary
    var config: NSDictionary?
    /**
     Load config from Config.plist
     */
    func loadConfig() {
        if let path = Bundle.main.path(forResource: "Services", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
            // print(config!)
        }
    }
    
    func getSpaceXListAPIKey() -> String {
        if let conf = config, let baseUrl = conf.value(forKey: "SpaceXList") as? String {
            return baseUrl
        }
        return ""
    }

    func getSpaceXUpcomingListAPIKey() -> String {
        if let conf = config, let baseUrl = conf.value(forKey: "SpaceXUpcomingList") as? String {
            return baseUrl
        }
        return ""
    }
}
