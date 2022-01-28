//
//  RecipeDetailsViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RecipeDetailsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let user = FirebaseAuth.Auth.auth().currentUser
    
    var viewMeal:Meal = Meal()
    var isBookmarked:Bool = false
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeArea: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var recipeInstructions: UITextView!
    @IBOutlet weak var recipeBookmarkButtonUI: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func recipeBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recipeInstructionsButton(_ sender: Any) {
        appDelegate.selectedInstructions = viewMeal.strInstructions
    }
    
    @IBAction func recipeBookmarkButton(_ sender: Any) {
        setBookmark()
    }
    
    @IBAction func recipeReminderButton(_ sender: Any) {
        transitionToAddReminder()
    }
    
    @IBAction func recipeShoppingListButton(_ sender: Any) {
        saveToShoppingList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.user == nil {
            recipeBookmarkButtonUI.isEnabled = false
        }
        
        viewMeal = appDelegate.viewMeal
        checkBookmark()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        recipeName.layer.shadowOffset = CGSize(width: 0, height: 1)
        recipeName.layer.shadowOpacity = 0.8
        recipeName.layer.shadowRadius = 2
        
        recipeArea.layer.shadowOffset = CGSize(width: 0, height: 1)
        recipeArea.layer.shadowOpacity = 0.8
        recipeArea.layer.shadowRadius = 2
        
        viewMeal = appDelegate.viewMeal // fetch meal data used for viewing its details
        let imageURL = URL(string: viewMeal.strMealThumb!) // fetch image
        
        URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.recipeName.text = self?.viewMeal.strMeal
                self?.recipeArea.text = self?.viewMeal.strArea
                self?.recipeInstructions.text = self?.viewMeal.strInstructions
                self?.recipeCategory.text = self?.viewMeal.strCategory
                self?.recipeImage.image = UIImage(data: data)
            }
        }.resume()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func checkBookmark() {
        if user != nil {
            let userID = user!.uid
            let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
            
            ref.child("users/\(userID)/bookmarks").observeSingleEvent(of: .value, with: { snapshot in
                let bookmarks = snapshot.value as? [String]
                if bookmarks != nil && bookmarks!.contains(self.viewMeal.idMeal!) {
                    self.recipeBookmarkButtonUI.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    return
                }
            })
        }
    }
    
    func setBookmark() {
        if user != nil {
            let userID = user!.uid
            let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
            
            ref.child("users/\(userID)/bookmarks").observeSingleEvent(of: .value, with: { [self] snapshot in
                var bookmarks = snapshot.value as? [String]
                
                if bookmarks == nil {
                    bookmarks = []
                }
                
                if bookmarks!.contains(self.viewMeal.idMeal!) {
                    bookmarks = bookmarks?.filter { $0 != self.viewMeal.idMeal }
                    ref.child("users/\(userID)/bookmarks").setValue(bookmarks)
                    self.recipeBookmarkButtonUI.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    return
                }
                
                bookmarks?.append(self.viewMeal.idMeal!)
                ref.child("users/\(userID)/bookmarks").setValue(bookmarks)
                self.recipeBookmarkButtonUI.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                return
            })
        }
    }
    
    func saveToShoppingList() {
        if user != nil {
            let userID = user!.uid
            let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
            
            ref.child("users/\(userID)/shoppingList").observeSingleEvent(of: .value, with: { [self] snapshot in
                var shoppingLists = snapshot.value as? [Dictionary<String, Any>]
                
                if shoppingLists == nil {
                    shoppingLists = []
                }
                
                let shoppingList = ["mealID": viewMeal.idMeal!,
                                    "title": viewMeal.strMeal!]
                
                shoppingLists?.append(shoppingList)
                
                ref.child("users/\(userID)/shoppingList").setValue(shoppingLists)
                
                var count = 0
                for recipeIngredient in viewMeal.ingredientList {
                    let ingredient = ["strIngredient" : recipeIngredient.strIngredient,
                                     "strMeasure": recipeIngredient.strMeasure]
                
                    ref.child("users/\(userID)/shoppingList/\(shoppingLists!.count - 1)/ingredients/\(count)").setValue(ingredient)
                    
                    count += 1
                }
                
                showToast(controller: self, message: "Recipe has been to your Shopping List!", seconds: 2)
                return
            })
        }
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.white
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func transitionToAddReminder() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.addReminder) as! AddReminderViewController
        vc.modalPresentationStyle = .fullScreen
        vc.selectedRecipe = viewMeal
        present(vc, animated: true)
    }
}

extension RecipeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.viewIngredient = viewMeal.ingredientList[indexPath.row]
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewMeal.ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.recipeIngredientCell, for: indexPath)
        
        let ingredient = viewMeal.ingredientList[indexPath.row]
        
        cell.textLabel?.text = ingredient.strIngredient
        cell.detailTextLabel?.text = ingredient.strMeasure
        
        return cell
    }
}
