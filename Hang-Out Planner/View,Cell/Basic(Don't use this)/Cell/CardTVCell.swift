//
//  CardTableViewCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CardTVCell: UITableViewCell {
  
//  let shadowLayer = ShadowView()
  let mainBackground = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
//    
//    shadowLayer.translatesAutoresizingMaskIntoConstraints = false
//    shadowLayer.backgroundColor = .label
//    contentView.addSubview(shadowLayer)
//    shadowLayer.matchParent(padding: .init(top: 16, left: 0, right: 0, bottom: 24))
//
//    
    
    mainBackground.translatesAutoresizingMaskIntoConstraints = false
    mainBackground.backgroundColor =  .systemBackground
    contentView.addSubview(mainBackground)
    mainBackground.matchParent()
    mainBackground.layer.cornerRadius = 24
    
    
  }
  

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
