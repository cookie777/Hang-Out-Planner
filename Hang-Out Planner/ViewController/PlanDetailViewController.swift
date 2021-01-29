//
//  PlanDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import MapKit


/// Screen for displaying Plan details.
class PlanDetailViewController: UIViewController{
  
  /// A plan selected at `PlanListTableViewController`
  let plan: Plan
  
  
  let tableHeaderStackView :VerticalStackView = VerticalStackView(arrangedSubviews: [], spacing: 24)
  
  let headerTitle = LargeHeaderLabel(text: "Here is\nYour Plan!")
  var mapView = MKMapView()
  
  let outlineLabel : MediumHeaderLabel = {
    let lb = MediumHeaderLabel(text: "Outline")
    lb.constraintHeight(equalToConstant: lb.intrinsicContentSize.height + 16)
    return lb
  }()
  let popularityWrapper :HorizontalStackView  = {
    let leftLb = TextLabel(text: "Popularity")
    let rightLb = TextLabel(text: "⭐️")
    let sv = HorizontalStackView(arrangedSubviews: [leftLb,rightLb], spacing: 16)
    
    return sv
  }()
  let totalDistanceWrapper :HorizontalStackView  = {
    let leftLb = TextLabel(text: "Total Distance")
    let rightLb = TextLabel(text: "0 km")
    let sv = HorizontalStackView(arrangedSubviews: [leftLb,rightLb], spacing: 16)
    return sv
  }()
  let totalTimeWrapper :HorizontalStackView  = {
    let leftLb = TextLabel(text: "Total Time")
    let rightLb = TextLabel(text: "0")
    let sv = HorizontalStackView(arrangedSubviews: [leftLb,rightLb], spacing: 16)
//    leftLb.constraintHeight(equalToConstant: leftLb.intrinsicContentSize.height + 40)
    return sv
  }()
  lazy var detailWrapper = VerticalStackView(arrangedSubviews: [popularityWrapper, totalDistanceWrapper, totalTimeWrapper], spacing: 8)
  let navigationLabel : MediumHeaderLabel = {
    let lb = MediumHeaderLabel(text: "Navigation")
    lb.constraintHeight(equalToConstant: lb.intrinsicContentSize.height + 24)
    return lb
  }()
  lazy var tableHeaderLowerStackView = VerticalStackView(
    arrangedSubviews: [
      outlineLabel,
      detailWrapper,
      navigationLabel
    ]
  )

  
  
  
  /// variables related to tableView
  let tableView = UITableView()
  let cellIdForLocation = "locationCardCell"
  let cellIdForDistance = "distanceCardCell"
  var currentLocation = "Current Location"
  lazy var sectionTitles:[String] = ["\(currentLocation)"]
  
  /// variables related to mapKit
  var coordinate: (Double, Double)?
  

  
  /// variables related to store fetched images
  //  let locationCardCell = LocationCardTVCell()
  //  var routeOrder = 0
  var fetchedImages: [UIImage?] = []
  
  init(plan:Plan) {
    self.plan = plan
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad method
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor

    
    ///set annotation per route
    var routeCount = 0
    for route in plan.routes {
      createAnnotation(startLocationId: route.startLocationId, routeCount: routeCount)
      mapRoute(startLocationId: route.startLocationId, nextLocationId: route.nextLocationId)
      fetchedImages.append(nil)
      routeCount += 1
    }
    
    ///set dynamic section titles
    let numOfRoutes = plan.routes.count
    for index in  1...numOfRoutes - 1{
      sectionTitles += ["Location \(index)"]
    }
    sectionTitles += ["Back to\n\(currentLocation)"]
    
    setUpTableHeaderView()
    setUpTableView()
    
  }
  
  private func setUpTableHeaderView(){
    
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.layer.cornerRadius = 32
    mapView.matchSizeWith(widthRatio: 1)
    mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
    tableHeaderStackView.addArrangedSubview(headerTitle)
    tableHeaderStackView.addArrangedSubview(mapView)
    tableHeaderStackView.addArrangedSubview(tableHeaderLowerStackView)

    /// register CustomAnnotationView
    mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    mapView.delegate = self
    
  }
  
  /// set tableView here
  private func setUpTableView()  {

    view.addSubview(tableView)
    tableView.separatorStyle = .none
    tableView.backgroundColor = bgColor
    tableView.matchParent(padding: .init(top: 40, left: 32, bottom: 40, right:32))
    // hide scroll
    tableView.showsVerticalScrollIndicator = false
    
    // Set upper view as `tableHeaderView` of the table view.
    let thv = tableHeaderStackView// tableHeaderStackView
    tableView.tableHeaderView = thv
    thv.translatesAutoresizingMaskIntoConstraints = false
    
    // Set width same as table view
    thv.matchSizeWith(widthRatio: 1, heightRatio: nil)
    // We need to set layout of header at this time. Otherwise (if we do it later), it will Overflow!
    tableView.tableHeaderView?.setNeedsLayout()
    tableView.tableHeaderView?.layoutIfNeeded()

    
    tableView.dataSource = self
    tableView.delegate = self
    /// register 2 types of custom cells
    tableView.register(LocationCardTVCell.self, forCellReuseIdentifier: cellIdForLocation)
    tableView.register(DistanceCardTVCell.self, forCellReuseIdentifier: cellIdForDistance)
    
  }


  
  
  //   MARK: - TEMP
  func checkImageURL(id: Int) -> String? {
    var urlString = ""
    for location in allLocations {
      if location.id == id {
        if location.imageURL != nil {
          urlString = "\(location.imageURL!)"
        } else if location.imageURL == nil {
          return nil
        }
      }
    }
    return urlString
  }
  
}





// MARK: - TableViewDataSource extension
extension PlanDetailViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return plan.routes.count + 1
  }
  
  /// display LocationCardTVCell for row1, DistanceCardTVCell for row2
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < plan.routes.count else {return 0}
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // section 0,1,2,3  <-> route は4つ
    let section = indexPath.section
    if section < plan.routes.count {
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForLocation, for: indexPath)  as! LocationCardTVCell
        cell.setMargin(insets: .init(top: 8, left: 0 , right: 0, bottom: 8))
        let route = plan.routes[section]
        cell.update(with: route)
        
        // if there is already an image
        if fetchedImages[section] != nil {
          cell.locationImageView.image = fetchedImages[section]
          return cell
        }
        
        
        self.fetchedImages[section] = UIImage(named: "tempImage")
        
        // check imageURL of the route
        let urlString = checkImageURL(id: route.startLocationId)
        // apply default image if imageURL is nil
        if urlString == nil { return cell }
        
        
        // if there is no image, but there is imageURL available
        NetworkController.shared.fetchImage(urlString: urlString) { (image) in
          guard let image = image else {return}
          // if there is an image, replace image with nil
          self.fetchedImages[section] = image
          DispatchQueue.main.async {
            cell.locationImageView.image = self.fetchedImages[section]
            tableView.reloadRows(at: [indexPath], with: .automatic)
          }
        }
        
        return cell
        
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForDistance, for: indexPath) as! DistanceCardTVCell
        cell.setMargin(insets: .init(top: 0, left: 0 , right: 0, bottom: -24))
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

  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let text = sectionTitles[section]
    let lb = TextLabel(text: text)
    return lb
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      switch indexPath.row {
      case 0:
        return 96 + 32
      case 1:
        return 32
      default:
        fatalError()
      }
  }


  
}

// MARK: - TableViewDelegate extension
extension PlanDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // If a user tap `DistanceCardTVCell` or start point, do nothing
    if indexPath.row != 0 {return}
    if indexPath.section == 0 {return}
    // Otherwise, get selected Location id, and pass to nextVC
    let selectedLocationId = plan.destinationList[indexPath.section]
    let nextVC = LocationDetailViewController(location: allLocations[selectedLocationId])
    
    present(nextVC, animated: true, completion: nil)
    
    //    print(indexPath.section)
    //    print(plan.destinationList)
    
  }
}


// MARK: - MapViewDelegate extension
extension PlanDetailViewController: MKMapViewDelegate {
  
  /// Draw map route in map.
  /// - Parameters:
  ///   - startLocationId: id of stat point location
  ///   - nextLocationId: id of next point locaiton
  func mapRoute(startLocationId: Int, nextLocationId: Int) {
    
    // Creat MKitem from itemId
    let sourceItem  = createMapItemFromItemId(itemId: startLocationId)
    let destItem    = createMapItemFromItemId(itemId: nextLocationId)
    
    // Create request
    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceItem
    directionRequest.destination = destItem
    directionRequest.transportType = .walking
    
    // Send request
    let directions = MKDirections(request: directionRequest)
    //
    directions.calculate { (response, error) in
      guard let response = response else {
        if let error = error { print(error)}
        return
      }
      // grab the fastest route
      let route = response.routes[0]
      // add polyline
      self.mapView.addOverlay(route.polyline, level: .aboveRoads)
      // set start rectangle
      let rekt = route.polyline.boundingMapRect
      self.mapView.setRegion(MKCoordinateRegion(rekt), animated: false)
    }
  }
  
  /// Create MKMapItem from location id. This is a helper function which is used in `mapRoute`
  /// - Parameter itemId: id of location
  /// - Returns: MKMapItem to draw route
  func createMapItemFromItemId(itemId : Int)-> MKMapItem{
    let location = allLocations[itemId]
    let coordinates = CLLocationCoordinate2D(
      latitude: location.latitude,
      longitude: location.longitude
    )
    let placemark = MKPlacemark(coordinate: coordinates)
    let item = MKMapItem(placemark: placemark)
    return item
  }
  
  /// degine  renderer on the map
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .blue
    renderer.lineWidth = 5.0
    
    return renderer
  }
  
  
  /// Create annotation on locations
  func createAnnotation(startLocationId: Int, routeCount: Int) {
    
    //    var count = 0
    for location in allLocations {
      //      print("count: \(count)")
      if startLocationId == location.id  {
        let annotation = CustomAnnotation(title: location.title, subtitle: location.address, coordinate: CLLocationCoordinate2D(latitude: location.latitude , longitude: location.longitude), routeOrder: routeCount)
        // set annotation marker to routeOrder count
        annotation.setMarkText()
        mapView.addAnnotation(annotation)
        //        count += 1
      }
    }
  }
  
  
}

/// Set up custom annotation
class CustomAnnotation: NSObject, MKAnnotation {
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D
  var routeOrder: Int
  
  init(title: String, subtitle: String, coordinate:CLLocationCoordinate2D, routeOrder: Int) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
    self.routeOrder = routeOrder
    super.init()
  }
  // use marker instead of pin
  var markerTintColor: UIColor = .orange
  // set default value
  var glyphText = String("1")
  
  // update text depends on the pin content
  func setMarkText(){
    glyphText = "\(routeOrder)"
  }
}



/// Set up custom annotationView
class CustomAnnotationView: MKMarkerAnnotationView {
  
  
  override var annotation: MKAnnotation?
  {
    willSet {
      guard let annotation = newValue as? CustomAnnotation else {return}
      canShowCallout = true
      // additonal distance to move when callout
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      
      markerTintColor = annotation.markerTintColor
      
      glyphText = annotation.glyphText
      
    }
  }
  
  
}
