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
  

  
}


/*
 Added by Yanmer(Takayuki Yamaguchi)
 */
extension UIView{
  
  
  /// Set anchor to Top, Leading, Trailing, and Bottom. If you don't want to set constrain at an anchor, you can use `nil`.
  /// - Parameters:
  ///   - topAnchor: if you don't want to set, use `nil`
  ///   - leadingAnchor: if you don't want to set, use `nil`
  ///   - trailingAnchor: if you don't want to set, use `nil`
  ///   - bottomAnchor: if you don't want to set, use `nil`
  ///   - padding: padding from Anchor. If you set `nil` at the Anchor, you should set `nil` at same place.
  ///   - size: CGSize = .zero.  You can set width and height instead of padding.
  /// - Returns: AnchoredConstraints
  @discardableResult
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
  
  
  /// match to SafeArea + padding (additional extension added by Yanmer)
  /// - Parameter padding: UIEdgeInsets = .zero
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
  
  
  /// Match to specific view + padding. We use this when it doesn't belong to, or don't want it to belong to some specific views (additional extension added by Yanmer)
  /// - Parameters:
  ///   - targetView: UIView. If UIView is parent, you can just use machParent.
  ///   - padding: UIEdgeInsets
  func matchSpecificView(targetView: UIView, padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    self.topAnchor.constraint(equalTo: targetView.topAnchor, constant: padding.top).isActive = true
    
    self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -padding.bottom).isActive = true
    
    self.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: padding.left).isActive = true
    
    self.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -padding.right).isActive = true
  }
  
  
  
  
  /// Same Leading and Trailing <-> to parentView anchor + padding.  (additional extension added by Yanmer)
  /// - Parameter padding: UIEdgeInsets. top and bottom should be nil
  func matchLeadingTrailing(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let superLeadingAnchor = superview?.leadingAnchor {
      self.leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: padding.left).isActive = true
    }
    
    if let superTrailingAnchor = superview?.trailingAnchor {
      self.trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  
  /// Same top and bottom to parentView anchor+ padding. (additional extension added by Yanmer)
  /// - Parameter padding: UIEdgeInsets. left and right should be nil
  func matchTopBottom(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let superTopAnchor = superview?.topAnchor {
      self.topAnchor.constraint(equalTo: superTopAnchor, constant: padding.top).isActive = true
    }
    if let superBottomAnchor = superview?.bottomAnchor {
      self.bottomAnchor.constraint(equalTo: superBottomAnchor, constant: -padding.bottom).isActive = true
    }
  }
  

  
  /// Set same width and height to parent view. (additional extension added by Yanmer)
  /// + you can set ratio.
  /// + you can set padding.
  ///
  /// - Parameters:
  ///   - widthRatio: Default is 1. if you set 2, it will be 2 times larger. If you don't want to set, use "nil"
  ///   - heightRatio: Default is 1. if you set 2, it will be 2 times larger. If you don't want to set, use "nil"
  ///   - widthConstant: Default is 0. left and right padding. If you set 8, it will set left 8 and right 8 padding (== total 16 padding).
  ///   - heightConstant: Default is 0. top and right height. If you set 8, it will set top 8 and bottom 8 padding (== total 16 padding).
  func matchSize(widthRatio: CGFloat? = 1,  heightRatio:CGFloat? = 1, widthConstant:CGFloat = 0, heightConstant: CGFloat = 0) {
    if let superWidthAnchor = superview?.widthAnchor, let widthRatio = widthRatio {
      self.widthAnchor.constraint(equalTo: superWidthAnchor, multiplier: widthRatio, constant: -widthConstant*2).isActive = true
    }
    if let superHeightAnchor = superview?.heightAnchor, let heightRatio = heightRatio {
      self.heightAnchor.constraint(equalTo: superHeightAnchor, multiplier: heightRatio, constant: -heightConstant*2).isActive = true
    }
    
    
  }
  
  
  /// This will align X and Y center to "safe area" instead of normal view. (additional extension added by Yanmer)
  /// - Parameter view: in the view controller.
  func centerXYinSafeArea(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
  }
  
  /// This will align only X center to "safe area" instead of normal view. (additional extension added by Yanmer)
  /// - Parameter view: in the view controller.
  func centerXinSafeArea(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
  }
  
  /// This will align only Y center to "safe area" instead of normal view. (additional extension added by Yanmer)
  /// - Parameter view: in the view controller.
  func centerYinSafeArea(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
  }
}
