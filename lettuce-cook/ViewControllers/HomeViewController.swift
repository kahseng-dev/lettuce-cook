//
//  HomeViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var featuredMealImage: UIImageView!
    @IBOutlet weak var featuredMealName: UILabel!
    
    @IBOutlet weak var browseCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var mealList:[Meal] = []
    var featuredMeal:Meal = Meal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featuredMealImage.layer.masksToBounds = true
        featuredMealImage.layer.cornerRadius = 15
        
        featuredMealName.layer.shadowOffset = CGSize(width: 0, height: 1)
        featuredMealName.layer.shadowOpacity = 0.8
        featuredMealName.layer.shadowRadius = 2
        
        browseCollectionView.dataSource = self
        browseCollectionView.delegate = self
        
        MealAPICaller.shared.getRandomMeal { [weak self] result in
            switch result {
            case .success(let meals):
                if (meals[0].strMealThumb != nil) {
                    // fetch image
                    let imageURL = URL(string: meals[0].strMealThumb!)
                    URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
                        
                        guard let data = data, error == nil else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self?.featuredMealName.text = meals[0].strMeal
                            self?.featuredMealImage.image = UIImage(data: data)
                            
                            let imageTap = UITapGestureRecognizer(target: self, action: #selector(self?.recipeImageTap))
                            
                            self?.featuredMeal = Meal(idMeal: meals[0].idMeal,
                                                strMeal: meals[0].strMeal,
                                                strCategory: meals[0].strCategory,
                                                strArea: meals[0].strArea,
                                                strMealThumb: meals[0].strMealThumb)
                            
                            self?.featuredMealImage.isUserInteractionEnabled = true
                            self?.featuredMealImage.addGestureRecognizer(imageTap)
                        }
                    }.resume()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        MealAPICaller.shared.get10RandomMeals { [weak self] result in
            switch result {
            case .success(let meals):
                for meal in meals {
                    let newMeal = Meal(idMeal: meal.idMeal,
                                       strMeal: meal.strMeal,
                                       strCategory: meal.strCategory,
                                       strArea: meal.strArea,
                                       strMealThumb: meal.strMealThumb
                    )
                    self?.mealList.append(newMeal)
                }
                
                DispatchQueue.main.async {
                    self?.browseCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func recipeImageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        appDelegate.viewMeal = featuredMeal
        transitionToRecipeDetails()
    }
    
    func transitionToRecipeDetails() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.recipeDetails) as! RecipeDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.browseCell, for: indexPath) as! BrowseCollectionViewCell
        
        cell.browseRecipeImage.layer.masksToBounds = true
        cell.browseRecipeImage.layer.cornerRadius = 15
        
        cell.browseRecipeName.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.browseRecipeName.layer.shadowOpacity = 0.8
        cell.browseRecipeName.layer.shadowRadius = 2
        
        // fetch image
        let imageURL = URL(string: mealList[indexPath.row].strMealThumb!)
        URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                cell.browseRecipeName.text = self?.mealList[indexPath.row].strMeal
                cell.browseRecipeImage.image = UIImage(data: data)
            }
        }.resume()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appDelegate.viewMeal = mealList[indexPath.row]
        transitionToRecipeDetails()
    }
}
