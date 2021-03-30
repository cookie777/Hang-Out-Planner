//
//  Constants.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-04.
//

import Foundation
import UIKit


struct Constants {
  
  struct Identifier {
    struct Cell {
      static let map = "map"
      static let list = "list"
    }
    struct SupplementaryView {
      static let mapSection = "map-section"
      static let header = "header"
    }
  }
  struct Kind {
    static let sectionHeader = "kind-section"
    static let groupHeader = "kind-group"
  }
}


extension UIColor {
  
  struct Custom {
    static var main: UIColor {
      return UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? .black : .white
      }
    }
    
    static var bg: UIColor {
      return UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? .white : .black
      }
    }

  }
}
