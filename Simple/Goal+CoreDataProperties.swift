//
//  Goal+CoreDataProperties.swift
//  Simple
//
//  Created by Артем Валиев on 29.06.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Goal {

    @NSManaged var timeStamp: NSDate?
    @NSManaged var name: String?

}
