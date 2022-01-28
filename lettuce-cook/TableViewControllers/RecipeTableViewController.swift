//
//  RecipeTableViewController.swift
//  lettuce-cook
//
//  Created by Mac on 14/1/22.
//

import UIKit

class RecipeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedCategory:Category?
    var recipeList:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        // MARK: this table view class is used for displaying a list of recipes
        
        // if the user has view this list of recipes from the category table view
        // then set the selected category
        selectedCategory = appDelegate.selectedCategory
        
        // if it was from the latest collection view
        if selectedCategory == nil {
            
            // then set the title as latest
            title = "Latest"
            
            // call the function get to get latest meals
            MealAPICaller.shared.getLatestMeals { [weak self] result in
                switch result {
                case .success(let meals):
                    self?.recipeList = meals
                    
                    // reload the tableview once the list has been retrieved
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        // otherwise retrieve the list of recipes by filtering by category
        else {
            title = selectedCategory!.strCategory
            
            MealAPICaller.shared.getCategoryMeals(category: selectedCategory!.strCategory!, completion: { [weak self] result in
                switch result {
                case .success(let meals):
                    self?.recipeList = meals
                    
                    // reload the tableview once the data has been retrieved
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    // once the user has stop using the list of recipe table view, set the selected category variable as nil
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.selectedCategory = nil
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
        
        // retrieve the image of the recipe
        let imageURL = URL(string: recipe.strMealThumb!) // fetch image
        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // once image has been retrieved, set recipe details
            DispatchQueue.main.async {
                cell.recipeLabel?.text = recipe.strMeal
                cell.recipeImage?.image = UIImage(data: data)
                cell.recipeImage.layer.cornerRadius = 10
            }
        }.resume()
        
        return cell
    }
    
    // transcation to recipe details once, the user has select a recipe from the list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // due to the meal api category db recipes not having the details, we will have to fetch the details
        // after the user has selected the recipe from the category table view
        if selectedCategory != nil {
            MealAPICaller.shared.getMeal(mealID: recipeList[indexPath.row].idMeal!, completion: { [weak self] result in
                switch result {
                case .success(let meal):
                    self?.appDelegate.viewMeal = meal
                    
                    DispatchQueue.main.async {
                        // once retrieved, transition to recipe details
                        self?.transitionToRecipeDetails()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
        
        else {
            appDelegate.viewMeal = recipeList[indexPath.row]
            transitionToRecipeDetails()
        }
    }
    
    // MARK: transition to recipe details view controller
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
