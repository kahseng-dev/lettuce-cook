//
//  ShoppingListTableViewController.swift
//  lettuce-cook
//
//  Created by MAD2 on 28/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShoppingListTableViewController:UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var shoppingList:[ShoppingList] = []
    
    // upon clicking delete reminder button, change table view into edit mode
    
    @IBAction func deleteShoppingListButton(_ sender: Any) {
        tableView.setEditing (
            !tableView.isEditing,
            animated: true
        )
    }
    
    /*
    @IBAction func deleteShoppingList(_ sender: Any) {
        tableView.setEditing (
            !tableView.isEditing,
            animated: true
        )
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        // authenticate firebase
        let user = FirebaseAuth.Auth.auth().currentUser
        let userID = user!.uid
        let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
        
        ref.child("users/\(userID)/shoppingList").observe(.value, with: { snapshot in
            
            var shoppingLists:[ShoppingList] = []
            
            if snapshot.exists() {
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in result {
                        let array = child.value as! [String: AnyObject]
                    
                        
                        // convert ingredients into an NSArray
                        let NSingredients = array["ingredients"] as? NSArray
                        var ingredientList:[Ingredient] = []
                        
                        // loop through ingredient array to retrieve each ingredient name and measure
                        if NSingredients != nil {
                            for NSElement in NSingredients! {
                                
                                let ingredientObject = NSElement as AnyObject
                                
                                let ingredient = Ingredient(strIngredient: ingredientObject["strIngredient"] as? String,
                                                            strMeasure: ingredientObject["strMeasure"] as? String)
                                ingredientList.append(ingredient)
                            }
                            
                            // add mealid and title into shoppinglist
                            let shoppingList = ShoppingList(mealID: array["mealID"] as? String,
                                                            title: array["title"] as! String,
                                                            ingredients: ingredientList)
                            
                            //append all recipe info into shoppinglist array
                            shoppingLists.append(shoppingList)
                        }

                    }
                }
            }
            
            self.shoppingList = shoppingLists
            self.tableView.reloadData()
            
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.shoppingListCell, for: indexPath)
        
        // find shoppinglist object based on indexPath.row
        let shoppingList = shoppingList[indexPath.row]
        
        // set cell title as recipe name
        cell.textLabel?.text = shoppingList.title
        
        return cell
    }
    
    // delete shopping list recipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // when delete, update table view and delete reminder from core data
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //reminderDAL.DeleteReminder(reminder: reminders[indexPath.row])
            
            // Delete row from firebase
            let user = FirebaseAuth.Auth.auth().currentUser
            let userID = user!.uid
            let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
            
            // Remove shoppinglist row after user delete
            shoppingList.remove(at: indexPath.row)
            
            ref.child("users/\(userID)/shoppingList").observeSingleEvent(of: .value, with: { snapshot in
                
                // Create new copy dictionary of firebase db
                var shoppingListDictionary = snapshot.value as? [Dictionary<String, Any>]
                
                // Check if firebase copy dictionary is empty
                if shoppingListDictionary == nil {
                    shoppingListDictionary = []
                }
                
                // Remove row in copied dictionary
                shoppingListDictionary?.remove(at: indexPath.row)
                
                // Update value in firebase based on copied dictionary
                ref.child("users/\(userID)/shoppingList").setValue(shoppingListDictionary)
            })

            tableView.deleteRows(at: [indexPath as IndexPath],
                                 with: UITableView.RowAnimation.fade)
        }
    }
    
    // pass clicked row object to shoppingingredient table view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.selectedShoppingList = shoppingList[indexPath.row]
    }
    
}
