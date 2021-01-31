//
//  CategoryCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CategoryCardTVCell: CardTVCell{
  
  var icon = UIImageView(frame: .zero)
  var textlb = SmallHeaderLabel(text: "")
  


  // If category is set, we also set icon img, lb text, background color
  var category : String = ""{
    didSet{
      guard let c = Categories(rawValue: category)  else {return}
      if let iconImg = Categories.iconImage(c){
        icon.image = iconImg
        Categories.overrideImageColor(imgV: icon, category: c)
      }
      
      textlb.text = category
      textlb.textColor = Categories.color(c)
      mainBackground.layer.borderColor = Categories.color(c).cgColor
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
  
  //  override func layoutSubviews() {
  //    super.layoutSubviews()
  //    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0))
  //  }

}
