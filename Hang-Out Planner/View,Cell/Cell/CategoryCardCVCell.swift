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
  var checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
  var mainLabel = SmallHeaderLabel(text: "")
  
  // If category is set, we also set icon img, lb text, background color
  var category : Category! {
    didSet{
      // update icon
      if let iconImg = Category.iconImage(category){
        icon.image = iconImg
        Category.overrideImageColor(imgV: icon, category: category)
        Category.overrideImageColor(imgV: checkmark, category: category)
      }
      
      
      // update label text and color
      mainLabel.text = category.rawValue
      mainLabel.textColor = Category.color(category)
      mainBackground.layer.borderColor = Category.color(category).withAlphaComponent(0.7).cgColor
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
  }
  
  private func configureLayout() {
    // Icon layout
    contentView.addSubview(icon)
    icon.constraintWidth(equalToConstant: 22)
    icon.constraintHeight(equalToConstant: 22)
    icon.centerYin(contentView)
    icon.leadingAnchor.constraint(equalTo: mainBackground.leadingAnchor, constant: 24).isActive = true
    
    // checkmark
    contentView.addSubview(checkmark)
    checkmark.constraintWidth(equalToConstant: 20)
    checkmark.constraintHeight(equalToConstant: 20)
    checkmark.centerYin(contentView)
    checkmark.trailingAnchor.constraint(equalTo: mainBackground.trailingAnchor, constant: -24).isActive = true
    checkmark.isHidden = true
    
    // Text layout
    contentView.addSubview(mainLabel)
    mainLabel.centerXYin(contentView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
