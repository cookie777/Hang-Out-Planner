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

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 8, bottom: 24, right: 8))
  }
 }
