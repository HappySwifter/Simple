//
//  Goal.swift
//  Simple
//
//  Created by Artem Valiev on 11.07.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import CoreData


class Goal: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func deleteGoal() {
        let model = Model.instanse
        Model.instanse.managedObjectContext.deleteObject(self)
        model.saveContext()
    }
}
