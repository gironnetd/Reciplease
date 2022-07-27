//
//  RecipeDetailHeaderView.swift
//  Reciplease
//
//  Created by damien on 25/07/2022.
//

import UIKit

@IBDesignable class RecipeDetailHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var caloriesImage: UIImageView!
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: RecipeDetailHeaderView.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        recipeTitle.isAccessibilityElement = true
        recipeImage.isAccessibilityElement = true
        calories.isAccessibilityElement = true
        time.isAccessibilityElement = true
        caloriesImage.isAccessibilityElement = true
    }
}
