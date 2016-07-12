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

// Insert code here to add functionality to your managed object subclass

    func deleteAction() {
        let model = Model.instanse
        Model.instanse.managedObjectContext.deleteObject(self)
        model.saveContext()
    }
    func togleDone() {
        let done = Bool(self.done!)
        self.done! = NSNumber(bool: !done)
        Model.instanse.saveContext()
    }
    
}
