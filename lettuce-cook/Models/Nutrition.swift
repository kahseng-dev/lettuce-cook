//
//  Nutrition.swift
//  lettuce-cook
//
//  Created by Mac on 24/1/22.
//

import Foundation

struct Nutrition: Codable {
    var sugar_g: Decimal?
    var fiber_g: Decimal?
    var serving_size_g: Decimal?
    var sodium_mg: Decimal?
    var potassium_mg: Decimal?
    var fat_saturated_g: Decimal?
    var fat_total_g: Decimal?
    var calories: Decimal?
    var cholesterol_mg: Decimal?
    var protein_g: Decimal?
    var carbohydrates_total_g: Decimal?
}
