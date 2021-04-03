//
//  PlanDetailMapCollectionReusableView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-31.
//

import UIKit
import MapKit

class PlanDetailMapCollectionReusableView: UICollectionReusableView {
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


// MARK: - Map default config

extension PlanDetailMapCollectionReusableView: MKMapViewDelegate {
  /// Set up mapView
  func setUpMapView(){
    /// register CustomAnnotationView
    mapView.register(
      CustomAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
    )
    mapView.showAnnotations(mapView.annotations, animated: true)
    mapView.delegate = self
  }
  
  func createAnnotationsAndRoutes(with plan: Plan, and fetchedImages: FetchedImages) {
    for (count, route) in plan.routes.enumerated() {
      createAnnotation(startLocationId: route.startLocationId, routeCount: count)
      drawMapRoute(startLocationId: route.startLocationId, nextLocationId: route.nextLocationId)
    }
    mapView.zoomCapturingAllAnnotations()
  }
}


// MARK: - Annotation (icon in the map) config

extension PlanDetailMapCollectionReusableView {
  /// Create annotation on locations
  private func createAnnotation(startLocationId: Int, routeCount: Int) {
    guard let currentLocation = (allLocations.first{$0.id == startLocationId}) else {return}

    let annotation = CustomAnnotation(location: currentLocation, routeOrder: routeCount)
    // set annotation marker to routeOrder count
    annotation.setMarkText()
    mapView.addAnnotation(annotation)
  }

  /// Define Annotation View. Same as `CellForAt`
  /// `viewFor annotation` == contents, such as label. An annotation that is about to be displayed. Like a label
  ///　`reusableAnnotation` == cell. A plate that is dequeued from reusable Annotation View. Like a Cell
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // Cast annotation
    guard let annotation = annotation as? CustomAnnotation else {return nil}
    // Dequeue and update annotation
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as! CustomAnnotationView
    annotationView.annotation = annotation
    return annotationView
  }

  // Behaviour when annotation accessory is tapped : go to detail view
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

    guard let currentView = view.annotation as? CustomAnnotation else {
      return
    }
    NotificationCenter.default.post(name: Constants.Notification.annotationTapped, object: currentView.locationId)
  }
}


// MARK: - Route config

extension PlanDetailMapCollectionReusableView {
  /// Draw map routes in map.
  /// We request the route by start and next location.
  /// - Parameters:
  ///   - startLocationId: id of stat point location
  ///   - nextLocationId: id of next point locaiton
  private func drawMapRoute(startLocationId: Int, nextLocationId: Int) {
    // Create MKitem from itemId. MKitem is requited for request
    let sourceItem  = createMapItemFromItemId(itemId: startLocationId)
    let destItem    = createMapItemFromItemId(itemId: nextLocationId)

    // Create request
    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceItem
    directionRequest.destination = destItem
    directionRequest.transportType = .walking
    // Send request
    let directions = MKDirections(request: directionRequest)
    directions.calculate { (response, error) in
      guard let response = response else {
        if let error = error { print(error)}
        return
      }
      // Get the fastest route
      let route = response.routes[0]
      // add as polyline (this will be the implication of route)
      self.mapView.addOverlay(route.polyline, level: .aboveRoads)
    }
  }

  /// Create MKMapItem from location id. This is a helper function which is used in `mapRoute`
  /// - Parameter itemId: id of location
  /// - Returns: MKMapItem to draw route
  private func createMapItemFromItemId(itemId : Int)-> MKMapItem{
    let location = allLocations[itemId]
    let coordinates = CLLocationCoordinate2D(
      latitude: location.latitude,
      longitude: location.longitude
    )
    let placemark = MKPlacemark(coordinate: coordinates)
    let item = MKMapItem(placemark: placemark)
    return item
  }

  /// Ask delegate how to render object in the map view
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.30)
    renderer.lineWidth = 8
    return renderer
  }
}
