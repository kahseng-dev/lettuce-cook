//
//  ReminderCoreDataAccessLayer.swift
//  lettuce-cook
//
//  Created by Lee Sutton on 27/1/22.
//

import Foundation
import UIKit
import CoreData

class ReminderCoreDataAccessLayer {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(){}
    
    func ReminderExist(reminder:Reminder) -> Bool {
        var exist:Bool = false
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataReminder")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", reminder.identifier)
        
        do {
            let reminders:[NSManagedObject] = try context.fetch(fetchRequest)
            
            if reminders.count != 0 {
                exist = true
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return exist
    }
    
    func AddReminder(reminder:Reminder) {
        if (!ReminderExist(reminder: reminder)) {
            //Add to Core Data
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataReminder", in: context)!
            
            let cdReminder = NSManagedObject(entity: entity, insertInto: context)
            cdReminder.setValue(reminder.identifier, forKey: "identifier")
            cdReminder.setValue(reminder.title, forKey: "title")
            cdReminder.setValue(reminder.body, forKey: "body")
            cdReminder.setValue(reminder.date, forKey: "date")
            cdReminder.setValue(reminder.mealID, forKey: "mealID")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error) \(error.userInfo)")
            }
        }
    }
    
    func RetreiveAllReminders() -> [Reminder] {
        var reminders:[Reminder] = []
        var managedReminders:[NSManagedObject] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataReminder")
        
        do{
            managedReminders = try context.fetch(fetchRequest)
            for r in managedReminders {
                
                let identifier = r.value(forKeyPath: "identifier") as! String
                let title = r.value(forKeyPath: "title") as! String
                let body = r.value(forKeyPath: "body") as! String
                let date = r.value(forKeyPath: "date") as! Date
                let mealID = r.value(forKeyPath: "mealID") as? String
                
                let reminder = Reminder(identifier: identifier,
                                        title: title,
                                        body: body,
                                        date: date,
                                        mealID: mealID)
                
                reminders.append(reminder)
            }
        } catch let error as NSError {
            print("Could not Fetch. \(error) \(error.userInfo)")
        }
        
        return reminders
    }
    
    func DeleteReminder(reminder:Reminder) {
        if (ReminderExist(reminder: reminder)) {
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataReminder")
            fetchRequest.predicate = NSPredicate(format: "identifier = %@", reminder.identifier)
            
            do {
                let reminders:[NSManagedObject] = try context.fetch(fetchRequest)
                context.delete(reminders[0])
                try context.save()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
}
