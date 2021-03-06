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
    
    // retrieve a random meal
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
    
    // retrieve the latest meals
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
    
    
    // retrieve 10 random meals
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
    
    // retrieve a meal given its mealid
    public func getMeal(mealID: String, completion: @escaping (Result<Meal, Error>) -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/lookup.php?i=\(mealID)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(MealAPIResponse.self, from: data)
                    completion(.success(result.meals[0]))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // retrieve list of categories
    public func getCategoriesList(completion: @escaping (Result<[Category], Error>) -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/categories.php") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(CategoriesAPIResponse.self, from: data)
                    completion(.success(result.categories))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // retrieve a list of meals given the category
    public func getCategoryMeals(category:String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/filter.php?c=\(category)") else {
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
    
    // retrieve a list of meals given text
    public func searchMeals(text: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/search.php?s=\(text)") else {
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
    }}
