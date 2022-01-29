//
//  ShoppingIngredientTableViewController.swift
//  lettuce-cook
//
//  Created by MAD2 on 28/1/22.
//

import UIKit

class ShoppingIngredientTableViewController:UITableViewController {
 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var shoppingListIngredient:[Ingredient] = []
    var selectedShoppingList:ShoppingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedShoppingList = appDelegate.selectedShoppingList
        
        if selectedShoppingList != nil {
            // Set shoppingListIngredient list to selectedShoppingList ingredients list
            shoppingListIngredient = selectedShoppingList!.ingredients
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListIngredient.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.shoppingIngredientCell, for: indexPath)
        
        let shoppingListIngredient = shoppingListIngredient[indexPath.row]
        
        // Set title and measure to recipe ingredient
        cell.textLabel?.text = shoppingListIngredient.strIngredient
        cell.detailTextLabel?.text = shoppingListIngredient.strMeasure
        
        return cell
    }

}
