//
//  SmallHeaderLabel.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class SmallHeaderLabel: BasicLabel {
  
  static var fontData : UIFont =  .systemFont(ofSize: 18, weight: .bold)
  
  override init(text: String) {
    super.init(text: text)
    self.font = SmallHeaderLabel.fontData
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
