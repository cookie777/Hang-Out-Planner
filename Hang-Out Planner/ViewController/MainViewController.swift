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
class MainViewController: UIViewController
                          ,UINavigationControllerDelegate,EditCategoryDelegate{
  
  // MARK: - Class Instance variables
  let cellId = "categories"
  
  var selectedCategories: [Categories] = [.fashion,.amusement,.cafe]
  var categoryArray :[[String]] = [[Categories.fashion.rawValue],[Categories.amusement.rawValue],[Categories.cafe.rawValue],[],[]]
  
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
  let locationLabel : TextLabel =  {
    let t = TextLabel(text: " ")
    t.numberOfLines = 1
    return t
  }()
  // Wrapper of location info
  lazy var locationStackView = VerticalStackView(arrangedSubviews: [locationTitle, locationLabel], spacing: 8)
  
  let routeLabel :UILabel   =  MediumHeaderLabel(text: "Route")
  
  
  let tableview: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  ///variable to store bottom indexPath of tableView, added by yumi
  var indexPathTillScrollDown: IndexPath?
  
  // MARK: - Layout config
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor
    tableview.backgroundColor = bgColor
    
    // Tableview setting
    tableview.register(CategoryCardTVCell.self, forCellReuseIdentifier: cellId)
    tableview.dataSource = self
    tableview.delegate = self
    tableview.allowsMultipleSelectionDuringEditing = true

    // add to view and set constrans
    setLayoutOfTableView()
    setLayoutButton()
  }
  
  func setLayoutOfTableView(){
    
    // First add to view(this order is important)
    view.addSubview(tableview)
    tableview.matchParent(padding: .init(top: 40, left: 32, bottom: 40, right:32))
    
    // Create upper [Title + map + location + route label] view
    let tableHeaderStackView = VerticalStackView(arrangedSubviews: [headerTitle, mapView, locationStackView,routeLabel, UIView()],spacing: 24)
    tableHeaderStackView.setCustomSpacing(16, after: routeLabel)
    mapView.constraintHeight(equalToConstant: 200)
    
    // Set upper view as `tableHeaderView` of the table view.
    let thv = tableHeaderStackView
    tableview.tableHeaderView = thv
//    thv.translatesAutoresizingMaskIntoConstraints = false
    
    // Set width same as table view
    thv.matchSizeWith(widthRatio: 1, heightRatio: nil)
    
    // We need to set layout of header at this time. Otherwise (if we do it later), it will Overflow!
    tableview.tableHeaderView?.setNeedsLayout()
    tableview.tableHeaderView?.layoutIfNeeded()
    
    // hide scroll
    tableview.showsVerticalScrollIndicator = false
    
  }
  
  func setLayoutButton() {
    
    //    Add goButton to view (you can modify this)
    view.addSubview(goButton)
    
    let goButtonSize = goButton.intrinsicContentSize.width
    let addButtonSize = addButton.intrinsicContentSize.width

    goButton.translatesAutoresizingMaskIntoConstraints = false
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: goButtonSize + 16).isActive = true
    goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    
    view.addSubview(addButton)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:  -1*(16 + addButtonSize)).isActive = true
    addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    
    
  }
  
  
  // MARK: - Edit already selected category of location
  func edit(_ category: String,_ row: Int, _ section:Int) {

    let index = IndexPath(row: row, section: section)
    self.indexPathTillScrollDown = IndexPath(row: row, section: section)
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
    case Categories.fashion.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.fashion, at: section)
    case Categories.restaurantAndCafe.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.restaurantAndCafe, at: section)
    case Categories.artAndGallery.rawValue:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.artAndGallery, at: section)
    default:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.other, at: section)
    }
    
    /// Scroll to bottom, added by yumi
    self.tableview.scrollToRow(at: self.indexPathTillScrollDown!, at: .bottom, animated: true)
  }
  
  // MARK: - Add new category of location
  /// added by yumi
  func addCategory(_ category: String) {
    /// add new section for selected location
    switch sectionTitles.count {
    case 1:
      sectionTitles.append("2nd Location")
      categoryArray[sectionTitles.count - 1].append(category)
    case 2:
      sectionTitles.append("3rd Location")
      categoryArray[sectionTitles.count - 1].append(category)
    case 3:
      sectionTitles.append("4th Location")
      categoryArray[sectionTitles.count - 1].append(category)
    case 4:
      sectionTitles.append("5th Location")
      categoryArray[sectionTitles.count - 1].append(category)
      updateAddButtonState()
    default:
      fatalError("error: adding category")
    }

    /// update table view with new set of section titles
    tableview.reloadData()
    
    /// update SelectedCategory
    switch category {
    case Categories.amusement.rawValue:
      selectedCategories.insert(.amusement, at: sectionTitles.count - 1)
    case Categories.cafe.rawValue:
      selectedCategories.insert(.cafe, at: sectionTitles.count - 1)
    case Categories.fashion.rawValue:
      selectedCategories.insert(.fashion, at: sectionTitles.count - 1)
    case Categories.restaurantAndCafe.rawValue:
      selectedCategories.insert(.restaurantAndCafe, at: sectionTitles.count - 1)
    case Categories.artAndGallery.rawValue:
      selectedCategories.insert(.artAndGallery, at: sectionTitles.count - 1)
    default:
      selectedCategories.insert(.other, at: sectionTitles.count - 1)
    }
    
    /// destination for the new location item to be displayed
    let destinationIndexPath = IndexPath(row: 0, section: sectionTitles.count - 1)
    tableview.reloadRows(at: [destinationIndexPath], with: .automatic)
    tableview.deselectRow(at: destinationIndexPath, animated: true)

    self.indexPathTillScrollDown = IndexPath(row:  categoryArray[sectionTitles.count - 1].count - 1 , section: sectionTitles.count - 1)
    /// Scroll to bottom
    self.tableview.scrollToRow(at: self.indexPathTillScrollDown!, at: .bottom, animated: true)
  }
  
  
  
  
  //Action when goButton is tapped
  @objc func goButtonTapped(){
    
    // If no user location, don't do anything.
    guard let _ = UserLocationController.shared.coordinatesMostRecent else {
      print("no user location, try it again!")
      return
    }
    
    // this is to avoid pushing many times. We will enable it at view will appear.
    goButton.isEnabled = false
    
    // For debug. If this var is true, it will only use sample data.
    if noMoreAPI{

      let nextVC = PlanListTableViewController()
      navigationController?.pushViewController(nextVC, animated: true)
      
      allLocations = [userCurrentLocation] + Location.sampleLocations
      Planner.calculateAllRoutes()
      let plans = Planner.calculatePlans(categories: selectedCategories)
      nextVC.plans = plans
      nextVC.tableView.reloadData()
      
      UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
      return
    }
    
    // if you has moved or no locations data?
    // -> then re-create(request, and calculate) all data
    if UserLocationController.shared.hasUserMoved()
        || allLocations.count <= 21
    {
      let nextVC = PlanListTableViewController()
      navigationController?.pushViewController(nextVC, animated: true)
      
      NetworkController.shared.createAllLocations { [weak self] in

        Planner.calculateAllRoutes()
        let plans = Planner.calculatePlans(categories: self!.selectedCategories)
        nextVC.plans = plans
        
        DispatchQueue.main.async {
          nextVC.tableView.reloadData()
        }        
        // update the previous coordinates
        UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
        print(allLocations.count)

      }
      
    }else{
      // if same place + only category has changed
      // code : only do Planner.calculatePlans(), no createAllLocations
      
      let nextVC = PlanListTableViewController()
      navigationController?.pushViewController(nextVC, animated: true)
      
      let plans = Planner.calculatePlans(categories: selectedCategories)
      nextVC.plans = plans
      nextVC.tableView.reloadData()
      // if user info is completely same as previous "go" (== same coordinates, same category order)
      // just use previous plans (add later)
    }
    
    
  }
  
  @objc func addButtonTapped(){
    let addEditVC = CategorySelectViewController()
    addEditVC.delegate = self
    addEditVC.selectArray[0].insert(nil, at: 0)
    let addToDoVC = UINavigationController(rootViewController: addEditVC)
    addToDoVC.hideBarBackground() // hide nv bar background. added by yanmer
//    switch sectionTitles.count {
//    case 1:
//      sectionTitles.append("2nd Location")
//      categoryArray[1].insert(Categories.fashion.rawValue, at: 0)
//      selectedCategories.append(.fashion)
//      addEditVC.categoryName0.text = Categories.fashion.rawValue
//      addEditVC.row = 0
//      addEditVC.section = 1
//      addEditVC.selectArray[0].insert(Categories.fashion.rawValue, at: 0)
//    case 2:
//      sectionTitles.append("3rd Location")
//      categoryArray[2].insert(Categories.artAndGallery.rawValue, at: 0)
//      selectedCategories.append(.artAndGallery)
//      addEditVC.categoryName0.text = Categories.artAndGallery.rawValue
//      addEditVC.row = 0
//      addEditVC.section = 2
//      addEditVC.selectArray[0].insert(Categories.artAndGallery.rawValue, at: 0)
    
//
//    case 3:
//      sectionTitles.append("4th Location")
//      categoryArray[3].insert(Categories.restaurantAndCafe.rawValue, at: 0)
//      selectedCategories.append(.restaurantAndCafe)
//      addEditVC.categoryName0.text = Categories.restaurantAndCafe.rawValue
//      addEditVC.row = 0
//      addEditVC.section = 3
//      addEditVC.selectArray[0].insert(Categories.restaurantAndCafe.rawValue, at: 0)
//
//    case 4:
//      sectionTitles.append("5th Location")
//      categoryArray[4].insert(Categories.amusement.rawValue, at: 0)
//      selectedCategories.append(.amusement)
//      addEditVC.categoryName0.text = Categories.amusement.rawValue
//      addEditVC.row = 0
//      addEditVC.section = 4
//      addEditVC.selectArray[0].insert(Categories.amusement.rawValue, at: 0)
//
//    default:
//      print("Add Button didn't work...")
//    }
//    let addToDoVC = UINavigationController(rootViewController: addEditVC)
//    addToDoVC.hideBarBackground() // hide nv bar background. added by yanmer
    present(addToDoVC, animated: true, completion: nil)
    tableview.reloadData()
//    updateAddButtonState()
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
}




// MARK: - Table view

extension MainViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let text = sectionTitles[section]
    let lb = TextLabel(text: text)
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
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 8+56+24
  }
  
  
  //  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
  //    let removedToDoItem = categoryArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
  //    categoryArray[destinationIndexPath.section].insert(removedToDoItem, at: destinationIndexPath.row)
  //  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let addEditVC = CategorySelectViewController()
    addEditVC.delegate = self
    addEditVC.categoryName0.text = categoryArray[indexPath.section][indexPath.row]
    addEditVC.selectArray[0].insert(categoryArray[indexPath.section][indexPath.row], at: 0)
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
    cell.category = categoryArray[indexPath.section][indexPath.row]
    cell.setMargin(insets: .init(top: 8, left: 0 , right: 0, bottom: 24))
    return cell
  }
  
}



// MARK: - Location manager process.
// Here, we manage when to start and stop location manager.
// The first time is called in viewDid load.

extension MainViewController{
  
  override func viewWillAppear(_ animated: Bool) {
    
    // Whenever the view is shown, enaible goButton.
    goButton.isEnabled = true
    
    // Start updating location.
    // if already updating, need not to do.
    if UserLocationController.shared.isUpdatingLocation{return}

    
    UserLocationController.shared.start(completion: { [weak self] in
      // Whenever user location is updated (or start updating), this closure is invoked.
      
      // Get current user locaiton
      guard let center = UserLocationController.shared.coordinatesMostRecent else {return}

      // Set region of the mapView using current location
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

      self?.mapView.setRegion(region, animated: false)
      self?.mapView.showsUserLocation = true
      // Get address by using current location
      UserLocationController.shared.getCurrentAddress(){ address in
        // if you couldn't get address, use ip one.
        if address.count <= 1 {
          self?.locationLabel.text = userCurrentLocation.address
          return
        }
        // update user location info
        userCurrentLocation.address = address
        // update location label
        self?.locationLabel.text = address
      }
    })
    
   
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    // Stop tracking user data.  Added by Yanmer.
    UserLocationController.shared.stop()
  }
  
}
