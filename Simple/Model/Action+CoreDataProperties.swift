//
//  Action+CoreDataProperties.swift
//  Simple
//
//  Created by Artem Valiev on 11.07.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Action {

    @NSManaged var name: String?
    @NSManaged var priority: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var goal: Goal?

}
