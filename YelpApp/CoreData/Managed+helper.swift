//
//  Managed+helper.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    static var managedObjectContext: NSManagedObjectContext {
        return DBUtils.sharedInstance.managedObjectContext
    }

    class func managedObjectUpsert<T: NSManagedObject>(_ id: String) -> T? {
        
        if let entityName = T.entity().name {
            
            let fetchRequest        = NSFetchRequest<T>(entityName: entityName )
            let predicate           = NSPredicate(format: "objectId = %@", id )
            fetchRequest.predicate  = predicate
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                
                if let managedObject = results.first  {
                    return managedObject
                } else {
                    let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
                    return managedObject as? T
                }
                
            }catch let error{
                print("Got error, sending throught\(error)")
            }
        }

        return nil
    }
    
    class func new<T: NSManagedObject>() -> T? {
        
        if let entityName = T.entity().name {
            let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
            return managedObject as? T
        }
        return nil
    }
    
}
