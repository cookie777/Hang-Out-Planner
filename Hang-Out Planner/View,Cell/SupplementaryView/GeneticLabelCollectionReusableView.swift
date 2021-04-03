//
//  HeaderCollectionReusableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-28.
//

import UIKit

/// Header view for collection view. You can set any kind of label.
class GeneticLabelCollectionReusableView: UICollectionReusableView {
  var label: UILabel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(lb: UILabel) {
    // If label is nil, initialize. Otherwise, update only text
    if label == nil {
      label = lb
      addSubview(label!)
      label?.matchParent()
    } else {
      label?.text = lb.text
    }
  }
}
