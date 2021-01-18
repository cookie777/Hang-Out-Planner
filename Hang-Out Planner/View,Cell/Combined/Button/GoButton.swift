//
//  GoButton.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class GoButton: MainVCButton {

  override init() {
    super.init()
    self.setTitle("GO", for: .normal)
    self.backgroundColor = .systemBlue
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
