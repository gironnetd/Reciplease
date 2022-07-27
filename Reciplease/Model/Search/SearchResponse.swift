//
//  SearchResponse.swift
//  Reciplease
//
//  Created by damien on 20/07/2022.
//

import Foundation
import UIKit

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let from, to, count: Int?
    let links: SearchResponseLinks?
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits = "hits"
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    let links: HitLinks?

    enum CodingKeys: String, CodingKey {
        case recipe = "recipe"
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinks: Codable {
    let linksSelf: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Codable {
    let href: String
    let title: String
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let imageUrl: String
    var recipeImage: Data?
    let images: Images
    let source: String
    var url: String
    let shareAs: String
    let yield: Double
    let dietLabels, healthLabels: [String]
    let cautions: [String]
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, totalWeight: Double
    let totalTime: Int
    let cuisineType: [String]
    let mealType: [String]
    let dishType: [String]
    let totalNutrients, totalDaily: [String: Total]
    let digest: [Digest]
    
    enum CodingKeys: String, CodingKey {
        case uri, label, recipeImage, images, source, url, shareAs, yield,
             dietLabels, healthLabels, cautions,ingredientLines, ingredients,
         calories, totalWeight,totalTime, cuisineType,
         mealType, dishType, totalNutrients, totalDaily, digest
        case imageUrl = "image"
    }
}

// MARK: - Digest
struct Digest: Codable {
    let label, tag: String
    let schemaOrgTag: String?
    let total: Double
    let hasRDI: Bool
    let daily: Double
    let unit: String
    let sub: [Digest]?
}

// MARK: - Images
struct Images: Codable {
    let thumbnail, small, regular: Large
    let large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory: String?
    let foodID: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

// MARK: - Total
struct Total: Codable {
    let label: String
    let quantity: Double
    let unit: String
}

// MARK: - SearchResponseLinks
struct SearchResponseLinks: Codable {
    let next: Next
}
