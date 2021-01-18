//
//  VerticalStackView.swift
//  AppStore
//
//  Created by Derrick Park on 2019-05-30.
//  Copyright © 2019 Derrick Park. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
  
  init(
    arrangedSubviews: [UIView],
    spacing: CGFloat = 0,
    alignment: UIStackView.Alignment = .fill) {
    
    super.init(frame: .zero)
    
    designatedInitDelegatee(
      arrangedSubviews: arrangedSubviews,
      spacing: spacing,
      alignment: alignment,
      distribution: .fill
    )
  }
  
  init(arrangedSubviews: [UIView],
       spacing: CGFloat = 0,
       distribution: UIStackView.Distribution = .fill) {
    
    super.init(frame: .zero)
    
    designatedInitDelegatee(
      arrangedSubviews: arrangedSubviews,
      spacing: spacing,
      alignment: .fill,
      distribution: distribution
    )
  }
  
  init(arrangedSubviews: [UIView],
       spacing: CGFloat = 0) {
    
    super.init(frame: .zero)
    
    designatedInitDelegatee(
      arrangedSubviews: arrangedSubviews,
      spacing: spacing,
      alignment: .fill,
      distribution: .fill)
  }
  
  init(arrangedSubviews: [UIView]) {
    
    super.init(frame: .zero)
    
    designatedInitDelegatee(
      arrangedSubviews: arrangedSubviews,
      spacing: 0,
      alignment: .fill,
      distribution: .fill)
    
    
  }
  
  init(arrangedSubviews: [UIView],
       spacing: CGFloat = 0,
       alignment: UIStackView.Alignment = .fill,
       distribution: UIStackView.Distribution = .fill) {
    
    super.init(frame: .zero)
    
    designatedInitDelegatee(
      arrangedSubviews: arrangedSubviews,
      spacing: spacing,
      alignment: alignment,
      distribution: distribution)
    
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func designatedInitDelegatee(arrangedSubviews: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution){
    
    translatesAutoresizingMaskIntoConstraints = false
    arrangedSubviews.forEach { addArrangedSubview($0) }
    self.axis = .vertical
    self.spacing = spacing
    self.alignment = alignment
    self.distribution = distribution
  }
}
