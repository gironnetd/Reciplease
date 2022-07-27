//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by damien on 20/07/2022.
//

import UIKit
import Kingfisher

class RecipesTableViewController: UITableViewController {
    
    private var recipes: [Recipe] = []
    private let segueIdentifier: String = "RecipeDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RecipeTableViewCell")
        SearchService.shared.retrieveRecipes(ingredients: ["Cheese", "Lemon"], callBack: { recipes, error in
            if let recipes = recipes {
                self.recipes = recipes
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
        
        cell.title.text = recipe.label.replacingOccurrences(of: "&amp;amp;", with: "&")
        cell.title.accessibilityHint = cell.title.text
        cell.title.accessibilityLabel = cell.title.text
        
        cell.ingredients.text = recipe.ingredients.map { ingredient in ingredient.food }.joined(separator: ", ")
        cell.ingredients.accessibilityHint = cell.ingredients.text
        cell.ingredients.accessibilityLabel = cell.ingredients.text
        
        cell.recipeImage.kf.setImage(with: URL(string: recipe.imageUrl), completionHandler: { result in
            switch result {
            case .success(let image):
                if let image = image.image.pngData() {
                    self.recipes[indexPath.row].recipeImage = image
                }
            case .failure(let error):
                print(error)
            }
        })
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        
        if recipe.calories >= 1000 {
            cell.calories.text = "\(formatter.string(from: recipe.calories / 1000 as NSNumber) ?? String(0)) kcal "
        } else {
            cell.calories.text = "\(formatter.string(from: NSNumber(value: recipe.calories)) ?? String(0)) cal "
        }
        cell.calories.accessibilityHint = cell.calories.text
        cell.calories.accessibilityLabel = cell.calories.text
        
        if recipe.calories > 1500 {
            cell.caloriesImage.image = UIImage.init(systemName: "hand.thumbsdown.fill")
            cell.calories.accessibilityHint = "the calorie count is over 1500 which means it is too high"
            cell.calories.accessibilityLabel = "the calorie count is over 1500 which means it is too high"
        } else {
            cell.calories.accessibilityHint = "the calorie count is less than 1500 which means it remains correct"
            cell.calories.accessibilityLabel = "the calorie count is less than 1500 which means it remains correct"
        }
        
        let (hours, minutes) = ((recipe.totalTime / 60), (recipe.totalTime % 60))
        if hours != 0 || minutes != 0 {
            cell.time.text = ""
            
            if hours != 0 {
                cell.time.text?.append("\(hours) h ")
            }
            
            if minutes != 0 {
                cell.time.text?.append("\(minutes) m")
            }
        }
        cell.time.accessibilityHint = "the time to prepare the recipe is estimated to \(cell.time.text!)"
        cell.time.accessibilityLabel = "the time to prepare the recipe is estimated to \(cell.time.text!)"
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: segueIdentifier, sender: cell)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destination as? RecipeDetailViewController,
            let recipeIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.recipe = recipes[recipeIndex]
        }
    }
}
