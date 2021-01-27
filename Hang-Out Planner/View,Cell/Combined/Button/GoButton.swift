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
    
    self.titleLabel?.font = SmallHeaderLabel.fontData
    setTitle("GO", for: .normal)
    setTitleColor(.systemBackground, for: .normal)
    setTitleColor(UIColor.systemBackground.withAlphaComponent(0.5), for: .highlighted)

    self.backgroundColor = .systemBlue
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
