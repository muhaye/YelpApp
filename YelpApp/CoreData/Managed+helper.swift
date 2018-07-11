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

    class func managedObjectUpsert<T: NSManagedObject>(_ id: String, uKey: String = "objectId" ) -> T? {
        
        if let entityName = T.entity().name {
            
            let fetchRequest        = NSFetchRequest<T>(entityName: entityName )
            let predicate           = NSPredicate(format: "\(uKey) = %@", id )
            fetchRequest.predicate  = predicate
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                
                if let managedObject = results.first  {
                    return managedObject
                } else {
                    let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
                    managedObject.setValue(id, forKey: uKey)
                    return managedObject as? T
                }
                
            }catch let error{
                print("Got error, sending throught\(error)")
            }
        }

        return nil
    }
    
    class func managedObjectUpsert(_ hours_type: String, business: Business) -> Hour? {
        
        if let entityName = Hour.entity().name {
            
            let fetchRequest        = NSFetchRequest<Hour>(entityName: entityName )
            let predicate           = NSPredicate(format: "hours_type = %@ AND business.objectId = %@ ", hours_type, business.objectId! )
            fetchRequest.predicate  = predicate
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                
                if let managedObject = results.first  {
                    return managedObject
                } else if let hour = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as? Hour {
                    
                    hour.hours_type = hours_type
                    hour.business = business
                    return hour
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
