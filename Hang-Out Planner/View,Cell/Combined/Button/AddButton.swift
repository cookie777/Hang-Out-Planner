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
    // set main text
    let lb = MediumHeaderLabel(text: "+")
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.textColor = .systemBlue
    self.addSubview(lb)
    lb.centerXYin(self)
    
    
    self.backgroundColor = .systemBackground
    self.setTitleColor(.blue, for: .normal)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
