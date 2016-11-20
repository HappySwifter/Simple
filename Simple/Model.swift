//
//  Model.swift
//  Simple
//
//  Created by Artem Valiev on 11.07.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import CoreData


open class Model: NSObject {

    enum ModelResult: Error {
        case goalsLimit
        case notConnected
        case noData
        case notLogined
        case ok
        case error(errorDesc: String)
    }
    
    static let instanse = Model()
    // MARK: - Core Data stack
   
    
    func saveNewGoal(_ name: String, result: ((ModelResult) -> Void)? = nil)  {
        
        var entity = goalWithName(name)
        if entity == .none  {
            entity = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedObjectContext) as? Goal
            entity?.name = name
        }
        entity?.timeStamp = Date()
        entity?.actions = []
        entity?.archieved = false
        let activeGoals = getActiveGoals()
        if activeGoals.count > 10 {
            entity?.archieved = true
        }
        saveContext()
        result?(.ok)
    }
    
    func goalWithName(_ name: String) -> Goal? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if result.count > 0 {
                return result.first as? Goal
            }
        } catch _ as NSError {
            return .none
        }
        return .none
    }
    
    func getGoals() -> [Goal] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            if let result = try managedObjectContext.fetch(fetchRequest) as? [Goal] {
                return result
            } else {
                return []
            }
        } catch _ as NSError {
            return []
        }
    }
    
    func getActiveGoals() -> [Goal] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        let predicate = NSPredicate(format: "archieved == NO")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            if let result = try managedObjectContext.fetch(fetchRequest) as? [Goal] {
                return result
            } else {
                return []
            }
        } catch _ as NSError {
            return []
        }
    }
    
    
    //MARK - Action
    
    func insertAction(_ goal: Goal, name: String) -> Action {
        var action = actionWithName(name)
        if action == .none  {
            action = NSEntityDescription.insertNewObject(forEntityName: "Action", into: managedObjectContext) as? Action
            action?.name = name
        }
        action?.timestamp = Date()
        action?.priority = NSNumber(value: getLastActionPriority() + 1)
        
        let goal = goalWithName(goal.name!)
        action?.goal = goal
        action?.done = false
        print("insert action. Name: \(action!.name), Priority: \(action!.priority)")
        saveContext()
        return action!
        
    }
    
    func getLastActionPriority() -> Int {
        print("getting getLastActionPriority")
        var result = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Action")
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Action] {
                if let action = results.first {
                    result = action.priority!.intValue
                } else {
                    print("no actions in db")
                }
            }
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        print("getLastActionPriority - \(result)")
        return result
    }
    
    
    func actionWithName(_ name: String) -> Action? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Action")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if result.count > 0 {
                return result.first as? Action
            }
        } catch _ as NSError {
            return .none
        }
        return .none
    }
    

    
//    func getActions(forGoal goal: Goal) -> [Action] {
//        let fetchRequest = NSFetchRequest(entityName: String(Action))
//        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        do {
//            if let result = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Action] {
//                print("returning actions:")
//                print(result.map{ $0.priority! })
//                return result
//            } else {
//                return []
//            }
//        } catch _ as NSError {
//            return []
//        }
//    }
    


//MARK - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sfgyh" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Simple", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

