//
//  CustomAnnotationView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-02.
//

import MapKit

class CustomAnnotationView: MKMarkerAnnotationView {

  /// Update annotation view's properties when annotation is updated.
  override var annotation: MKAnnotation?
  {
    willSet {
      // get updated annotation
      guard let annotation = newValue as? CustomAnnotation else {return}
      // reset view
      resetMarkerAnnotationView()
      // if starting location -> user icon, otherwise -> location marker
      switch annotation.routeOrder {
        case 0:
          setUpUserIcon()
        default:
          setUpMarker(annotation)
      }
    }
  }

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    // config of details view of marker
    canShowCallout = true
    calloutOffset = CGPoint(x: -5, y: 5)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func resetMarkerAnnotationView() {
    markerTintColor = .clear
    glyphImage = UIImage()
    rightCalloutAccessoryView = UIButton()
    
    // This makes all MarkerAnnotationView always displayed. (Without this, some marker is not displayed when they are close together.) Every time this priority is reseted so we have to set again.
    displayPriority = .required
  }

  private func setUpUserIcon() {
    let userIcon = UIView.userCurrentLocationIcon
    addSubview(userIcon) // Every time subviews are reset so we don't have to manually remove userIcon every time.
    userIcon.centerXYin(self)
  }
  
  private func setUpMarker(_ annotation: CustomAnnotation) {
    rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    markerTintColor = annotation.markerTintColor
    glyphText = annotation.glyphText
  }
}


