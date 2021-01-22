//
//  PlanCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit


class PlanCardTVCell: CardTVCell {
  // cell content
  var totalDistancelb = SubTextLabel(text: "")
  var totalDistanceField = SmallHeaderLabel(text: "")
  var totalTimelb = SubTextLabel(text: "")
  var totalTimeField = SmallHeaderLabel(text: "")
  var locationlb =  SubTextLabel(text: "")
  var locationField = TextLabel(text: "")
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    let totalDistanceStack = HorizontalStackView(arrangedSubviews: [totalDistancelb,totalDistanceField], spacing: 5, alignment: .fill, distribution: .fillEqually)
    let totalTimeStack = HorizontalStackView(arrangedSubviews: [totalTimelb, totalTimeField], spacing: 5, alignment: .fill, distribution: .fillEqually)
    let locationStack = HorizontalStackView(arrangedSubviews: [locationlb, locationField], spacing: 5, alignment: .fill, distribution: .fillEqually)
   
    
    let vStackView = VerticalStackView(arrangedSubviews: [totalDistanceStack, totalTimeStack, locationStack], spacing: 0, alignment: .fill, distribution: .fillProportionally)
    contentView.addSubview(vStackView)
    
    totalDistanceStack.matchLeadingTrailing()
    totalTimeStack.matchLeadingTrailing()
    locationStack.matchLeadingTrailing()
    vStackView.matchParent()
    self.backgroundColor = .systemGroupedBackground

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func update(with plan: Plan) {
    // total distance for a plan
    totalDistancelb.text = "Total distance: "
    totalDistanceField.text = "\(PlanCardTVCell.meterToKm(distance: plan.totalDistance)) Km"
    
    totalTimelb.text = "Total time: "
    totalTimeField.text = "\(calcWalkingSpeed(distance: plan.totalDistance)) Hour on foot 🚶‍♂️"
    
    locationlb.text = "Place to go: "
    var locations = ""
    for route in plan.routes {
      locations = locations + "\(PlanCardTVCell.checkLocationName(id: route.startLocationId)) \n"
    }
    locationField.text = locations

  }
  
  static func meterToKm(distance: Double) -> Double{
    let km = distance * 0.001
    return round(km * 10)/10
  }
  
  // average human: 5km per hour
 func calcWalkingSpeed(distance: Double) -> Double{
    let distanceInKm = distance * 0.001
    let walkingSpped = distanceInKm / 5
    return  round(walkingSpped * 10)/10
  }
  
  // return Location title by location id
 static func checkLocationName(id: Int) -> String {
    var locationName = ""
    for location in allLocations {
      if location.id == id {
        locationName = location.title
      }
    }
    return locationName
  }
}
