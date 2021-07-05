//
//  UINavigationController+hideBarBackground.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-26.
//

import UIKit

extension UINavigationController{
  
  
  /// This function clears all navigation UI and fill it with solid color.
  /// - bg Color
  /// - bg image
  /// - bg Effect
  /// - bg boarder image
  /// - bg boarder color
  /// - Parameter color: color you want to fill navigation bar with.
  func clearNavigationBar(with color: UIColor) {

    if #available(iOS 13, *) {
      navigationBar.standardAppearance.backgroundColor = color
      navigationBar.standardAppearance.backgroundEffect = nil
      navigationBar.standardAppearance.shadowImage = UIImage()
      navigationBar.standardAppearance.shadowColor = .clear
      navigationBar.standardAppearance.backgroundImage = UIImage()
      navigationBar.scrollEdgeAppearance = nil

    }

  }
  
}

