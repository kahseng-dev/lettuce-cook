//
//  RecipeDetailsViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreData

class RecipeDetailsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // retrieve user
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
    
    // if user clicks on close button, dismiss the view
    @IBAction func recipeBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // if user clicks on the play instructions button, set the selected instructions
    // the app will segue to the play instructions view which useses this to load the instructions
    @IBAction func recipeInstructionsButton(_ sender: Any) {
        appDelegate.selectedInstructions = viewMeal.strInstructions
    }
    
    // save the recipe to the user's bookmark
    @IBAction func recipeBookmarkButton(_ sender: Any) {
        setBookmark()
    }
    
    // set a reminder for current recipe
    @IBAction func recipeReminderButton(_ sender: Any) {
        transitionToAddReminder()
    }
    
    @IBAction func recipeShoppingListButton(_ sender: Any) {
        saveToShoppingList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if user is not logged in, set the bookmark button as disabled, preventing the user
        // from saving to no account
        if self.user == nil {
            recipeBookmarkButtonUI.isEnabled = false
        }
        
        viewMeal = appDelegate.viewMeal
        checkBookmark() // check if the user has bookmarked this recipe before
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // shadow for text
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
                // once the image has been fetched show recipe details
                self?.recipeName.text = self?.viewMeal.strMeal
                self?.recipeArea.text = self?.viewMeal.strArea
                
                // line spacing because font editor keeps reseting on launch
                let instructions = self?.viewMeal.strInstructions ?? ""
                
                let attributedText = NSMutableAttributedString(string: instructions)
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSMutableAttributedString.Key.paragraphStyle,
                                             value: paragraphStyle,
                                             range: NSMakeRange(0, attributedText.length))
                
                attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, attributedText.length))
                
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributedText.length))
                
                self?.recipeInstructions.attributedText = attributedText
                
                // continue adding recipe details
                self?.recipeCategory.text = self?.viewMeal.strCategory
                self?.recipeImage.image = UIImage(data: data)
            }
        }.resume()
    }
    
    // hide the status bar for more viewing angles for the photo
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // a function to check if the user login status and set the bookmark button icon
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
    
    // saving of bookmark to firebase database
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
    
    // transition to add reminder view
    func transitionToAddReminder() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.addReminder) as! AddReminderViewController
        vc.modalPresentationStyle = .fullScreen
        vc.selectedRecipe = viewMeal
        present(vc, animated: true)
    }
}

// MARK: for recipe ingredient table view
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
