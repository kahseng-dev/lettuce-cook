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
    
    @IBAction func addReminderButton(_ sender: Any) {
        transitionToAddReminder()
    }
    
    @IBAction func deleteReminderButton(_ sender: Any) {
        tableView.setEditing (
            !tableView.isEditing,
            animated: true
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminders = reminderDAL.RetreiveAllReminders()
        
        self.userNotificationCenter.delegate = self
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reminders = reminderDAL.RetreiveAllReminders()
        
        tableView.reloadData()
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
        
        cell.textLabel?.text = reminder.title
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .short
        cell.detailTextLabel?.text = dateFormat.string(from: reminder.date)
        
        if reminder.mealID != nil {
            cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            reminderDAL.DeleteReminder(reminder: reminders[indexPath.row])
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath],
                                 with: UITableView.RowAnimation.fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reminders[indexPath.row].mealID != nil {
            MealAPICaller.shared.getMeal(mealID: reminders[indexPath.row].mealID!, completion: { [weak self] result in
                switch result {
                case .success(let meal):
                    self?.appDelegate.viewMeal = meal
                            
                    DispatchQueue.main.async {
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
