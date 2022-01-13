//
//  RecipeDetailsViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth

class RecipeDetailsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeInstruction: UILabel!
    
    @IBOutlet weak var recipeBookmarkButtonUI: UIButton!
    
    @IBAction func recipeBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recipeBookmarkButton(_ sender: Any) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = FirebaseAuth.Auth.auth().currentUser
        
        if user == nil {
            recipeBookmarkButtonUI.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeName.layer.shadowOffset = CGSize(width: 0, height: 1)
        recipeName.layer.shadowOpacity = 0.8
        recipeName.layer.shadowRadius = 2
        
        let viewMeal = appDelegate.viewMeal // fetch meal data used for viewing its details
        let imageURL = URL(string: viewMeal.strMealThumb!) // fetch image
        
        URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.recipeName.text = viewMeal.strMeal
                self?.recipeInstruction.text = viewMeal.strMeal
                self?.recipeImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
