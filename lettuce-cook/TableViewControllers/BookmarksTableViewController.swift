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
    
    var bookmarks:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bookmarks = []
        tableView.reloadData()
        
        let user = FirebaseAuth.Auth.auth().currentUser
        let userID = user!.uid
        let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
        
        ref.child("users/\(userID)/bookmarks").observe(.value, with: { snapshot in
            let bookmarkIDs = snapshot.value as? [String]
            
            if bookmarkIDs != nil {
                for mealID in bookmarkIDs! {
                    MealAPICaller.shared.getMeal(mealID: mealID, completion: { [weak self] result in
                        switch result {
                        case .success(let meal):
                            self?.bookmarks.append(meal)
                            
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
        
        let imageURL = URL(string: bookmark.strMealThumb!) // fetch image
        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                cell.bookmarkLabel?.text = bookmark.strMeal
                cell.bookmarkImage.layer.cornerRadius = 10
                cell.bookmarkImage?.image = UIImage(data: data)
            }
        }.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.viewMeal = bookmarks[indexPath.row]
        transitionToRecipeDetails()
    }
    
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
