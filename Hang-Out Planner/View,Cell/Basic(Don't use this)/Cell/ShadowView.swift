//
//  ShadowView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-27.
//

import UIKit


/// This is for creating shadow class. It is said this can reduce calc of shadow but I'm suspicious. Might not use.
class ShadowView: UIView {
  
  var setupShadowDone: Bool = false
  
  public func setupShadow() {
    if setupShadowDone { return }
    self.layer.cornerRadius = 32
    self.layer.shadowOffset = CGSize(width: 0, height: 3)
    self.layer.shadowRadius = 8
    self.layer.shadowOpacity = 0.05
    self.layer.shadowColor = UIColor.systemGray.cgColor
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                         byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height:
                                                                                              8)).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.main.scale
    
    setupShadowDone = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupShadow()
  }
}
