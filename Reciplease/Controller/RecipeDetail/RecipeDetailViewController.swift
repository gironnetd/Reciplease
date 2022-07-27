//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by damien on 22/07/2022.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    var recipe: Recipe?
    
    @IBOutlet weak var ingredientLines: UITableView!
    @IBOutlet weak var recipeDetailheaderView: RecipeDetailHeaderView!
    
    private let segueIdentifier = "RecipeDescriptionSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientLines.delegate = self
        ingredientLines.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateHeaderIngredientLines()
    }
    
    private func populateHeaderIngredientLines() {
        if let recipe = recipe, let recipeImage = recipe.recipeImage {
            recipeDetailheaderView.recipeImage.image = UIImage(data: recipeImage)
            recipeDetailheaderView.recipeTitle.text = recipe.label.replacingOccurrences(of: "&amp;amp;", with: "&")
            recipeDetailheaderView.recipeTitle.accessibilityHint = recipeDetailheaderView.recipeTitle.text
            recipeDetailheaderView.recipeTitle.accessibilityLabel = recipeDetailheaderView.recipeTitle.text
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            
            if recipe.calories >= 1000 {
                recipeDetailheaderView.calories.text = "\(formatter.string(from: recipe.calories / 1000 as NSNumber) ?? String(0)) kcal "
            } else {
                recipeDetailheaderView.calories.text = "\(formatter.string(from: NSNumber(value: recipe.calories)) ?? String(0)) cal "
            }
            recipeDetailheaderView.calories.accessibilityHint = recipeDetailheaderView.calories.text
            recipeDetailheaderView.calories.accessibilityLabel = recipeDetailheaderView.calories.text
            
            if recipe.calories > 1500 {
                recipeDetailheaderView.caloriesImage.image = UIImage.init(systemName: "hand.thumbsdown.fill")
                recipeDetailheaderView.calories.accessibilityHint = "the calorie count is over 1500 which means it is too high"
                recipeDetailheaderView.calories.accessibilityLabel = "the calorie count is over 1500 which means it is too high"
            } else {
                recipeDetailheaderView.calories.accessibilityHint = "the calorie count is less than 1500 which means it remains correct"
                recipeDetailheaderView.calories.accessibilityLabel = "the calorie count is less than 1500 which means it remains correct"
            }
            
            let (hours, minutes) = ((recipe.totalTime / 60), (recipe.totalTime % 60))
            if hours != 0 || minutes != 0 {
                recipeDetailheaderView.time.text = ""
                
                if hours != 0 {
                    recipeDetailheaderView.time.text?.append("\(hours) h ")
                }
                
                if minutes != 0 {
                    recipeDetailheaderView.time.text?.append("\(minutes) m")
                }
            }
            recipeDetailheaderView.time.accessibilityHint = "the time to prepare the recipe is estimated to \(recipeDetailheaderView.time.text!)"
            recipeDetailheaderView.time.accessibilityLabel = "the time to prepare the recipe is estimated to \(recipeDetailheaderView.time.text!)"
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destination as? RecipeDescriptionViewController
        {
            destination.recipe = recipe
        }
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ingredientLines = recipe?.ingredientLines {
            return ingredientLines.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailTableViewCell", for: indexPath) as! RecipeDetailTableViewCell
        
        if let ingredientLine = recipe?.ingredientLines[indexPath.row] {
            cell.ingredientLine.text = ingredientLine
            
            cell.ingredientLine.accessibilityHint = cell.ingredientLine.text
            cell.ingredientLine.accessibilityLabel = cell.ingredientLine.text
        }
        return cell
    }
}

extension RecipeDetailViewController: UITableViewDelegate {}
