//
//  PlanCardCollectionViewCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-30.
//

import UIKit

class PlanCardCVCell: UICollectionViewCell {
  static let identifier = "plan card"
  
  var topNLabel : LargeHeaderLabel = {
    let lb = LargeHeaderLabel(text: "a") // 1,2,3...
    lb.constraintHeight(equalToConstant: lb.intrinsicContentSize.height - 11)
    return lb
  }()
  
  var popularityField = TextLabel(text : "") // ⭐️⭐️⭐️
  var totalDistanceField = TextLabel(text: "") // Total 2.3km
  var totalTimeField = TextLabel(text: "") // 🚗 1h 🚶‍♂️2.3h
  var locationLabel =  SmallHeaderLabel(text: "") // Route

  let locationListStackView = VerticalStackView(
    arrangedSubviews: [] as [TextLabel],
    spacing: 8,
    alignment: .leading
  )

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let totalInfoStackView = VerticalStackView(
      arrangedSubviews: [popularityField, totalDistanceField,totalTimeField],
      spacing: 8,
      alignment: .leading
    )
    let upperInfoStackView = HorizontalStackView(
      arrangedSubviews: [topNLabel, totalInfoStackView],
      spacing: 0,
      alignment: .top
    )
    totalInfoStackView.matchSizeWith(widthRatio: 0.6, heightRatio: nil)
    
  
    let lowerInfoStackView = HorizontalStackView(
      arrangedSubviews: [locationLabel, locationListStackView],
      alignment: .top
    )
    locationListStackView.matchSizeWith(widthRatio: 0.6, heightRatio: nil)
    
    
    let mainStackView = VerticalStackView(
      arrangedSubviews: [upperInfoStackView, lowerInfoStackView],
      spacing: 24
    )
    mainStackView.isLayoutMarginsRelativeArrangement = true
//    mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
  
    contentView.addSubview(mainStackView)
    mainStackView.matchParent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// update cell content based on `plan`
  /// - Parameter plan: current plan on the cell
  /// - Parameter planIndex: plan index. 0 is best.
  func configure(with plan: Plan, planIndex: Int) {
  
    topNLabel.text = "\(planIndex + 1)"
    let guessDistance = plan.totalDistance
    let timeOnFoot = SpeedCalculator.calcWalkingSpeed(distance: guessDistance)
    let hourByCar = SpeedCalculator.calcCarSpeedInHour(distance: guessDistance)
    
    totalDistanceField.text = "\(SpeedCalculator.meterTokm(distanceInMeter: guessDistance)) Km"
  
    if hourByCar == 0.0 {
      totalTimeField.text = timeOnFoot + "🚶‍♂️"
    } else {
      totalTimeField.text = timeOnFoot + "🚶‍♂️" + "\(hourByCar) h 🚗"
    }
   
    popularityField.text = Location.starConverter(score: plan.averageRating)
    
    locationLabel.text = "Route"
    locationListStackView.removeAllArrangedSubviews() // reusing cell, so must reset array.
    for i in 1..<plan.destinationList.count-1{
      let lb = TextLabel(text: "")
      let text = User.allLocations[plan.destinationList[i]].title
      lb.text =  text
      lb.numberOfLines = 1 // no break line.
      locationListStackView.addArrangedSubview(lb)
    }
    
  }
}
