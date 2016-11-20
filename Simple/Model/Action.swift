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

    func deleteAction() {
        let model = Model.instanse
        Model.instanse.managedObjectContext.delete(self)
        model.saveContext()
    }
    func togleDone() {
        let done = Bool(self.done!)
        self.done! = NSNumber(value: !done as Bool)
        Model.instanse.saveContext()
    }
    
}
