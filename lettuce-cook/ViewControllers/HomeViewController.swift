//
//  HomeViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var featuredMealImage: UIImageView!
    @IBOutlet weak var featuredMealName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featuredMealImage.layer.masksToBounds = true
        featuredMealImage.layer.cornerRadius = 15
        
        featuredMealName.layer.shadowOffset = CGSize(width: 0, height: 1)
        featuredMealName.layer.shadowOpacity = 0.8
        featuredMealName.layer.shadowRadius = 2
        
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
                        }
                    }.resume()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
