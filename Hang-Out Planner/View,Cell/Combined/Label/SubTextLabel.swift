//
//  SubTextLabel.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class SubTextLabel: BasicLabel {
  
  override init(text: String) {
    super.init(text: text)
    self.font = .systemFont(ofSize: 16, weight: .regular)
 
    self.textColor = .systemGray
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
