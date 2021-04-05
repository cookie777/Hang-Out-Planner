//
//  CategoryCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CategoryCardTVCell: CardTVCell{
  
  static let identifier = "cardTVCell"
  
  var icon = UIImageView(frame: .zero)
  var textlb = SmallHeaderLabel(text: "")
  


  // If category is set, we also set icon img, lb text, background color
  var category : String = ""{
    didSet{
      guard let c = Category(rawValue: category)  else {return}
      if let iconImg = Category.iconImage(c){
        icon.image = iconImg
        Category.overrideImageColor(imgV: icon, category: c)
      }
      
      textlb.text = category
      textlb.textColor = Category.color(c)
      mainBackground.layer.borderColor = Category.color(c).withAlphaComponent(0.7).cgColor
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
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
