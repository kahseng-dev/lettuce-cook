//
//  Constants.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import Foundation

struct Constants {
    struct Storyboard {
        static let main = "Main"
        static let recipeDetails = "RecipeDetails"
        static let login = "Login"
        static let signUp = "SignUp"
        static let bookmarks = "Bookmarks"
        static let addReminder = "AddReminder"
    }
    
    struct Cell {
        static let browseCell = "browseCell"
        static let latestCell = "latestCell"
        static let bookmarkCell = "bookmarkCell"
        static let recipeCell = "recipeCell"
        static let categoryCell = "categoryCell"
        static let profileLogoutCell = "profileLogoutCell"
        static let profileLoginCell = "profileLoginCell"
        static let recipeIngredientCell = "recipeIngredientCell"
        static let ingredientInfoCell = "ingredientInfoCell"
        static let reminderCell = "reminderCell"
        static let shoppingListCell = "shoppingListCell"
        static let shoppingIngredientCell = "shoppingIngredientCell"
        static let searchCell = "searchCell"
    }
    
    struct Firebase {
        static let databaseURL = "https://lettuce-cook-default-rtdb.asia-southeast1.firebasedatabase.app/"
    }
}
