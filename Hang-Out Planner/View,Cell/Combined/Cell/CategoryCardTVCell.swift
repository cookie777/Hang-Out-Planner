//
//  CategoryCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CategoryCardTVCell: CardTVCell{

  
  let categoryName = MediumHeaderLabel(text: "")
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.addSubview(categoryName)
    categoryName.translatesAutoresizingMaskIntoConstraints = false
    categoryName.centerXYin(contentView)
    categoryName.constraintWidth(equalToConstant: 280)
    categoryName.constraintHeight(equalToConstant: 50)
    categoryName.textAlignment = .center
    categoryName.layer.borderColor = UIColor.darkGray.cgColor
    categoryName.layer.borderWidth = 1
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 }
