//
//  LocationCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class LocationCardTVCell: UITableViewCell {
  
  var locationTitleLabel = MediumHeaderLabel(text: "")
  var addressLabel = SubTextLabel(text: "")

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    let vStackView = VerticalStackView(arrangedSubviews: [locationTitleLabel, addressLabel], spacing: 3, alignment: .center, distribution: .fillProportionally)
    contentView.addSubview(vStackView)
    vStackView.matchParent()
    self.backgroundColor = .systemGroupedBackground
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with route: Route) {
    let id = route.startLocationId
    // set location title
    locationTitleLabel.text = "\(PlanCardTVCell.checkLocationName(id: id))"
    
    // set location address
    addressLabel.text = "\(LocationCardTVCell.checkLocationAddress(id: id))"
  }
  
  // Return Location address by location id
  static func checkLocationAddress(id: Int) -> String {
      var locationAddress = ""
      for location in Location.sampleLocations {
          if location.id == id {
              locationAddress = location.address
          }
      }
      return locationAddress
  }
  
}
