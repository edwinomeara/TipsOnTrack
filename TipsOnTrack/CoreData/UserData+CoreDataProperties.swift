//
//  UserData+CoreDataProperties.swift
//  TipsOnTrack
//
//  Created by Edwin  O'Meara on 6/14/18.
//  Copyright © 2018 Edwin  O'Meara. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var hours: Double
    @NSManaged public var date: String
    @NSManaged public var miles: Double
    @NSManaged public var income: Double

}
