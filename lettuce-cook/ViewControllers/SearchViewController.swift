//
//  SearchViewController.swift
//  lettuce-cook
//
//  Created by Lee Sutton on 5/2/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchMealList:[Meal] = []
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchText = searchField.text ?? ""
        
        MealAPICaller.shared.searchMeals(text: searchText, completion: { [weak self] result in
            switch result {
            case .success(let meals):
                self?.searchMealList = meals
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(_):
                self?.searchMealList = []
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func searchFieldReturn(_ sender: UITextField) {
        
        let searchText = searchField.text ?? ""
        
        MealAPICaller.shared.searchMeals(text: searchText, completion: { [weak self] result in
            switch result {
            case .success(let meals):
                self?.searchMealList = meals
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(_):
                self?.searchMealList = []
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchMealList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.searchCell, for: indexPath) as! SearchTableViewCell
        
        let meal = self.searchMealList[indexPath.row]
        
        // loading of meal image
        let imageURL = URL(string: meal.strMealThumb!) // fetch image
        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // once the image data has been retrieved, list the details of the recipe in the cell
            DispatchQueue.main.async {
                cell.searchMealName?.text = meal.strMeal
                cell.searchMealImage?.image = UIImage(data: data)
                cell.searchMealImage.layer.cornerRadius = 10
            }
        }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // when the user clicks on the search meal direct them to the recipe details to view the recipe
        appDelegate.viewMeal = searchMealList[indexPath.row]
        transitionToRecipeDetails()
    }
    
    // MARK: transtition to recipe details view
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
    
