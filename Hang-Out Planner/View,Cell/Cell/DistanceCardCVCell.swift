//
//  DistanceCardCVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-01.
//

import UIKit

class DistanceCardCVCell: BasicCardCollectionViewCell {
  static let identifier = "distance"
  
  var distanceLine : VerticalStackView = {
    
    let circleSize : CGFloat = 10
    let color : UIColor = .systemGray5
  
    let upperCircle = UIView()
    upperCircle.backgroundColor = color
    upperCircle.constraintWidth(equalToConstant: circleSize)
    upperCircle.constraintHeight(equalToConstant: circleSize)
    upperCircle.layer.cornerRadius = circleSize/2

    let middleRect = UIView()
    middleRect.backgroundColor = color.withAlphaComponent(0.5)
    middleRect.constraintWidth(equalToConstant: 2)
    middleRect.constraintHeight(equalToConstant: 60)
    
    let lowerCircle = UIView()
    lowerCircle.backgroundColor = color
    lowerCircle.constraintWidth(equalToConstant: circleSize)
    lowerCircle.constraintHeight(equalToConstant: circleSize)
    lowerCircle.layer.cornerRadius = circleSize/2
    
    let sv = VerticalStackView(
      arrangedSubviews: [upperCircle, middleRect, lowerCircle],
      alignment: .center
    )
    sv.setCustomSpacing(-circleSize/2, after: upperCircle)
    sv.setCustomSpacing(-circleSize/2, after: lowerCircle)

    return sv
  }()
  
  var timeToReachByWalk = SubTextLabel(text: "")
  var timeToReachByCar = SubTextLabel(text: "")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureLayout() {
    // base
    self.backgroundColor = UIColor.Custom.forBackground
    
    // Distance line
    contentView.addSubview(distanceLine)
    distanceLine.centerXYin(contentView)
    
    // Distance label
    let timeStackView = VerticalStackView(
      arrangedSubviews: [timeToReachByWalk,timeToReachByCar],
      spacing: 8
    )
    contentView.addSubview(timeStackView)
    timeStackView.centerYin(distanceLine)
    timeStackView.leadingAnchor.constraint(equalTo: distanceLine.centerXAnchor, constant: 32).isActive = true
  }
  
  func configureUI(with route: Route) {
    let minuteByCar = SpeedCalculator.calcCarSpeedInMinute(distance: route.distance)
    let timeOnFoot = SpeedCalculator.calcWalkingSpeed(distance: route.distance)
  
    switch minuteByCar {
    case 0:
      timeToReachByCar.text = "1 min 🚗"
    case 1:
      timeToReachByCar.text = "\(minuteByCar) min 🚗"
    default:
      timeToReachByCar.text = "\(minuteByCar) mins 🚗"
    }
    timeToReachByWalk.text = timeOnFoot + "🚶‍♀️"
  }
}
