//
//  MapHeaderCollectionReusableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-28.
//

import UIKit
import MapKit

class MapHeaderCollectionReusableView: UICollectionReusableView {
  let headerTitle = LargeHeaderLabel(text: "Where Do You \nWant To Go?")
  let mapView : MKMapView = {
    let map = MKMapView()
    map.backgroundColor = .lightGray
    map.translatesAutoresizingMaskIntoConstraints = false
    map.layer.cornerRadius = 32
    map.constraintHeight(equalToConstant: 200)
    return map
  }()
  
  let locationTitle = SubTextLabel(text: "Your current location is:")
  let locationLabel : TextLabel =  {
    let t = TextLabel(text: "location")
    t.numberOfLines = 1
    return t
  }()
  // Wrapper of location info
  lazy var locationStackView = VerticalStackView(arrangedSubviews: [locationTitle, locationLabel], spacing: 8)
  
  let routeLabel :UILabel   =  MediumHeaderLabel(text: "Route")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure() {
    let stackView = VerticalStackView(
      arrangedSubviews: [
        headerTitle,
        mapView,
        locationStackView,
        routeLabel,
        UIView()
      ],
      spacing: 24
    )
    stackView.setCustomSpacing(16, after: routeLabel)
    addSubview(stackView)
    stackView.matchParent()
  }
}

