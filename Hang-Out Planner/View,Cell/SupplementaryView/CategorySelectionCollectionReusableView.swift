//
//  CategorySelectionCollectionReusableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-04.
//

import UIKit

class CategorySelectionCollectionReusableView: UICollectionReusableView {
  static let identifier = "category selecition"
  
  let largeOverallHeader = LargeHeaderLabel(text: "Where do you\nwant to go?")
  let sectionHeader = SmallHeaderLabel(text: "Location categories")
  
  lazy var stackView = VerticalStackView(arrangedSubviews: [largeOverallHeader, sectionHeader], spacing: 24)

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(stackView)
    stackView.matchParent()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}
