//
//  PersistenceService.swift
//  DeliveryDriverDevice
//
//  Created by Edwin  O'Meara on 5/24/18.
//  Copyright © 2018 Edwin  O'Meara. All rights reserved.
//
import CoreData
import Foundation

class PersistenceService {
    
    private init(){}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TipsOnTrack")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            } catch {
                let err = error as NSError
                fatalError("Unresolved error \(err), \(err.userInfo)")
                //when shipping product dont use fatalError--------------------------------------------------------------
            }
        }
    }
}

