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
 
  lazy var locationImage: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    imageView.image = UIImage(named: "tempImage")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let vStackView = VerticalStackView(arrangedSubviews: [locationTitleLabel, addressLabel], spacing: 0, alignment: .fill, distribution: .fillProportionally)
    vStackView.translatesAutoresizingMaskIntoConstraints = false
  
    let hStackView = HorizontalStackView(arrangedSubviews: [vStackView, locationImage], spacing: 0, alignment: .fill, distribution: .fillProportionally)
    contentView.addSubview(hStackView)
    hStackView.matchParent()
    self.backgroundColor = .systemGroupedBackground
    
    
    locationTitleLabel.numberOfLines = 0
    locationTitleLabel.lineBreakMode = .byWordWrapping
    addressLabel.numberOfLines = 0
    addressLabel.lineBreakMode = .byWordWrapping
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
      for location in allLocations {
          if location.id == id {
              locationAddress = location.address
          }
      }
      return locationAddress
  }
  
  // routeのstartid -> alllocations -> latitude and longitude
//  func checkCoordinate(id: Int) -> (Double, Double) {
//    var locationCoordinate = (0.0,0.0)
//    for location in allLocations {
//      if location.id == id {
//        locationCoordinate  = (location.latitude, location.longitude)
//      }
//      return  locationCoordinate
//    }
//  }
  
  
}
