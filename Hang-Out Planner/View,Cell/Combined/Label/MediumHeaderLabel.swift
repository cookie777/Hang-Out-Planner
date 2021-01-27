//
//  MediumHeaderLabel.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class MediumHeaderLabel: BasicLabel {
  
  static var fontData : UIFont = .systemFont(ofSize: 26, weight: .black)
  
  override init(text: String) {
    super.init(text: text)
    self.font = MediumHeaderLabel.fontData
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
