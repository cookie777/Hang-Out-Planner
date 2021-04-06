//
//  Constants.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-04.
//

import Foundation
import UIKit


struct Constants {
  struct Kind {
    static let sectionHeader = "kind-section"
    static let groupHeader = "kind-group"
  }
  
  struct Image {
    static let placeHolder = UIImage(systemName: "photo" ,withConfiguration: UIImage.SymbolConfiguration.init(weight: .thin))?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
  }
  
  struct Notification {
    static let annotationTapped = NSNotification.Name("annotationIsTapped")
  }
  
  struct UI {
    static let categoryCellHeight: CGFloat = 56
  }
  
  struct Debug {
    // This is a debug switcher. if you turn on, it will use only sample data
    static let noMoreAPI = true
  }
}

extension UIView {
  static let userCurrentLocationIcon : UIView = {
    let v = UIView()
    v.constraintWidth(equalToConstant: 24)
    v.constraintHeight(equalToConstant: 24)
    v.layer.cornerRadius = 12
    v.backgroundColor = .systemBackground

    let sub = UIView()
    sub.constraintWidth(equalToConstant: 16)
    sub.constraintHeight(equalToConstant: 16)
    sub.layer.cornerRadius = 8
    sub.backgroundColor = .systemBlue

    v.addSubview(sub)
    sub.centerXYin(v)
    return v
  }()
}

extension UIColor {
  
  struct Custom {
    static var forText: UIColor {
      return UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? .black : .white
      }
    }
    
    static var forBackground: UIColor {
      return UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? .white : .black
      }
    }

  }
}
