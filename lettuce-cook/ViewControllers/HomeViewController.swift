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
    @IBOutlet weak var latestCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var featuredMeal:Meal = Meal()
    var browseMealList:[Meal] = []
    var latestMealList:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featuredMealImage.layer.masksToBounds = true
        featuredMealImage.layer.cornerRadius = 15
        
        featuredMealName.layer.shadowOffset = CGSize(width: 0, height: 1)
        featuredMealName.layer.shadowOpacity = 0.8
        featuredMealName.layer.shadowRadius = 2
        
        browseCollectionView.dataSource = self
        browseCollectionView.delegate = self
        
        latestCollectionView.dataSource = self
        latestCollectionView.delegate = self
        
        // retrieve a random meal to be featured under featured meal section
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
                            
                            self?.featuredMeal = meals[0]
                            
                            self?.featuredMealImage.isUserInteractionEnabled = true
                            self?.featuredMealImage.addGestureRecognizer(imageTap)
                        }
                    }.resume()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        // retrieve 10 random meals for browse section
        MealAPICaller.shared.get10RandomMeals { [weak self] result in
            switch result {
            case .success(let meals):
                for meal in meals {
                    self?.browseMealList.append(meal)
                }
                
                DispatchQueue.main.async {
                    self?.browseCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        // retrieve latest meals for latest section
        MealAPICaller.shared.getLatestMeals { [weak self] result in
            switch result {
            case .success(let meals):
                for meal in meals {
                    self?.latestMealList.append(meal)
                }
                
                DispatchQueue.main.async {
                    self?.latestCollectionView.reloadData()
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
    
    // MARK: collection view or sliders for browse and latest collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == browseCollectionView {
            return browseMealList.count
        }
        
        return latestMealList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == browseCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.browseCell, for: indexPath) as! BrowseCollectionViewCell
            
            cell.browseRecipeImage.layer.masksToBounds = true
            cell.browseRecipeImage.layer.cornerRadius = 15
            
            cell.browseRecipeName.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.browseRecipeName.layer.shadowOpacity = 0.8
            cell.browseRecipeName.layer.shadowRadius = 2
            
            // fetch image
            let imageURL = URL(string: browseMealList[indexPath.row].strMealThumb!)
            URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
                
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.browseRecipeName.text = self?.browseMealList[indexPath.row].strMeal
                    cell.browseRecipeImage.image = UIImage(data: data)
                }
            }.resume()
            
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.latestCell, for: indexPath) as! LatestCollectionViewCell
            
            cell.latestRecipeImage.layer.masksToBounds = true
            cell.latestRecipeImage.layer.cornerRadius = 15
            
            cell.latestRecipeName.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.latestRecipeName.layer.shadowOpacity = 0.8
            cell.latestRecipeName.layer.shadowRadius = 2
            
            // fetch image
            let imageURL = URL(string: latestMealList[indexPath.row].strMealThumb!)
            URLSession.shared.dataTask(with: imageURL!) { [weak self] data, _, error in
                
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.latestRecipeName.text = self?.latestMealList[indexPath.row].strMeal
                    cell.latestRecipeImage.image = UIImage(data: data)
                }
            }.resume()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == browseCollectionView {
            appDelegate.viewMeal = browseMealList[indexPath.row]
        }
        
        else {
            appDelegate.viewMeal = latestMealList[indexPath.row]
        }
        
        transitionToRecipeDetails()
    }
}
