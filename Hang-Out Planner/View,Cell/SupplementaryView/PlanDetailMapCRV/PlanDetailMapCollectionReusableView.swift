//
//  PlanDetailMapCollectionReusableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-31.
//

import UIKit
import MapKit

class PlanDetailMapCollectionReusableView: UICollectionReusableView {
  static let identifier = "plan detail header"
  
  let headerTitle = LargeHeaderLabel(text: "Here is\nYour Plan!")
  var mapView: MKMapView = {
    let mv = MKMapView()
    mv.translatesAutoresizingMaskIntoConstraints = false
    mv.layer.cornerRadius = 32
    mv.matchSizeWith(widthRatio: 1)
    mv.heightAnchor.constraint(equalTo: mv.widthAnchor, multiplier: 0.618).isActive = true
    return mv
  }()
  let outlineLabel = MediumHeaderLabel(text: "Outline")
  let popularityWrapper :HorizontalStackView  = {
    let leftLb = TextLabel(text: "Popularity")
    let rightLb = TextLabel(text: "⭐️")
    return HorizontalStackView(arrangedSubviews: [leftLb,rightLb], spacing: 16)
  }()
  let totalDistanceWrapper :HorizontalStackView  = {
    let leftLb = TextLabel(text: "Total Distance")
    let rightLb = TextLabel(text: "0 km")
    return HorizontalStackView(arrangedSubviews: [leftLb,rightLb], spacing: 16)
  }()
  let totalTimeWrapper :HorizontalStackView  = {
    let leftLb = TextLabel(text: "Total Time")
    let rightLb = TextLabel(text: "0")
    return HorizontalStackView(arrangedSubviews: [leftLb,rightLb], spacing: 16)
  }()
  let navigationLabel = MediumHeaderLabel(text: "Navigation")
  lazy var  stackView :VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [
        headerTitle,
        mapView,
        outlineLabel,
        popularityWrapper,
        totalDistanceWrapper,
        totalTimeWrapper,
        navigationLabel,
        UIView()
      ]
    )
    // adjust spacing in stack views
    sv.setCustomSpacing(24, after: headerTitle)
    sv.setCustomSpacing(32, after: mapView)
    sv.setCustomSpacing(12, after: outlineLabel)
    sv.setCustomSpacing(8, after: popularityWrapper)
    sv.setCustomSpacing(8, after: totalDistanceWrapper)
    sv.setCustomSpacing(32, after: totalTimeWrapper)
    return sv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(stackView)
    stackView.matchParent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func config(with plan: Plan, and fetchedImages: FetchedImages) {
    setUpMapView()
    createAnnotationsAndRoutes(with: plan, and: fetchedImages)
    updateLabels(with: plan)
  }
}


// MARK: - update labels

extension PlanDetailMapCollectionReusableView {
  
  func updateLabels(with plan: Plan) {
    // rating
    let star = Location.starConverter(score: plan.averageRating)
    (popularityWrapper.arrangedSubviews[1] as! TextLabel).text = star
    // distance
    let distance = SpeedCalculator.meterTokm(distanceInMeter: plan.totalDistance)
    (totalDistanceWrapper.arrangedSubviews[1] as! TextLabel).text = "\(distance) km"
    // time cost
    let walkTime = SpeedCalculator.calcWalkingSpeed(distance: plan.totalDistance)  + "🚶‍♂️"
    let car = SpeedCalculator.calcCarSpeedInHour(distance: plan.totalDistance)
    let carTime = car >= 0.1 ?  "\(car)h 🚗" :  ""
    (totalTimeWrapper.arrangedSubviews[1] as! TextLabel).text = "\(walkTime)\(carTime)"
  }
  
}

