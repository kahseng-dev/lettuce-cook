//
//  ShoppingIngredientTableViewController.swift
//  lettuce-cook
//
//  Created by MAD2 on 28/1/22.
//

import UIKit

class ShoppingIngredientTableViewController:UITableViewController {
 
    var shoppingListIngredient:[Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListIngredient.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.shoppingListCell, for: indexPath)
        
        let shoppingListIngredient = shoppingListIngredient[indexPath.row]
        
        cell.textLabel?.text = shoppingListIngredient.strIngredient
        
        return cell
    }
}
