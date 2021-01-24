//
//  MainViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit



///  Main(home and top) screen.
///  Here, user can select categories in certain order.
///  If user push "go", it will pass [Category] to Planner,
///  and move to next VC.
class MainViewController: UIViewController, UITableViewDelegate,UINavigationControllerDelegate,EditCategoryDelegate{
  
  
  let cellId = "categories"
  var safeArea: UILayoutGuide!
  
  var selectedCategories: [Categories] = [.cafe,.clothes,.park]
  var categoryArray :[[String]] = [["Cafe"],["Clothes"],["Park"]]
  
  var sectionTitles: [String] = ["1st Location","2nd Location","3rd Location"]
  var goButton = GoButton()
  let headerTitle1 = LargeHeaderLabel(text: "Where You")
  let headerTitle2 = LargeHeaderLabel(text: "Want To Go?")
  
  let mapView : UILabel = {
    let map = UILabel()
    map.backgroundColor = .lightGray
    map.translatesAutoresizingMaskIntoConstraints = false
    return map
  }()
  
  let locationTitle = SubTextLabel(text: "Your current location is:")
  let locationLavel = SubTextLabel(text: "Near Keefer 58 PI")
  
  let tableview: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    safeArea = view.layoutMarginsGuide
    
    tableview.register(CategoryCardTVCell.self, forCellReuseIdentifier: cellId)
    tableview.dataSource = self
    tableview.delegate = self
    tableview.allowsMultipleSelectionDuringEditing = true
    
    
    view.addSubview(headerTitle1)
    headerTitle1.translatesAutoresizingMaskIntoConstraints = false
    headerTitle1.centerXin(view)
    headerTitle1.topAnchor.constraint(equalTo:view.topAnchor, constant: 96).isActive = true
    
    view.addSubview(headerTitle2)
    headerTitle2.translatesAutoresizingMaskIntoConstraints = false
    headerTitle2.centerXin(view)
    headerTitle2.topAnchor.constraint(equalTo:headerTitle1.bottomAnchor, constant: 8).isActive = true
    
    view.addSubview(mapView)
    mapView.topAnchor.constraint(equalTo: headerTitle2.bottomAnchor, constant: 16).isActive = true
    mapView.centerXin(view)
    mapView.constraintWidth(equalToConstant: 300)
    mapView.constraintHeight(equalToConstant: 120)
    
    view.addSubview(locationTitle)
    locationTitle.translatesAutoresizingMaskIntoConstraints = false
    locationTitle.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8).isActive = true
    locationTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
    
    view.addSubview(locationLavel)
    locationLavel.translatesAutoresizingMaskIntoConstraints = false
    locationLavel.textColor = .blue
    locationLavel.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 8).isActive = true
    locationLavel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
    
    view.addSubview(tableview)
    tableview.translatesAutoresizingMaskIntoConstraints = false
    tableview.topAnchor.constraint(equalTo: locationLavel.bottomAnchor, constant: 16).isActive = true
    tableview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    tableview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 8).isActive
      = true
    tableview.separatorStyle = .none
    
    
    //Add goButton to view (you can modify this)
    view.addSubview(goButton)
    //    goButton.centerXYinSafeArea(view)
    goButton.translatesAutoresizingMaskIntoConstraints = false
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    //    goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -144).isActive = true
    goButton.centerXin(view)
    goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
  }
  
  func edit(_ category: String,_ row: Int, _ section:Int) {
    let index = IndexPath(row: row, section: section)
    categoryArray[section].remove(at:row)
    categoryArray[section].insert(category, at:row)
    tableview.reloadRows(at: [index], with: .automatic)
    tableview.deselectRow(at: index, animated: true)
    tableview.reloadData()
    
    switch category {
    case "Amusment":
      selectedCategories.remove(at: section)
      selectedCategories.insert(.amusement, at: section)
    case "Cafe":
      selectedCategories.remove(at: section)
      selectedCategories.insert(.cafe, at: section)
    case "Clothes":
      selectedCategories.remove(at: section)
      selectedCategories.insert(.clothes, at: section)
    case "Restaurant":
      selectedCategories.remove(at: section)
      selectedCategories.insert(.restaurant, at: section)
    case "Nature,Park":
      selectedCategories.remove(at: section)
      selectedCategories.insert(.park, at: section)
    default:
      selectedCategories.remove(at: section)
      selectedCategories.insert(.other, at: section)
    }
  }
  //Action when goButton is tapped
  @objc func goButtonTapped(){
    //Send selectedCategories to planner model
    let plans = Planner.calculatePlans(categories: selectedCategories)
    let nextVC = PlanListTableViewController(plans: plans)
    // Move to next VC
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    tableview.isUserInteractionEnabled = false
    tableview.allowsSelection = false
    tableview.deselectRow(at: indexPath, animated: false)
    tableview.reloadData()
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let removedToDoItem = categoryArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
    categoryArray[destinationIndexPath.section].insert(removedToDoItem, at: destinationIndexPath.row)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let addEditVC = CategorySelectViewController()
    addEditVC.delegate = self
    addEditVC.categoryName0.text = categoryArray[indexPath.section][indexPath.row]
    addEditVC.row = indexPath.row
    addEditVC.section = indexPath.section
    let addToDoVC = UINavigationController(rootViewController: addEditVC)
    present(addToDoVC, animated: true, completion: nil)
    tableview.deselectRow(at: indexPath, animated: true)
    tableview.reloadData()
  }
  
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCardTVCell
    cell.categoryName.text = categoryArray[indexPath.section][indexPath.row]
    cell.showsReorderControl = true
    return cell
  }
}


// MARK: - Location manager process.
// Here, we manage when to start and stop location manager.
// The first time is called in viewDid load.

extension MainViewController{
  
  override func viewWillAppear(_ animated: Bool) {
    // Start updating location. Added by Yanmer
    print("start mVC lc at will")
    LocationController.shared.start(completion: {
      // update user annotation here
      print("update user annotation here")
    })

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    // Stop tracking user data.  Added by Yanmer.
    print("stop mVC lc at will")
    LocationController.shared.stop()
  }
}
