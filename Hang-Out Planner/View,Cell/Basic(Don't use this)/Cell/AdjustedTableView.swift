//
//  AdjustedTableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-27.
//

import UIKit

class AdjustedTableView: UITableView {
  
  let xPadding :CGFloat = 64
  let yPadding :CGFloat = 0
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var frame: CGRect {
    get {
      return super.frame
    }
    set {
      var frame = newValue
      frame.origin.x += 32
      frame.size.width -= 2 * 32
      frame.origin.y += yPadding
      frame.size.height -= 2 * yPadding
      super.frame = frame
    }
  }

}
