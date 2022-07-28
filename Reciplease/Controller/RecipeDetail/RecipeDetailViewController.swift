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
        if let recipe = recipe {
            recipeDetailheaderView.recipe = recipe
            recipeDetailheaderView.populateHeaderView()
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
