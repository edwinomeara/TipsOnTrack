//
//  Counter+CoreDataProperties.swift
//  TipsOnTrack
//
//  Created by Edwin  O'Meara on 7/8/18.
//  Copyright © 2018 Edwin  O'Meara. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var count: Int16

}
