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
    
    // set main text
    let lb = SmallHeaderLabel(text: "GO")
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.textColor = .systemBackground
    self.addSubview(lb)
    lb.centerXYin(self)

    self.backgroundColor = .systemBlue
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
