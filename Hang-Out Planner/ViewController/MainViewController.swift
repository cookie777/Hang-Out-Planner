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
  var categoryArray :[[String]] = [[Categories.cafe.rawValue],[Categories.clothes.rawValue],[Categories.park.rawValue],[],[]]
  
  var sectionTitles: [String] = ["1st Location","2nd Location","3rd Location"]
  var goButton = GoButton()
  var addButton = AddButton()
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
    tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -88).isActive
      = true
    tableview.separatorStyle = .none
  
    //Add goButton to view (you can modify this)
    view.addSubview(goButton)
    //    goButton.centerXYinSafeArea(view)
    goButton.translatesAutoresizingMaskIntoConstraints = false
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -144).isActive = true
    //    goButton.centerXin(view)
    goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
    
    view.addSubview(addButton)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 144).isActive = true
    addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
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
    //Send selectedCategories to planner model
    let plans = Planner.calculatePlans(categories: selectedCategories)
    let nextVC = PlanListTableViewController(plans: plans)
    
    // Move to next VC
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @objc func addButtonTapped(){
    switch sectionTitles.count {
    case 1:
      sectionTitles.append("2nd Location")
      categoryArray[1].insert(Categories.clothes.rawValue, at: 0)
      selectedCategories.append(.clothes)
    case 2:
      sectionTitles.append("3rd Location")
      categoryArray[2].insert(Categories.park.rawValue, at: 0)
      selectedCategories.append(.park)
    case 3:
      sectionTitles.append("4th Location")
      categoryArray[3].insert(Categories.restaurant.rawValue, at: 0)
      selectedCategories.append(.restaurant)
    case 4:
      sectionTitles.append("5th Location")
      categoryArray[4].insert(Categories.amusement.rawValue, at: 0)
      selectedCategories.append(.amusement)
    default:
      print("Add Button didn't work...")
    }
    tableview.reloadData()
    print(categoryArray)
    print(selectedCategories)
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
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    sectionTitles.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
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
    cell.showsReorderControl = true
    return cell
  }
}
