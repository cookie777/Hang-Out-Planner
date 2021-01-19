//
//  MediumHeaderLabel.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class MediumHeaderLabel: BasicLabel {
  
  override init(text: String) {
    super.init(text: text)
    self.font = .systemFont(ofSize: 20, weight: .black)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
