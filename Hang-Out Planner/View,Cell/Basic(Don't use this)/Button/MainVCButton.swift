//
//  MainViewButton.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class MainVCButton: UIButton {
  
  private var buttonSize : CGFloat = 64.0
  
  init() {
    super.init(frame: .zero)
    
    // Set size
    self.constraintWidth(equalToConstant: buttonSize)
    self.constraintHeight(equalToConstant: buttonSize)
    
    // Set round corner
    layer.cornerRadius = buttonSize / 3

    // Set shadow
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    layer.masksToBounds = false
    layer.shadowRadius = 10.0
    layer.shadowOpacity = 0.13

    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
