//
//  UIView+ConstraintLayout.swift
//  AppStore
//
//  Created by Derrick Park on 2019-04-29.
//  Copyright © 2019 Derrick Park. All rights reserved.
//

import UIKit

struct AnchoredConstraints {
  var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
  func matchParent(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let superTopAnchor = superview?.topAnchor {
      self.topAnchor.constraint(equalTo: superTopAnchor, constant: padding.top).isActive = true
    }
    if let superBottomAnchor = superview?.bottomAnchor {
      self.bottomAnchor.constraint(equalTo: superBottomAnchor, constant: -padding.bottom).isActive = true
    }
    if let superLeadingAnchor = superview?.leadingAnchor {
      self.leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: padding.left).isActive = true
    }
    if let superTrailingAnchor = superview?.trailingAnchor {
      self.trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  
  //Added by Yanmer, match to safe area
  func matchSafeArea(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    let sa = superview?.safeAreaLayoutGuide
    
    if let superTopAnchor = sa?.topAnchor {
      self.topAnchor.constraint(equalTo: superTopAnchor, constant: padding.top).isActive = true
    }
    if let superBottomAnchor = sa?.bottomAnchor {
      self.bottomAnchor.constraint(equalTo: superBottomAnchor, constant: -padding.bottom).isActive = true
    }
    if let superLeadingAnchor = sa?.leadingAnchor {
      self.leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: padding.left).isActive = true
    }
    if let superTrailingAnchor = sa?.trailingAnchor {
      self.trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  
  //Added by Yanmer, only match parent to width
  func matchParentWidth(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let superLeadingAnchor = superview?.leadingAnchor {
      self.leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: padding.left).isActive = true
    }
    if let superTrailingAnchor = superview?.trailingAnchor {
      self.trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  //Added by Yanmer,only match parent to height
  func matchParentHeight(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let superTopAnchor = superview?.topAnchor {
      self.topAnchor.constraint(equalTo: superTopAnchor, constant: padding.top).isActive = true
    }
    if let superBottomAnchor = superview?.bottomAnchor {
      self.bottomAnchor.constraint(equalTo: superBottomAnchor, constant: -padding.bottom).isActive = true
    }
  }
  
  //Added by Yanmer, match to specific view
  func matchView(targetView: UIView, padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    self.topAnchor.constraint(equalTo: targetView.topAnchor, constant: padding.top).isActive = true
    
    self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -padding.bottom).isActive = true
    
    self.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: padding.left).isActive = true
    
    self.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -padding.right).isActive = true
  }
  
  @discardableResult // added nil as defaul value. by Takayuki
  func anchors(topAnchor: NSLayoutYAxisAnchor?, leadingAnchor: NSLayoutXAxisAnchor?, trailingAnchor: NSLayoutXAxisAnchor? , bottomAnchor: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
    
    translatesAutoresizingMaskIntoConstraints = false
    var anchoredConstraints = AnchoredConstraints()
    if let topAnchor = topAnchor {
      anchoredConstraints.top = self.topAnchor.constraint(equalTo: topAnchor, constant: padding.top)
    }
    if let bottomAnchor = bottomAnchor {
      anchoredConstraints.bottom = self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
    }
    if let leadingAnchor = leadingAnchor {
      anchoredConstraints.leading = self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left)
    }
    if let trailingAnchor = trailingAnchor {
      anchoredConstraints.trailing = self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
    }
    if size.width != 0 {
      anchoredConstraints.width = self.widthAnchor.constraint(equalToConstant: size.width)
    }
    if size.height != 0 {
      anchoredConstraints.height = self.heightAnchor.constraint(equalToConstant: size.height)
    }
    
    [anchoredConstraints.top, anchoredConstraints.bottom, anchoredConstraints.leading, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach { $0?.isActive = true }
    
    return anchoredConstraints
  }
  
  func constraintWidth(equalToConstant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalToConstant: equalToConstant).isActive = true
  }
  
  func constraintHeight(equalToConstant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(equalToConstant: equalToConstant).isActive = true
  }
  
  func constraintWidth(equalToConstant: CGFloat, heightEqualToConstant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalToConstant: equalToConstant).isActive = true
    self.heightAnchor.constraint(equalToConstant: heightEqualToConstant).isActive = true
  }
  
  func matchSize() {
    if let superWidthAnchor = superview?.widthAnchor {
      self.widthAnchor.constraint(equalTo: superWidthAnchor).isActive = true
    }
    if let superHeightAnchor = superview?.heightAnchor {
      self.heightAnchor.constraint(equalTo: superHeightAnchor).isActive = true
    }
  }
  // add by Yanmer , caring with ratio, constant
  func matchSize(widthRatio: CGFloat = 1,  heightRatio:CGFloat = 1, widthConstant:CGFloat = 0, heightConstant: CGFloat = 0) {
    if let superWidthAnchor = superview?.widthAnchor {
      self.widthAnchor.constraint(equalTo: superWidthAnchor, multiplier: widthRatio, constant: -widthConstant*2).isActive = true
    }
    if let superHeightAnchor = superview?.heightAnchor {
      self.heightAnchor.constraint(equalTo: superHeightAnchor, multiplier: heightRatio, constant: -heightConstant*2).isActive = true
    }
  }
  
  
  func centerXYin(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  func centerXin(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  func centerYin(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  /*
   Additonal funciton (centerize + fit to safeArea) by takayuki
   */
  func centerXYinSafeArea(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
  }
  func centerXinSafeArea(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
  }
  func centerYinSafeArea(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
  }
  
}
