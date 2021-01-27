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

  var category : String = ""{
    didSet{
      guard let c = Categories(rawValue: category)  else {return}
      icon.image = Categories.sfSymbolImage(c)
      textlb.text = category
      textlb.textColor = Categories.color(c)
      mainBackground.layer.borderColor = Categories.color(c).cgColor
      
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(icon)
    icon.centerYin(contentView)
    icon.leadingAnchor.constraint(equalTo: mainBackground.leadingAnchor, constant: 24).isActive = true
    
    contentView.addSubview(textlb)
    textlb.centerXYin(contentView)
    
    mainBackground.layer.borderWidth = 1.6
    
    selectionStyle = .default
    let view = UIView()
    view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
    selectedBackgroundView = view
    selectedBackgroundView?.layer.zPosition = 1
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 1, bottom:32, right: 1))
  }
  

}
