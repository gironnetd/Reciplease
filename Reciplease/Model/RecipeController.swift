//
//  RecipeController.swift
//  Reciplease
//
//  Created by damien on 30/07/2022.
//

import Foundation

import UIKit
import CoreData

class RecipeController {
    
    static let shared: RecipeController = RecipeController()
    // MARK:- Property
    //var fetchedResultsController: NSFetchedResultsController<Recipe>
    
    private lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Reciplease")
      print(container.persistentStoreDescriptions.first?.url)
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
      return container
    }()
    
    static var managedObjectContext: NSManagedObjectContext {
        return RecipeController.shared.persistentContainer.viewContext
      }
    
    public func save(recipe: Recipe) {
        let savedRecipe = Recipe(context: RecipeController.managedObjectContext)
        savedRecipe.label = recipe.label
        savedRecipe.imageUrl = recipe.imageUrl
        savedRecipe.url = recipe.url
        savedRecipe.totalTime = recipe.totalTime
        savedRecipe.totalWeight = recipe.totalWeight
        savedRecipe.calories = recipe.calories
        recipe.ingredients.forEach { ingredient in
            let savedIngredient = Ingredient(context: RecipeController.managedObjectContext)
            savedIngredient.text = ingredient.text
            savedIngredient.food = ingredient.food
            savedRecipe.ingredients.insert(savedIngredient)
        }
        saveContext()
    }
    
    public func delete(recipe: Recipe) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "label LIKE %@", recipe.label)

        do {
            for recipe in try RecipeController.managedObjectContext.fetch(request) {
                recipe.ingredients.forEach { ingredient in RecipeController.managedObjectContext.delete(ingredient) }
                RecipeController.managedObjectContext.delete(recipe)
            }
            saveContext()
        } catch {}
    }
    
    public func findAll() -> [Recipe]? {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        return try? RecipeController.managedObjectContext.fetch(request)
    }
    
    private func saveContext() {
        do {
            try RecipeController.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context, item not saved")
        }
    }
}
