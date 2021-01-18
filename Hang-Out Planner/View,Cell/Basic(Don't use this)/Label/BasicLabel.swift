//
//  BasicLabel.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-18.
//

import UIKit

class BasicLabel: UILabel {

  init(text: String) {
    super.init(frame: .zero)
    self.text = text
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
