//
//  CardTableViewCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CardTVCell: UITableViewCell {
  
  let shadowLayer = ShadowView()
  let mainBackground = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    shadowLayer.translatesAutoresizingMaskIntoConstraints = false
    shadowLayer.backgroundColor = .black
    contentView.addSubview(shadowLayer)
    shadowLayer.matchParent(padding: .init(top: 16, left: 16, right: 16, bottom: 24))
    
    //    shadowLayer.layer.masksToBounds = false
    //    shadowLayer.layer.shadowOffset = .zero
    //    shadowLayer.layer.shadowColor = UIColor.black.cgColor
    //    shadowLayer.layer.shadowOpacity = 0.53
    //    shadowLayer.layer.shadowRadius = 10
    
    
    mainBackground.translatesAutoresizingMaskIntoConstraints = false
    mainBackground.backgroundColor =  .white
    contentView.addSubview(mainBackground)
    mainBackground.matchParent(padding: .init(top: 16, left: 8, right: 8, bottom: 24))
    mainBackground.layer.cornerRadius = 24
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
