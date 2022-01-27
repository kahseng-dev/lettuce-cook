//
//  AddReminderViewController.swift
//  lettuce-cook
//
//  Created by Lee Sutton on 27/1/22.
//

import UIKit
import UserNotifications

class AddReminderViewController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var selectedRecipe: Meal? = nil
    
    @IBOutlet weak var reminderErrorLabel: UILabel!
    
    @IBOutlet weak var reminderTitle: UITextField!
    @IBOutlet weak var reminderBody: UITextField!
    @IBOutlet weak var reminderDate: UIDatePicker!
    
    @IBAction func reminderCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setReminderButton(_ sender: Any) {
        if let title = reminderTitle.text,!title.isEmpty, let body = reminderBody.text,!body.isEmpty {
            let date = reminderDate.date
            
            var reminder = Reminder(identifier: "id_\(title)_\(date)",
                                    title: title,
                                    body: body,
                                    date: date,
                                    mealID: nil)
            
            if selectedRecipe != nil {
                reminder.mealID = selectedRecipe?.idMeal
            }
            
            notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, erSror in
                if success {
                    self.scheduleReminder(reminder: reminder)
                    
                    let reminderDAL:ReminderCoreDataAccessLayer = ReminderCoreDataAccessLayer()
                    reminderDAL.AddReminder(reminder: reminder)
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                        
                else {
                    self.reminderErrorLabel.text = "Please Allow Notifications to recieve alerts from LettuceCook!"
                    self.reminderErrorLabel.isHidden = false
                }
            }
        }
        
        else {
            reminderErrorLabel.text = "Please write a title and body for your reminder"
            reminderErrorLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedRecipe)
        
        reminderErrorLabel.isHidden = true
        
        if selectedRecipe != nil {
            reminderTitle.text = "Let us cook \(selectedRecipe!.strMeal!)!"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reminderErrorLabel.isHidden = true
        
        if selectedRecipe != nil {
            reminderTitle.text = "Let us cook \(selectedRecipe!.strMeal!)!"
        }
    }
    
    func scheduleReminder(reminder:Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.sound = .default
        content.body = reminder.body
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminder.date), repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
            
            }
        })
        
    }
}
