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
    let imageView = UIImageView()
    imageView.image = UIImage(named: "tempImage")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    return imageView
  }()
  /// store fetched images
  var fetchedImageDict: [Int: UIImage?] = [:]
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let locationStackView = VerticalStackView(
      arrangedSubviews: [locationTitleLabel, addressLabel],
      spacing: 8,
      alignment: .leading
    )
  
    let mainStackView = HorizontalStackView(
      arrangedSubviews: [locationStackView, locationImage],
      distribution: .fill
    )
    locationImage.matchSizeWith(widthRatio: 0.4)
    locationImage.heightAnchor.constraint(equalTo: locationImage.widthAnchor, multiplier: 3/4).isActive = true
    
    contentView.addSubview(mainStackView)
    mainStackView.matchParent()
    
 
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
    // get image URL from id, set

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
  
  func checkImageURL(id: Int) -> String {
    var urlString = ""
    for location in allLocations {
      if location.id == id{
        if location.imageURL != nil {
          urlString = "\(location.imageURL!)"
        }
      }
    }
     return urlString
  }
  
  
}
