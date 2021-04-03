//
//  CustomAnnotation.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-02.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
  
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D
  var routeOrder: Int
  var locationId : Int
  
  // use marker instead of pin
  var markerTintColor: UIColor = .systemGray
  // set default value
  var glyphText = String("1")
  
  init(location: Location, routeOrder: Int ) {
    self.locationId = location.id
    self.title = location.title
    self.subtitle = location.address
    self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    self.routeOrder = routeOrder
    self.markerTintColor = Category.color(location.category).withAlphaComponent(0.7)
    super.init()
  }
  
  // update text depends on the pin content
  func setMarkText(){
    glyphText = "\(routeOrder)"
  }
  
}
