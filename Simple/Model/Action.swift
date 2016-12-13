//
//  Action.swift
//  Simple
//
//  Created by Артем Валиев on 12.07.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import CoreData

@objc(Action)
class Action: NSManagedObject {

    func delete() {
        let model = Model.instanse
        Model.instanse.managedObjectContext.delete(self)
        model.saveContext()
    }
    func setUndone() {
        self.done! = NSNumber(value: false)
        Model.instanse.saveContext()
    }
    
    func setDone() {
        self.done! = NSNumber(value: true)
        Model.instanse.saveContext()
    }
}
