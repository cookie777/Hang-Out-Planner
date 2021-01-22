//
//  PlanDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import MapKit



/// Screen for displaying Plan details.
class PlanDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  var coordinate: (Double, Double)?
  
  let cellIdForLocation = "locationCardCell"
  let cellIdForDistance = "distanceCardCell"
  
  var locationManager: CLLocationManager?
  
  // A plan selected at `PlanListTableViewController`
  let plan: Plan
  let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
  
  var mapView: MKMapView = {
    let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }()
  
  let sectionTitle: [String] = ["Start Point", "1st Location", "2nd Location", "3rd Location", "4th Location"]
  
  init(plan:Plan) {
    self.plan = plan
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Here is Your Plan!"
        
    view.addSubview(mapView)
    mapView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8))
    mapView.constraintHeight(equalToConstant: view.frame.height / 3)
    
    view.addSubview(tableView)
    tableView.anchors(topAnchor: mapView.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, padding: UIEdgeInsets.init(top: 10, left: 8, bottom: 0, right: 8))
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(LocationCardTVCell.self, forCellReuseIdentifier: cellIdForLocation)
    tableView.register(DistanceCardTVCell.self, forCellReuseIdentifier: cellIdForDistance)
    
    tableView.sectionHeaderHeight = 25
    mapView.delegate = self
  }
  
  func mapThis(destinationCord: CLLocationCoordinate2D){
    let sourceCordinate = (locationManager?.location?.coordinate)!
    
    let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
    let destPlaceMark = MKPlacemark(coordinate: destinationCord)
    
    let sourceItem = MKMapItem(placemark: sourcePlaceMark)
    let destItem = MKMapItem(placemark: destPlaceMark)
    
    let destinationRequest = MKDirections.Request()
    destinationRequest.source = sourceItem
    destinationRequest.destination = destItem
    destinationRequest.transportType = .walking
    destinationRequest.requestsAlternateRoutes = true
    
    let directions = MKDirections(request: destinationRequest)
    directions.calculate { (response, error) in
      guard let response = response else {
        if let error = error {
          print("Failure \(error)")
        }
        return
      }
      let route = response.routes[0]
      self.mapView.addOverlay(route.polyline)
      self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//      let render = MKPolylineRenderer(overlay: as ! MKPolyline)
//      render.strokeColor = .blue
//      return render
//    }
    
  
    
  }
  
  
  
}

extension PlanDetailViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return plan.routes.count
  }
  
  // display LocationCardTVCell for row1, DistanceCardTVCell for row2
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForLocation, for: indexPath)  as! LocationCardTVCell
      let route = plan.routes[indexPath.section]
      cell.update(with: route)
      // routeのstartid -> alllocations -> latitude and longitude

      
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdForDistance, for: indexPath) as! DistanceCardTVCell
      let route = plan.routes[indexPath.section]
      cell.update(with: route)
      return cell
    default:
      fatalError()
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitle[section]

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


extension PlanDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
  }
}
