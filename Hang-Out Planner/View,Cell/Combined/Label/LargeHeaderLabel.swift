//
//  LargeHeaderLabel.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class LargeHeaderLabel: BasicLabel {
  
  static var fontData : UIFont =  UIFont.systemFont(ofSize: 40, weight: .black)
  
  // This attribute is used for modifying navigation bar large title.
  // I store here because it's a bit relevant.
  static let attrs = [
    NSAttributedString.Key.font: LargeHeaderLabel.fontData
  ]
  
  override init(text: String) {
    super.init(text: text)
    self.font = LargeHeaderLabel.fontData
    self.textAlignment = .left
    self.numberOfLines = 0
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
