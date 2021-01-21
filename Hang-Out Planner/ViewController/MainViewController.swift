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
class MainViewController: UIViewController, UITableViewDelegate {
  var options:[String] = []
  let cellId = "categories"
  var safeArea: UILayoutGuide!
  // categories that user has selected
  var selectedCategories: [Categories] = []
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
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    
    //Add goButton to view (you can modify this)
    view.addSubview(goButton)
    //    goButton.centerXYinSafeArea(view)
    goButton.translatesAutoresizingMaskIntoConstraints = false
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48).isActive = true
    goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
  }
  
  //Action when goButton is tapped
  @objc func goButtonTapped(){
    
    
    
    
    //Send selectedCategories to planner model
    let plans = Planner.calculatePlans(categories: selectedCategories)
    let nextVC = PlanListTableViewController(plans: plans)
    
    // Move to next VC
    navigationController?.pushViewController(nextVC, animated: true)
  }
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height
      } else {
        let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
        self.view.frame.origin.y -= suggestionHeight
      }
    }
  }
  
  @objc func keyboardWillHide() {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  @objc func dismissKeyboard() {
    self.view.endEditing(true)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
    //      (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let removedToDoItem = options.remove(at: sourceIndexPath.row)
    options.insert(removedToDoItem, at: destinationIndexPath.row)
  }
  private func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: IndexPath!) -> Bool {
    return true
  }
    
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
//  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    return
//
//  }
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: IndexPath) {
//    if (editingStyle == UITableViewCell.EditingStyle.delete) {
//      tableview.beginUpdates()
//      if editingStyle == .delete {
                 options.remove(at: indexPath.row)
                 tableView.deleteRows(at: [indexPath], with: .bottom)
//        tableview.endUpdates()
//             }
//    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
  }
  override func setEditing(_ editing: Bool, animated: Bool) {
         super.setEditing(editing, animated: animated)
    tableview.isEditing = editing

         print(editing)
     }
}



extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCardTVCell
    return cell
  }
}
