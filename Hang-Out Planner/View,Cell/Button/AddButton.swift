//
//  AddButton.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class AddButton: MainVCButton {
  
  override init() {
    super.init()

    self.titleLabel?.font = MediumHeaderLabel.fontData
    setTitle("+", for: .normal)
    setTitleColor(.systemBlue, for: .normal)
    setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .highlighted)

    self.backgroundColor = .systemBackground
    
    layer.borderWidth = 2.4
    layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
