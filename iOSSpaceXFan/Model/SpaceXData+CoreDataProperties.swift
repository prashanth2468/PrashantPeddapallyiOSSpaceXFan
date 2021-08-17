//
//  SpaceXData+CoreDataProperties.swift
//  
//
//  Created by Rama's_iMac on 16/08/21.
//
//

import Foundation
import CoreData


extension SpaceXData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpaceXData> {
        return NSFetchRequest<SpaceXData>(entityName: "SpaceXData")
    }

    @NSManaged public var spaceXId: String?
    @NSManaged public var desc: String?
    @NSManaged public var isFav: Bool

}
