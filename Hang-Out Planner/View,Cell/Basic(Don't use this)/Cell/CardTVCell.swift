//
//  CardTableViewCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CardTVCell: UITableViewCell {
  
  // Use custom shadow class to reduce calc (is it working?)
//  let shadowLayer = ShadowView()
  let mainBackground = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    //Set shadow
//    
//    shadowLayer.translatesAutoresizingMaskIntoConstraints = false
//    shadowLayer.backgroundColor = .label
//    contentView.addSubview(shadowLayer)
//    shadowLayer.matchParent(padding: .init(top: 16, left: 0, right: 0, bottom: 24))

    // Set main backgroud
    mainBackground.translatesAutoresizingMaskIntoConstraints = false
    mainBackground.backgroundColor =  .systemBackground
    // To set size, we have to add subview to the content view
    contentView.addSubview(mainBackground)
    mainBackground.matchParent()
    mainBackground.layer.cornerRadius = 24
    
    
    // Selected config. If a user tap, it will cover transparent view
    // How ? -> bring the `selectedBackgroundView` (built in) to front, and make it transparent.
    selectionStyle = .default
    let view = UIView()
    view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
    selectedBackgroundView = view
    selectedBackgroundView?.layer.zPosition = 1
  }
  

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
