//
//  MealDBCaller.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import Foundation

final class MealAPICaller {
    
    static let shared = MealAPICaller()
    
    struct Constants {
        static let baseURL = "https://www.themealdb.com/api/json/v2/1/"
    }
    
    private init() {}
    
    public func getRandomMeal(completion: @escaping (Result<[Meal], Error>) -> Void) {
        
        guard let url = URL(string:"\(Constants.baseURL)/random.php") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(MealAPIResponse.self, from: data)
                    completion(.success(result.meals))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    public func getLatestMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/latest.php") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(MealAPIResponse.self, from: data)
                    completion(.success(result.meals))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    public func get10RandomMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/randomselection.php") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(MealAPIResponse.self, from: data)
                    completion(.success(result.meals))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
