//
//  CategoriesTableViewController.swift
//  lettuce-cook
//
//  Created by Mac on 14/1/22.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var categoriesList:[Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        // retrieve a list of categories from the API
        MealAPICaller.shared.getCategoriesList(completion: { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categoriesList = categories
                
                // reload the table view once the data has been retrieved
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cell.categoryCell, for: indexPath) as! CategoriesTableViewCell
        
        let category = categoriesList[indexPath.row]
        
        // retrieve the image of the category
        let imageURL = URL(string: category.strCategoryThumb!) // fetch image
        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // once the image has been retrieved, show the details of the category
            DispatchQueue.main.async {
                cell.categoryLabel.text = category.strCategory
                cell.categoryImage.image = UIImage(data: data)
                
                cell.categoryLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
                cell.categoryLabel.layer.shadowOpacity = 0.8
                cell.categoryLabel.layer.shadowRadius = 2
                cell.categoryImage.layer.cornerRadius = 10
            }
        }.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.selectedCategory = categoriesList[indexPath.row]
    }
}
