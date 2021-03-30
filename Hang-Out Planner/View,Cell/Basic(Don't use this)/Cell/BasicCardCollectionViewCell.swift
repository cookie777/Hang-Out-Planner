//
//  BasicCardCollectionViewCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-30.
//

import UIKit
import SwipeCellKit

class BasicCardCollectionViewCell: SwipeCollectionViewCell{
    
  let mainBackground = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createBackground()
    createRoundCorner()
    createBoarder()
    createMaskForSelect()
  }
  
  func createBackground() {
    backgroundColor = .clear
    // Set main backgroud
    mainBackground.translatesAutoresizingMaskIntoConstraints = false
    mainBackground.backgroundColor =  .systemBackground
    // To set size, we have to add subview to the content view
    contentView.addSubview(mainBackground)
    mainBackground.matchParent()
  }
  
  func createRoundCorner() {
    mainBackground.layer.cornerRadius = 24
    mainBackground.layer.masksToBounds = true
  }
  
  func createBoarder() {
    // set clear border (later, pain color depend on category)
    mainBackground.layer.borderWidth = 1.6
    mainBackground.layer.borderColor = .init(gray: 0, alpha: 0)
  }
  
  func createMaskForSelect() {
    // Selected config. If a user tap, it will cover transparent view
    // How ? -> bring the `selectedBackgroundView` (built in) to front, and make it transparent.
    let view = UIView()
    view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
    selectedBackgroundView = view
    selectedBackgroundView?.layer.zPosition = 1
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
