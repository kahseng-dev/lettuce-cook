//
//  RecipeIngredientDetailsViewController.swift
//  lettuce-cook
//
//  Created by Mac on 24/1/22.
//

import UIKit

class RecipeIngredientDetailsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewIngredient = Ingredient()
    var nutritionInfo:[[String: Any]] = []
    
    // if user clicks on close button, dismiss the view
    @IBAction func ingredientCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientMeasure: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        
        viewIngredient = appDelegate.viewIngredient
        
        ingredientName.text = viewIngredient.strIngredient
        ingredientMeasure.text = viewIngredient.strMeasure
        
        // retrieve the nutritional information for given the ingredient and its measure
        NutritionAPICaller.shared.getNutritionInfo(ingredient: viewIngredient.strIngredient ?? "",
                                                   measure: viewIngredient.strMeasure ?? "",
                                                   completion: { [weak self] result in
            switch result {
            case .success(let nutrition):
                let mirror = Mirror(reflecting: nutrition)
                
                for (_, attr) in mirror.children.enumerated() {
                    let value = attr.value as? Decimal
                    self?.nutritionInfo.append(["label": attr.label!, "value": value!])
                }
                
                DispatchQueue.main.async {
                    // reload the table view once the data has been retrieved
                    self?.tableView.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
        })
    }
}

// MARK: for showing the nutritional information for the given ingredient
extension RecipeIngredientDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

extension RecipeIngredientDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.ingredientInfoCell, for: indexPath)
        
        let nutrition = nutritionInfo[indexPath.row]
        
        cell.textLabel?.text = "\(nutrition["label"]!)"
        cell.detailTextLabel?.text = "\(nutrition["value"]!)"
        
        return cell
    }
}
