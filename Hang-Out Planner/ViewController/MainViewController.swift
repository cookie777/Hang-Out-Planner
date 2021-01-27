//
//  MainViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import MapKit
import CoreLocation


///  Main(home and top) screen.
///  Here, user can select categories in certain order.
///  If user push "go", it will pass [Category] to Planner,
///  and move to next VC.
class MainViewController: UIViewController, UITableViewDelegate
                          ,UINavigationControllerDelegate,EditCategoryDelegate{
  
  
  let cellId = "categories"
  var safeArea: UILayoutGuide!
  
  var selectedCategories: [Categories] = [.cafe,.clothes,.park]
  var categoryArray :[[String]] = [[Categories.cafe.rawValue],[Categories.clothes.rawValue],[Categories.park.rawValue],[],[]]
  
  var sectionTitles: [String] = ["1st Location","2nd Location","3rd Location"]
  var goButton = GoButton()
  var addButton = AddButton()
  let headerTitle = LargeHeaderLabel(text: "Where Do You \nWant To Go?")
  
  let mapView : MKMapView = {
    let map = MKMapView()
    map.backgroundColor = .lightGray
    map.translatesAutoresizingMaskIntoConstraints = false
    map.layer.cornerRadius = 32
    return map
  }()
  
  let locationTitle = SubTextLabel(text: "Your current location is:")
  let locationLabel = SubTextLabel(text: "Near Keefer 58 PI")
  lazy var locationStackView = VerticalStackView(arrangedSubviews: [locationTitle, locationLabel], spacing: 8)
  
  let routeLabel :UILabel   = {
    let lb = MediumHeaderLabel(text: "Route")
    let h = lb.intrinsicContentSize.height
    lb.constraintHeight(equalToConstant: h+16)
    
    return lb
  }()
  
  let tableview: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    safeArea = view.layoutMarginsGuide
    
    // setting nv bar. Might use later
//    navigationController?.navigationBar.prefersLargeTitles = true
//    navigationItem.title = "Where do you\n want to go?"
//    navigationController?.navigationBar.largeTitleTextAttributes = LargeHeaderLabel.attrs

    // Tableview setting
    tableview.register(CategoryCardTVCell.self, forCellReuseIdentifier: cellId)
    tableview.dataSource = self
    tableview.delegate = self
    tableview.allowsMultipleSelectionDuringEditing = true
    
    
    let userLocationStackView = VerticalStackView(arrangedSubviews: [headerTitle, mapView, locationStackView], spacing: 24)
    let tableHeaderStackView = VerticalStackView(arrangedSubviews: [userLocationStackView,routeLabel],spacing: 40)
    mapView.constraintHeight(equalToConstant: 200)
  
    
    view.addSubview(tableview)
    tableview.matchParent(padding: .init(top: 40, left: 32, bottom: 40, right:32))
    tableview.showsVerticalScrollIndicator = false
    tableview.separatorStyle = .none

    let thv = tableHeaderStackView
    tableview.tableHeaderView = thv
    thv.translatesAutoresizingMaskIntoConstraints = false
  
    thv.matchSizeWith(widthRatio: 1, heightRatio: nil)
    tableview.tableHeaderView?.setNeedsLayout()
    tableview.tableHeaderView?.layoutIfNeeded()

//    Add goButton to view (you can modify this)
    view.addSubview(goButton)
    //    goButton.centerXYinSafeArea(view)
    goButton.translatesAutoresizingMaskIntoConstraints = false
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -144).isActive = true
    goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true

    view.addSubview(addButton)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 144).isActive = true
    addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true

    tableview.sectionHeaderHeight = UITableView.automaticDimension
//    tableview.rowHeight = UITableView.automaticDimension

  }
  
  
  
  func edit(_ category: String,_ row: Int, _ section:Int) {
    let index = IndexPath(row: row, section: section)
    categoryArray[section].remove(at:row)
    categoryArray[section].insert(category, at:row)
    tableview.reloadRows(at: [index], with: .automatic)
    tableview.deselectRow(at: index, animated: true)
    tableview.reloadData()
    
    switch category {
    case Categories.amusement.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.amusement, at: section)
    case Categories.cafe.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.cafe, at: section)
    case Categories.clothes.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.clothes, at: section)
    case Categories.restaurant.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.restaurant, at: section)
    case Categories.park.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.park, at: section)
    default:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.other, at: section)
    }
  }
  //Action when goButton is tapped
  @objc func goButtonTapped(){
    
    // if you has moved or no locations data?
    // -> then re-create(request, and calculate) all data
    if UserLocationController.shared.hasUserMoved() || allLocations.count == 0{
      NetworkController.shared.createAllLocations { [weak self] in
        Planner.calculateAllRoutes()
        let plans = Planner.calculatePlans(categories: self!.selectedCategories)
        let nextVC = PlanListTableViewController(plans: plans)
        self?.navigationController?.pushViewController(nextVC, animated: true)
        // update the previous coordinates
        UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
        
//        NetworkController.shared.printLocations(locations: allLocations)
//        NetworkController.shared.printPlans(plans: plans)
      }
      
    }else{
      // if same place + only category has changed
      // code : only do Planner.calculatePlans(), no createAllLocations
      let plans = Planner.calculatePlans(categories: selectedCategories)
      let nextVC = PlanListTableViewController(plans: plans)
      navigationController?.pushViewController(nextVC, animated: true)
      
      // if user info is completely same as previous "go" (== same coordinates, same category order)
      // just use previous plans (add later)
    }
    
    
  }
  
  @objc func addButtonTapped(){
    let addEditVC = CategorySelectViewController()
    addEditVC.delegate = self
    
    switch sectionTitles.count {
    case 1:
      sectionTitles.append("2nd Location")
      categoryArray[1].insert(Categories.clothes.rawValue, at: 0)
      selectedCategories.append(.clothes)
      addEditVC.categoryName0.text = Categories.clothes.rawValue
      addEditVC.row = 0
      addEditVC.section = 1
    case 2:
      sectionTitles.append("3rd Location")
      categoryArray[2].insert(Categories.park.rawValue, at: 0)
      selectedCategories.append(.park)
      addEditVC.categoryName0.text = Categories.park.rawValue
      addEditVC.row = 0
      addEditVC.section = 2
    case 3:
      sectionTitles.append("4th Location")
      categoryArray[3].insert(Categories.restaurant.rawValue, at: 0)
      selectedCategories.append(.restaurant)
      addEditVC.categoryName0.text = Categories.restaurant.rawValue
      addEditVC.row = 0
      addEditVC.section = 3
    case 4:
      sectionTitles.append("5th Location")
      categoryArray[4].insert(Categories.amusement.rawValue, at: 0)
      selectedCategories.append(.amusement)
      addEditVC.categoryName0.text = Categories.amusement.rawValue
      addEditVC.row = 0
      addEditVC.section = 4
    default:
      print("Add Button didn't work...")
    }
    let addToDoVC = UINavigationController(rootViewController: addEditVC)
    addToDoVC.hideBarBackground() // hide nv bar background. added by yanmer
    present(addToDoVC, animated: true, completion: nil)
    tableview.reloadData()
    updateAddButtonState()
  }
  //  if the number of section is over 4, add button will disappear
  func updateAddButtonState() {
    if sectionTitles.count == 5 {
      addButton.isHidden = true
    } else {
      addButton.isHidden = false
    }
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    sectionTitles.count
  }

  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let text = sectionTitles[section]
    let lb = SmallHeaderLabel(text: text)
    return lb
  }
  
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    if !categoryArray[1].isEmpty {
      return .delete
    } else {
      return .none
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      categoryArray[indexPath.section].remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      sectionTitles.removeLast()
      selectedCategories.remove(at: indexPath.section)
      let sampleArray:[String] = categoryArray.flatMap { $0 }
      var sampleArray2 :[[String]] = [[],[],[],[],[]]
      for i in 0...sampleArray.count-1 {
        sampleArray2[i].insert(sampleArray[i], at: 0)
      }
      categoryArray = sampleArray2
    }
    tableview.reloadData()
    updateAddButtonState()
  }

//
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 112
  }
  
//  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    // if you do not set `shadowPath` you'll notice laggy scrolling
//    // add this in `willDisplay` method
//    guard let cell = cell as? CategoryCardTVCell else {
//      return
//    }
//    let radius = cell.mainBackground.layer.cornerRadius
//    cell.shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: cell.shadowLayer.bounds, cornerRadius: radius).cgPath
////    cell.shadowLayer.layer.shouldRasterize = true
////    cell.shadowLayer.layer.rasterizationScale = UIScreen.main.scale
//  }

  //  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
  //    let removedToDoItem = categoryArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
  //    categoryArray[destinationIndexPath.section].insert(removedToDoItem, at: destinationIndexPath.row)
  //  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let addEditVC = CategorySelectViewController()
    addEditVC.delegate = self
    addEditVC.categoryName0.text = categoryArray[indexPath.section][indexPath.row]
    addEditVC.row = indexPath.row
    addEditVC.section = indexPath.section
    let addToDoVC = UINavigationController(rootViewController: addEditVC)
    addToDoVC.hideBarBackground() // hide nv bar background. added by yanmer
    present(addToDoVC, animated: true, completion: nil)
    tableview.deselectRow(at: indexPath, animated: true)
    tableview.reloadData()
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray[section].count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCardTVCell
    cell.categoryName.text = categoryArray[indexPath.section][indexPath.row]
    return cell
  }

}



// MARK: - Location manager process.
// Here, we manage when to start and stop location manager.
// The first time is called in viewDid load.

extension MainViewController{
  
  override func viewWillAppear(_ animated: Bool) {
    // Start updating location. Added by Yanmer
    
    
    // if already updating, need not to do.
    if UserLocationController.shared.isUpdatingLocation{return}
    
    UserLocationController.shared.start(completion: { [weak self] in
      // update user annotation here
      
      let center = UserLocationController.shared.coordinatesMostRecent!
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      self?.mapView.setRegion(region, animated: true)
      self?.mapView.showsUserLocation = true
      
//      show current address
      CLGeocoder().reverseGeocodeLocation(UserLocationController.shared.locationManager.location!) { placemarks, error in
        guard
          let placemark = placemarks?.first, error == nil,
          let administrativeArea = placemark.administrativeArea,
          let locality = placemark.locality,
          let thoroughfare = placemark.thoroughfare,
          let subThoroughfare = placemark.subThoroughfare
        else {
          self!.locationLabel.text = ""
          return
        }
        self!.locationLabel.text = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
      }
    })
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    // Stop tracking user data.  Added by Yanmer.
    UserLocationController.shared.stop()
  }

}
