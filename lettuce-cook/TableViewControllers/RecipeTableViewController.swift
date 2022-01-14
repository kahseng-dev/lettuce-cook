//
//  RecipeTableViewController.swift
//  lettuce-cook
//
//  Created by Mac on 14/1/22.
//

import UIKit

class RecipeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedCategory:Category = Category()
    var recipeList:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        selectedCategory = appDelegate.selectedCategory!
        title = selectedCategory.strCategory
        
        MealAPICaller.shared.getCategoryMeals(category: selectedCategory.strCategory!, completion: { [weak self] result in
            switch result {
            case .success(let meals):
                self?.recipeList = meals
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.recipeCell, for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipeList[indexPath.row]
        
        let imageURL = URL(string: recipe.strMealThumb!) // fetch image
        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                cell.recipeLabel?.text = recipe.strMeal
                cell.recipeImage?.image = UIImage(data: data)
                cell.recipeImage.layer.cornerRadius = 10
            }
        }.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.viewMeal = recipeList[indexPath.row]
        transitionToRecipeDetails()
    }
    
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
