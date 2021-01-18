//
//  File.swift
//  WhichAnimalAreYou
//
//  Created by Takayuki Yamaguchi on 2020-12-20.
//

import UIKit

// Allow UIEdgeInsets to use nil.
// Actually, just set 0.
// Use this when you are explicitly not going to set padding on constrains.

extension UIEdgeInsets{
  init(top: CGFloat? = nil , left: CGFloat? = nil,  right: CGFloat? = nil,bottom: CGFloat? = nil) {
    
    let t = top ?? 0
    let l = left ?? 0
    let b = bottom ?? 0
    let r = right ?? 0
    
    self.init(top: t, left: l, bottom: b, right: r)
  }
}
