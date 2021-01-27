//
//  UINavigationController+hideBarBackground.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-26.
//

import UIKit

extension UINavigationController{
  
  func hideBarBackground() {
    self.navigationBar.setBackgroundImage(UIImage(), for:.default)
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.layoutIfNeeded()
  }
  
}

