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
      static let section = "section"
      static let group = "group"
    }
  }
  struct Kind {
    static let sectionHeader = "kind-section"
    static let groupHeader = "kind-group"
    static let footer = "footer"
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
