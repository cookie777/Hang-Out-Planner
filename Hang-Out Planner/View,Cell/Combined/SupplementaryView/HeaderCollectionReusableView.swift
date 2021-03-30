//
//  HeaderCollectionReusableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-28.
//

import UIKit


/// Header view for collection view. You can set any kind of label.
class HeaderCollectionReusableView: UICollectionReusableView {
  var label: UILabel! = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(lb: UILabel) {
    label = lb
    addSubview(label)
    label.matchParent()
  }
}
