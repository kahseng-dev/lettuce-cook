//
//  BookmarksTableViewController.swift
//  lettuce-cook
//
//  Created by Mac on 14/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BookmarksTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // list of bookmark data to be displayed and used
    var bookmarks:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bookmarks = []
        tableView.reloadData()
        
        // MARK: Retrieving User Logged in Account's Shopping List
        let user = FirebaseAuth.Auth.auth().currentUser
        let userID = user!.uid
        let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
        
        // under the bookmarks attribute in firebase retrieve the array
        ref.child("users/\(userID)/bookmarks").observe(.value, with: { snapshot in
            // the bookmarks are stores the mealIDs as String in a array
            let bookmarkIDs = snapshot.value as? [String]
            
            // check if the bookmarkID string
            if bookmarkIDs != nil {
                // in each bookmark element retrieve the meal data for the bookmarked meal
                for mealID in bookmarkIDs! {
                    MealAPICaller.shared.getMeal(mealID: mealID, completion: { [weak self] result in
                        switch result {
                        case .success(let meal):
                            self?.bookmarks.append(meal)
                            
                            // reload the table view to show the meal
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.bookmarkCell, for: indexPath) as! BookmarkTableViewCell
        
        let bookmark = bookmarks[indexPath.row]
        
        // loading of meal image
        let imageURL = URL(string: bookmark.strMealThumb!) // fetch image
        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // once the image data has been retrieved, list the details of the recipe in the cell
            DispatchQueue.main.async {
                cell.bookmarkLabel?.text = bookmark.strMeal
                cell.bookmarkImage?.image = UIImage(data: data)
                cell.bookmarkImage.layer.cornerRadius = 10
            }
        }.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // when the user clicks on the bookmark meal direct them to the recipe details to view the recipe
        appDelegate.viewMeal = bookmarks[indexPath.row]
        transitionToRecipeDetails()
    }
    
    // MARK: transtition to recipe details view
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
