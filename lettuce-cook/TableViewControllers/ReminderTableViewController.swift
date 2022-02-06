//
//  ReminderTableViewController.swift
//  lettuce-cook
//
//  Created by Lee Sutton on 27/1/22.
//

import UIKit

class ReminderTableViewController:UITableViewController, UNUserNotificationCenterDelegate {
    
    var reminders:[Reminder] = []
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reminderDAL:ReminderCoreDataAccessLayer = ReminderCoreDataAccessLayer()
    
    @IBOutlet weak var clearAllButtonUI: UIButton!
    
    @IBAction func clearAllButton(_ sender: Any) {
        
        // clear core data
        reminderDAL.ClearAllReminder()
        
        tableView.isEditing = false
        clearAllButtonUI.isHidden = true
        reminders = []
        tableView.reloadData()
    }
    
    // upon clicking add reminder button, navigate to add reminder view
    @IBAction func addReminderButton(_ sender: Any) {
        transitionToAddReminder()
    }
    
    // upon clicking delete reminder button, change table view into edit mode
    @IBAction func deleteReminderButton(_ sender: Any) {
        tableView.setEditing (
            !tableView.isEditing,
            animated: true
        )
        
        // when tableview is editing state, show clear all button
        if (tableView.isEditing) {
            clearAllButtonUI.isHidden = false
        }
        else {
            clearAllButtonUI.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initalise the reminder table with core data reminders
        reminders = reminderDAL.RetreiveAllReminders()
        
        self.userNotificationCenter.delegate = self
        
        tableView.reloadData()
        
        clearAllButtonUI.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reminders = reminderDAL.RetreiveAllReminders()
        
        tableView.reloadData()
        
        clearAllButtonUI.isHidden = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.reminderCell, for: indexPath)
        
        let reminder = reminders[indexPath.row]
        
        // set reminder title as textlabel
        cell.textLabel?.text = reminder.title
        
        // set reminder date as detailtextlabel
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .short
        cell.detailTextLabel?.text = dateFormat.string(from: reminder.date)
        
        // if there is a meal id add a detail button to accessory
        if reminder.mealID != nil {
            cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // when delete, update table view and delete reminder from core data
        if editingStyle == UITableViewCell.EditingStyle.delete {
            reminderDAL.DeleteReminder(reminder: reminders[indexPath.row])
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath],
                                 with: UITableView.RowAnimation.fade)
        }
    }
    
    // if there is a meal id set for the reminder, upon clicking the reminder record, view the recipe details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reminders[indexPath.row].mealID != nil {
            MealAPICaller.shared.getMeal(mealID: reminders[indexPath.row].mealID!, completion: { [weak self] result in
                switch result {
                case .success(let meal):
                    self?.appDelegate.viewMeal = meal
                            
                    DispatchQueue.main.async {
                        // once retrieved, transition to recipe details
                        self?.transitionToRecipeDetails()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func transitionToAddReminder() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.addReminder) as! AddReminderViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // MARK: set notifiaction to display when the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
