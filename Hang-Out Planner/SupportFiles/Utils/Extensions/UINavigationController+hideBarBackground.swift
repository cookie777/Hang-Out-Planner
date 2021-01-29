//
//  UINavigationController+hideBarBackground.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-26.
//

import UIKit

extension UINavigationController{
  
  func hideBarBackground() {
    // this will totally delete bar.
//    self.navigationBar.setBackgroundImage(UIImage(), for:.default)
    
    // This will just change color
//    self.navigationBar.isTranslucent = true
    self.navigationBar.barTintColor = UIColor.systemBackground
    
    
    // This will delete boarder line
    self.navigationBar.shadowImage = UIImage()
  
    self.navigationBar.layoutIfNeeded()
  }
  
}

