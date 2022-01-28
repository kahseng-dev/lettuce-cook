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
    
    // if the user clicks on the reminder close button, dismiss the view
    @IBAction func reminderCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // if the user clicks on the set reminder button...
    @IBAction func setReminderButton(_ sender: Any) {
        // check if the user has filled in the fields
        if let title = reminderTitle.text,!title.isEmpty, let body = reminderBody.text,!body.isEmpty {
            let date = reminderDate.date
            
            // create the reminder
            var reminder = Reminder(identifier: "id_\(title)_\(date)",
                                    title: title,
                                    body: body,
                                    date: date,
                                    mealID: nil)
            
            // if there is a selected recipe
            if selectedRecipe != nil {
                // then set the mealid of the reminder
                reminder.mealID = selectedRecipe?.idMeal
            }
            
            // then request access for notifications
            notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, erSror in
                if success {
                    // if successful, sechdule the reminder
                    self.scheduleReminder(reminder: reminder)
                    
                    // store the reminder as a record in the core data
                    let reminderDAL:ReminderCoreDataAccessLayer = ReminderCoreDataAccessLayer()
                    reminderDAL.AddReminder(reminder: reminder)
                    
                    DispatchQueue.main.async {
                        // then dismiss the add reminder view once it is completed
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                // otherwise, if the user did not allow notifications
                else {
                    // show error
                    self.reminderErrorLabel.text = "Please Allow Notifications to recieve alerts from LettuceCook!"
                    self.reminderErrorLabel.isHidden = false
                }
            }
        }
        
        // otherwise, if the user did not field in the text
        else {
            // show erorr
            reminderErrorLabel.text = "Please write a title and body for your reminder"
            reminderErrorLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderErrorLabel.isHidden = true
        
        // if there is a selected recipe
        if selectedRecipe != nil {
            // set premade text for the selected recipe
            reminderTitle.text = "Let us cook \(selectedRecipe!.strMeal!)!"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reminderErrorLabel.isHidden = true
        
        // if there is a selected recipe
        if selectedRecipe != nil {
            // set a premade text for the selected recipe
            reminderTitle.text = "Let us cook \(selectedRecipe!.strMeal!)!"
        }
    }
    
    // MARK: for sechduling the reminder for notifcation
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
