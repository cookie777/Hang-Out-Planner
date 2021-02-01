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
  
  // MARK: - Class vars
  /// A plan selected at `PlanListTableViewController`
  let plan: Plan
  
  /// variables related to tableView
  let tableView = UITableView()
  let cellIdForLocation = "locationCardCell"
  let cellIdForDistance = "distanceCardCell"
  let annotationId = "annotation"
  var currentLocation = "Current Location"
  lazy var sectionTitles:[String] = ["\(currentLocation)"]
  
  /// variables related to mapKit
  var coordinate: (Double, Double)?
  
  /// variable to store fetched images
  var fetchedImages: [UIImage?] = []
  var placeHolderImage = UIImage(systemName: "photo" ,withConfiguration: UIImage.SymbolConfiguration.init(weight: .thin))?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
  
  
  // MARK: - SubViews
  let headerTitle = LargeHeaderLabel(text: "Here is\nYour Plan!")
  var mapView = MKMapView()
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
  lazy var  tableHeaderStackView :VerticalStackView = {
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
    sv.setCustomSpacing(-28, after: navigationLabel)
    return sv
  }()
  
  
  
  // MARK: - Init, viewDidLoad method
  init(plan:Plan) {
    self.plan = plan
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor
    
    //set label value by plan data
    let star = Location.starConverter(score: plan.averageRating)
    (popularityWrapper.arrangedSubviews[1] as! TextLabel).text = star
    let d = SpeedCalculator.meterTokm(distanceInMeter: plan.totalDistance)
    (totalDistanceWrapper.arrangedSubviews[1] as! TextLabel).text = "\(d) km"
    let wStr = SpeedCalculator.calcWalkingSpeed(distance: plan.totalDistance)  + "🚶‍♂️"
    let car = SpeedCalculator.calcCarSpeedInHour(distance: plan.totalDistance)
    let cStr = car >= 0.1 ?  "\(car)h 🚗" :  ""
    (totalTimeWrapper.arrangedSubviews[1] as! TextLabel).text = "\(wStr)\(cStr)"
    
    
    //set annotation and thumbnail image per route
    var routeCount = 0
    for route in plan.routes {
      
      // create annotation and draw rout
      createAnnotation(startLocationId: route.startLocationId, routeCount: routeCount)
      drawMapRoute(startLocationId: route.startLocationId, nextLocationId: route.nextLocationId)
      
      // Set initial images
      fetchedImages.append(nil)
      //Set image for starting point
      //      let config = UIImage.SymbolConfiguration(
      //      fetchedImages[0] = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
      fetchedImages[0] = placeHolderImage
      
      routeCount += 1
    }
    
    mapView.fitAll()
    
    
    //set dynamic section titles
    let numOfRoutes = plan.routes.count
    for index in  1...numOfRoutes - 1{
      sectionTitles += ["Location \(index)"]
    }
    sectionTitles += ["\nStart Location"]
    
    
    // Set up layouts
    setUpMapView()
    setUpTableView()
    
    createCrrentlocationImage()
  }
  
  func createCrrentlocationImage(){
    let mapSnapshotOptions = MKMapSnapshotter.Options()
    
    // Set the region of the map that is rendered.
    
    let location = UserLocationController.shared.coordinatesLastTimeYouTappedGo!
    let region = MKCoordinateRegion(center: location, latitudinalMeters: 1800, longitudinalMeters: 1800)
    mapSnapshotOptions.region = region
    
    // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
    mapSnapshotOptions.scale = UIScreen.main.scale
    
    // Set the size of the image output.
    mapSnapshotOptions.size = CGSize(width: 400, height: 400*0.618)
    
    
    let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
    snapShotter.start(completionHandler: { (snapshot, error) -> Void in
      if error == nil {

//          var point = snapshot?.point(for: location)
//          let v = UIView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
//          v.backgroundColor = .cyan
        
        self.fetchedImages[0] = snapshot!.image
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        //        self.tableView.reloadData()
      } else {
        print("error")
      }
    })
  }
  
  /// Set up mapView
  private func setUpMapView(){
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.layer.cornerRadius = 32
    mapView.matchSizeWith(widthRatio: 1)
    mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.618).isActive = true
    
    /// register CustomAnnotationView
    mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    //    mapView.showAnnotations(mapView.annotations, animated: true)
    mapView.delegate = self
    
    
  }
  
  /// set tableView here. I embedded all headers and views as TableHeaderView
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
  
  func moveToLocationDetailVC(locationId: Int){

    let nextVC = LocationDetailViewController(location: allLocations[locationId])
    
    // lcoaiton id : 11
    // fetched image [0, image, image ,image]
    // dest list [0, 12, 11, 5, 0]
    guard let imageId = plan.destinationList.firstIndex(where: {$0 == locationId}) else {
      return
    }
    
    if let locationImage = fetchedImages[imageId]  {
      nextVC.imageView.image = locationImage
    }
    present(nextVC, animated: true, completion: nil)
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
  
  // Define each cell at here
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    // section 0,1,2,3  <-> route は4つ
    let section = indexPath.section
    if section < plan.routes.count {
      
      
      switch indexPath.row {
      
      // Create location card cell
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForLocation, for: indexPath)  as! LocationCardTVCell
        cell.setMargin(insets: .init(top: 8, left: 0 , right: 0, bottom: 8))
        cell.locationImageView.image = placeHolderImage
        
        // update info of cell
        let route = plan.routes[section]
        cell.update(with: route)
        
        // Try to use existing image
        if fetchedImages[section] != nil {
          cell.locationImageView.image = fetchedImages[section]
          return cell
        }
        
//        // Fill place holder
//        self.fetchedImages[section] = placeHolderImage
        
        // check imageURL of the route
        let urlString = checkImageURL(id: route.startLocationId)
        // apply default image if imageURL is nil
        if urlString == nil {
          return cell
        }
        
        
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
        
        
      // Create distance cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForDistance, for: indexPath) as! DistanceCardTVCell
        cell.setMargin(insets: .init(top: 0, left: 0 , right: 0, bottom: -4))
        cell.selectionStyle = .none
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
  
  // Use custom view  as header section
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let text = sectionTitles[section]
    switch section {
    // First section == user location, we show no header
    case 0:
      return UIView()
    // Locations
    case 1..<plan.routes.count:
      return TextLabel(text: text)
    // Last section == user location
    default:
      let lb = SubTextLabel(text: text)
      lb.textAlignment = .center
      return lb
    }
  }
  
  // Set each row's hegiht
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
    // Height for Location card
    case 0:
      return 96 + 32
    // Height for Distance card
    case 1:
      return 80
    default:
      fatalError()
    }
  }
  
  
  
}


// MARK: - TableViewDelegate extension
extension PlanDetailViewController: UITableViewDelegate {
  
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // If a user tap `DistanceCardTVCell` or start point, do nothing
    if indexPath.row != 0 {return}
    if indexPath.section == 0 {return}
    // Otherwise, get selected Location id, and pass to nextVC
    let selectedLocationId = plan.destinationList[indexPath.section]
    
    moveToLocationDetailVC(locationId: selectedLocationId)
    
  }
}






// MARK: - MapViewDelegate extension
extension PlanDetailViewController: MKMapViewDelegate {
  
  /// Create annotation on locations
  func createAnnotation(startLocationId: Int, routeCount: Int) {
    guard let currentLocation = (allLocations.first{$0.id == startLocationId}) else {return}
 
    let annotation = CustomAnnotation(location: currentLocation, routeOrder: routeCount)
    // set annotation marker to routeOrder count
    annotation.setMarkText()
    mapView.addAnnotation(annotation)
    
  }
  
  /// Draw map route in map.
  /// - Parameters:
  ///   - startLocationId: id of stat point location
  ///   - nextLocationId: id of next point locaiton
  func drawMapRoute(startLocationId: Int, nextLocationId: Int) {
    
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
    renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.30)
    //    renderer.strokeStart = 0.02
    //    renderer.strokeEnd = 0.98
    renderer.lineWidth = 8
    
    return renderer
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // Cast annotation as our own class to access instance variables.
    guard let annotation = annotation as? CustomAnnotation else {return nil}
    //     `viewFor annotation` is an annotation that is about to be displayed.
    //     `reusableAnnotation` is a plate that is dequeued from reusable AV.
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as! CustomAnnotationView
    annotationView.annotation = annotation
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    guard let currentView = view.annotation as? CustomAnnotation else {
      return
    }
    moveToLocationDetailVC(locationId: currentView.locationId)
  }
  
  
  
  
}

/// Set up custom annotation
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
    self.markerTintColor = Categories.color(location.category).withAlphaComponent(0.7)
    super.init()
  }
  
  
  // update text depends on the pin content
  func setMarkText(){
    glyphText = "\(routeOrder)"
  }
}



/// Set up custom annotationView
class CustomAnnotationView: MKMarkerAnnotationView {
  
  let userIcon : UIView = {
    let v = UIView()
    v.constraintWidth(equalToConstant: 24)
    v.constraintHeight(equalToConstant: 24)
    v.layer.cornerRadius = 12
    v.backgroundColor = .systemBackground
    
    let sub = UIView()
    sub.constraintWidth(equalToConstant: 16)
    sub.constraintHeight(equalToConstant: 16)
    sub.layer.cornerRadius = 8
    sub.backgroundColor = .systemBlue
    
    v.addSubview(sub)
    sub.centerXYin(v)
    
    return v
  }()
  
  
  override var annotation: MKAnnotation?
  {
    willSet {
      guard let annotation = newValue as? CustomAnnotation else {return}
      // It seems every time it's reset so I put it here
      displayPriority = .required
      
      // Create user icon if start point
      if annotation.routeOrder == 0{
        self.addSubview(userIcon)
        userIcon.centerXYin(self)
        userIcon.isHidden = false
        markerTintColor = .clear
        glyphImage = UIImage()
        rightCalloutAccessoryView = UIButton()
        return
      }
      
      // otherwise, create locaiton icon
      userIcon.isHidden = true
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      markerTintColor = annotation.markerTintColor
      glyphText = annotation.glyphText
      
      
      
    }
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    userIcon.isHidden = true
    canShowCallout = true
    // additonal distance to move when callout
    calloutOffset = CGPoint(x: -5, y: 5)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}


extension MKMapView {
  
  //  https://stackoverflow.com/questions/39747957/mapview-to-show-all-annotations-and-zoom-in-as-much-as-possible-of-the-map
  
  /// When we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
  func fitAll() {
    var zoomRect            = MKMapRect.null;
    for annotation in annotations {
      let annotationPoint = MKMapPoint(annotation.coordinate)
      let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
      zoomRect            = zoomRect.union(pointRect);
    }
    setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 56, left: 56, bottom: 56, right: 56), animated: false)
    zoomRect            = MKMapRect.null;
  }
  
  /// We call this function and give it the annotations we want added to the map. we display the annotations if necessary
  func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
    var zoomRect:MKMapRect  = MKMapRect.null
    
    for annotation in annotations {
      let aPoint          = MKMapPoint(annotation.coordinate)
      let rect            = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
      
      if zoomRect.isNull {
        zoomRect = rect
      } else {
        zoomRect = zoomRect.union(rect)
      }
    }
    if(show) {
      addAnnotations(annotations)
    }
    setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
  }
  
}
