//
//  CategoryCardCVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import SwipeCellKit

class CategoryCardCVCell: BasicCardCollectionViewCell {
  static let identifier = "category card"
  
  var icon = UIImageView(frame: .zero)
  var textlb = SmallHeaderLabel(text: "")
  
  // If category is set, we also set icon img, lb text, background color
  var category : Category! {
    didSet{
      if let iconImg = Category.iconImage(category){
        icon.image = iconImg
        Category.overrideImageColor(imgV: icon, category: category)
      }
      
      textlb.text = category.rawValue
      textlb.textColor = Category.color(category)
      mainBackground.layer.borderColor = Category.color(category).withAlphaComponent(0.7).cgColor
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Icon layout
    contentView.addSubview(icon)
    icon.constraintWidth(equalToConstant: 22)
    icon.constraintHeight(equalToConstant: 22)
    icon.centerYin(contentView)
    icon.leadingAnchor.constraint(equalTo: mainBackground.leadingAnchor, constant: 24).isActive = true
    
    // Text layout
    contentView.addSubview(textlb)
    textlb.centerXYin(contentView)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
