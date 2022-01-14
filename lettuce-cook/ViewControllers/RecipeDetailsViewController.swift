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
    @IBOutlet weak var recipeInstruction: UILabel!
    
    @IBOutlet weak var recipeBookmarkButtonUI: UIButton!
    
    @IBAction func recipeBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recipeBookmarkButton(_ sender: Any) {
        setBookmark()
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
        
        recipeName.layer.shadowOffset = CGSize(width: 0, height: 1)
        recipeName.layer.shadowOpacity = 0.8
        recipeName.layer.shadowRadius = 2
        
        viewMeal = appDelegate.viewMeal // fetch meal data used for viewing its details
        let imageURL = URL(string: viewMeal.strMealThumb!) // fetch image
        
        URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.recipeName.text = self?.viewMeal.strMeal
                self?.recipeInstruction.text = self?.viewMeal.strMeal
                self?.recipeImage.image = UIImage(data: data)
            }
        }.resume()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
}
