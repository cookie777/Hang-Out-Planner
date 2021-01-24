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
    self.setTitle("+", for: .normal)
    self.backgroundColor = .white
    self.setTitleColor(.blue, for: .normal)
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.black.cgColor
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
