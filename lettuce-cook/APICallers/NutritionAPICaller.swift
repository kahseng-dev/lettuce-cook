//
//  CaloriesAPICaller.swift
//  lettuce-cook
//
//  Created by Mac on 24/1/22.
//

import Foundation

final class NutritionAPICaller {
    
    static let shared = NutritionAPICaller()
    
    struct Constants {
        static let baseURL = "https://api.calorieninjas.com/v1/nutrition"
        static let apiKey = "OxCV5Lev5ZNyssdnt2wgzw==BBxTMQLESpV0DCOX"
    }
    
    private init() {}
    
    public func getNutritionInfo(ingredient: String, measure: String, completion: @escaping (Result<Nutrition, Error>) -> Void) {
        let query = "\(measure) \(ingredient)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: "\(Constants.baseURL)?query=" + query!)
        
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(NutritionAPIResponse.self, from: data)
                    completion(.success(result.items[0]))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
