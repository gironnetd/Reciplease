//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by damien on 21/07/2022.
//

import UIKit

@IBDesignable class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var caloriesImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.isAccessibilityElement = true
        ingredients.isAccessibilityElement = true
        recipeImage.isAccessibilityElement = true
        calories.isAccessibilityElement = true
        time.isAccessibilityElement = true
        caloriesImage.isAccessibilityElement = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
