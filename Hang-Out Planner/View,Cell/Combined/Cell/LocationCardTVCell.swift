//
//  LocationCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class LocationCardTVCell: CardTVCell {
  
  
  var locationTitleLabel = SmallHeaderLabel(text: "")
  var addressLabel = SubTextLabel(text: "")
  
  lazy var locationImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "tempImage")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.constraintWidth(equalToConstant: (frame.size.width - 32*2)*0.4)
    imageView.constraintHeight(equalToConstant: (frame.size.width - 32*2)*0.4*0.76)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 16
    imageView.layer.masksToBounds = true
    return imageView
  }()

  
  lazy var locationStackView = VerticalStackView(
    arrangedSubviews: [locationTitleLabel, addressLabel],
    spacing: 8,
    alignment: .leading,
    distribution: .fill
  )
  
  lazy var mainStackView = HorizontalStackView(
    arrangedSubviews: [locationStackView, locationImageView],
    spacing: 16,
    alignment: .top
  )
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    
    // Set margin of Stack vew
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    
    
    contentView.addSubview(mainStackView)
    mainStackView.matchParent()

    
    locationTitleLabel.numberOfLines = 2
    addressLabel.numberOfLines = 2
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with route: Route) {
    let id = route.startLocationId
    let color = Categories.color(allLocations.first {$0.id == id}?.category ?? .other)
    
    // set location title
    locationTitleLabel.text = "\(PlanCardTVCell.checkLocationName(id: id))"
    locationTitleLabel.textColor = id == 0 ? .systemGray : color // if start point color is gray
    
    // set location address
    addressLabel.text = "\(LocationCardTVCell.checkLocationAddress(id: id))"
    
    mainBackground.layer.borderColor = color.cgColor
    
    
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
