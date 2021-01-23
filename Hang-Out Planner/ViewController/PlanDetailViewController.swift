//
//  PlanDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import MapKit


/// Screen for displaying Plan details.
class PlanDetailViewController: UIViewController, CLLocationManagerDelegate {
  
  // A plan selected at `PlanListTableViewController`
  let plan: Plan
  // variables related to tableView
  let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
  let cellIdForLocation = "locationCardCell"
  let cellIdForDistance = "distanceCardCell"
  var currentLocation = "Current Location"
  lazy var sectionTitles:[String] = ["\(currentLocation)"]
  
  // variables related to mapKit
  var coordinate: (Double, Double)?
  let locationManager = CLLocationManager()
  var mapView: MKMapView = {
    let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }()
  // distance measurement in meters
  let distanceSpan: CLLocationDistance = 5000
  var sourceCoordinates: CLLocationCoordinate2D?
  var destCoordinates: CLLocationCoordinate2D?
  var sourcePlacemark: MKPlacemark?
  var destPlacemark: MKPlacemark?
  var sourceItem : MKMapItem?
  var destItem : MKMapItem?
    
  init(plan:Plan) {
    self.plan = plan
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: viewDidLoad method
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Here is Your Plan!"
    // set mapView
    view.addSubview(mapView)
    mapView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8))
    mapView.constraintHeight(equalToConstant: view.frame.height / 3)
    mapView.delegate = self
    mapView.showsScale = true
    mapView.pointOfInterestFilter = MKPointOfInterestFilter()
    mapView.showsUserLocation = true
    mapView.showsTraffic = true
   
    
    // current user location authorization
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
    // set annotation per route
    for route in plan.routes {
      createAnnotation(startLocationId: route.startLocationId)
      mapRoute(startLocationId: route.startLocationId, nextLocationId: route.nextLocationId)
    }
    
    let userCurrentMapCoordinates = CLLocation(latitude: userCurrentLocation.latitude, longitude: userCurrentLocation.longitude)
//    setZoomLevel(location: userCurrentMapCoordinates)
    
    // set tableView
    view.addSubview(tableView)
    tableView.anchors(topAnchor: mapView.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, padding: UIEdgeInsets.init(top: 10, left: 8, bottom: 0, right: 8))
    
    tableView.dataSource = self
    tableView.delegate = self
    // register 2 types of custom cells
    tableView.register(LocationCardTVCell.self, forCellReuseIdentifier: cellIdForLocation)
    tableView.register(DistanceCardTVCell.self, forCellReuseIdentifier: cellIdForDistance)
    
    tableView.sectionHeaderHeight = 25
    
    // set dynamic section titles
    let numOfRoutes = plan.routes.count
    for index in  1...numOfRoutes - 1{
      sectionTitles = sectionTitles + ["Location \(index)"]
    }
    sectionTitles = sectionTitles + ["\(currentLocation)"]
  }
}


// MARK: TableViewDataSource extension
extension PlanDetailViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return plan.routes.count + 1
  }
  
  // display LocationCardTVCell for row1, DistanceCardTVCell for row2
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < plan.routes.count else {return 0}
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    if indexPath.section < plan.routes.count {
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForLocation, for: indexPath)  as! LocationCardTVCell
        let route = plan.routes[indexPath.section]
        cell.update(with: route)
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForDistance, for: indexPath) as! DistanceCardTVCell
        let route = plan.routes[indexPath.section]
        cell.update(with: route)
        return cell
      default:
        fatalError()
      }
    } else {
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
  // Dynamic row height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return 300
    case 1:
      return 200
    default:
      fatalError()
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.layoutIfNeeded()
  }
  
}

// MARK: TableViewDelegate extension
extension PlanDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}


// MARK: MapViewDelegate extension
extension PlanDetailViewController: MKMapViewDelegate {
  
  // Generate route
  func mapRoute(startLocationId: Int, nextLocationId: Int) {
    for location in allLocations {
      if startLocationId == location.id {
        sourceCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        sourcePlacemark = MKPlacemark(coordinate:sourceCoordinates!)
        sourceItem = MKMapItem(placemark: sourcePlacemark!)
      }
      if nextLocationId == location.id {
        destCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        destPlacemark = MKPlacemark(coordinate: destCoordinates!)
        destItem = MKMapItem(placemark: destPlacemark!)
      }
      
      if sourceItem != nil, destItem != nil {
      let directionRequest = MKDirections.Request()
      directionRequest.source = sourceItem
      directionRequest.destination = destItem
      directionRequest.transportType = .walking
      
      let directions = MKDirections(request: directionRequest)
      directions.calculate { (response, error) in
        
        guard let response = response else {
          if let error = error {
            print(error)
          }
          return
        }
        // grab the fastest route
        let route = response.routes[0]
        // add polyline
        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        // set start rectangle
        let rekt = route.polyline.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rekt), animated: true)
      }
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .blue
    renderer.lineWidth = 5.0
    
    return renderer
  }
  
  
  
  // Create annotation on locations
  func createAnnotation(startLocationId: Int) {
    for location in allLocations {
      if startLocationId == location.id  {
        let annotation = MKPointAnnotation()
        annotation.title = location.title
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude , longitude: location.longitude as! CLLocationDegrees)
        annotation.subtitle = location.address
          mapView.addAnnotation(annotation)
      }
    }
  }
 
  // Set region, zoom level
  func setZoomLevel(location: CLLocation) {
    let mapCoordinates = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan )
    // set new region
    mapView.setRegion(mapCoordinates, animated: true)
  }
  
}
