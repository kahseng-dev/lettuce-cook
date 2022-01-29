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
    
    var shoppingList:[ShoppingList] = []
    
    
    // upon clicking delete reminder button, change table view into edit mode
    @IBAction func deleteShoppingList(_ sender: Any) {
        tableView.setEditing (
            !tableView.isEditing,
            animated: true
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        let user = FirebaseAuth.Auth.auth().currentUser
        let userID = user!.uid
        let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
        
        ref.child("users/\(userID)/shoppingList").observe(.value, with: { snapshot in
            
            var shoppingLists:[ShoppingList] = []
            
            if snapshot.exists() {
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in result {
                        let array = child.value as! [String: AnyObject]
                        
                        var shoppingList = ShoppingList(mealID: array["mealID"] as? String,
                                                        title: array["title"] as! String)
                        
                        let NSingredients = array["ingredients"] as? NSArray
                        var ingredientList:[Ingredient] = []
                        
                        if NSingredients != nil {
                            for NSElement in NSingredients! {
                                
                                let ingredientObject = NSElement as AnyObject
                                
                                let ingredient = Ingredient(strIngredient: ingredientObject["strIngredient"] as? String,
                                                            strMeasure: ingredientObject["strMeasure"] as? String)
                                ingredientList.append(ingredient)
                            }
                            
                            shoppingList.ingredients = ingredientList
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
        
        let shoppingList = shoppingList[indexPath.row]
        
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
                    
            ref.child("users/\(userID)/shoppingList").observe(.value, with: { snapshot in
                if snapshot.exists() {
                    print(snapshot.ref.child("\(indexPath.row)"))
                    snapshot.ref.child("\(indexPath.row)").removeValue()
                }
                
            })
            // Remove shoppinglist row after user delete
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath],
                                 with: UITableView.RowAnimation.fade)
        }
    }
    
}
