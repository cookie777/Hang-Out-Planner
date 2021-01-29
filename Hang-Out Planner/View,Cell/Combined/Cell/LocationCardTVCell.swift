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
    imageView.setContentHuggingPriority(.required, for: .horizontal)
    return imageView
  }()
  /// store fetched images
  var FetchedImageDict: [Int: UIImage?] = [:]
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let vStackView = VerticalStackView(arrangedSubviews: [locationTitleLabel, addressLabel], spacing: 0, alignment: .fill, distribution: .fillProportionally)
    vStackView.translatesAutoresizingMaskIntoConstraints = false
  
    let hStackView = HorizontalStackView(arrangedSubviews: [vStackView, locationImage], spacing: 0, alignment: .fill, distribution: .fillProportionally)
    locationImage.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.5).isActive = true
    locationImage.heightAnchor.constraint(equalTo: hStackView.heightAnchor, multiplier: 1).isActive = true
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
