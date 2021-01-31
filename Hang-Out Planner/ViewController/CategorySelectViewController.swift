//
//  CategorySelectViewController.swift
//  Hang-Out Planner
//
//  Created by Takamiya Kengo on 2021/01/20.
//

import UIKit

protocol EditCategoryDelegate: class{
  
  func edit(_ categoryName:String,_ row: Int,_ section:Int)
}


class CategorySelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  
  weak var delegate: EditCategoryDelegate?
  
  var row: Int?
  var section: Int?
  let cellId = "categories"
  
  var selectArray:[[String]] = [[],[Categories.fashion.rawValue,Categories.amusement.rawValue,Categories.cafe.rawValue,Categories.restaurantAndCafe.rawValue,Categories.artAndGallery.rawValue,]]
  
  let headerTitle = LargeHeaderLabel(text: "How Are\nYou Feeling?")
  let smallTitle1 = SmallHeaderLabel(text: "Current Location")
  let smallTitle2 = SmallHeaderLabel(text: "Location Types")
  let categoryName0 = MediumHeaderLabel(text: Categories.cafe.rawValue)
  let categoryName1 = MediumHeaderLabel(text: Categories.amusement.rawValue)
  let categoryName2 = MediumHeaderLabel(text: Categories.fashion.rawValue)
  let categoryName3 = MediumHeaderLabel(text: Categories.cafe.rawValue)
  let categoryName4 = MediumHeaderLabel(text: Categories.restaurantAndCafe.rawValue)
  let categoryName5 = MediumHeaderLabel(text: Categories.artAndGallery.rawValue)
  
  //  tabelView version
  let sectionTitle = ["Current Location","Location Types"]
  
  let tableview: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor
    
    //    navigationItem.rightBarButtonItem = saveButton
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissFunc))
    
    setLayoutOfTableview()
    
  }
  
  func setLayoutOfTableview()  {
    
    // Tableview setting
    view.addSubview(tableview)
    tableview.backgroundColor = bgColor
    tableview.matchParent(padding: .init(top: 40, left: 32, bottom: 40, right:32))
    
    tableview.showsVerticalScrollIndicator = false
    tableview.register(CategoryCardTVCell.self, forCellReuseIdentifier: cellId)
    tableview.dataSource = self
    tableview.delegate = self
    tableview.separatorStyle = .none
    // why not working?!
    //    tableview.layoutMargins = UIEdgeInsets(top: 0,left: 32,bottom: 0,right: 32)
    
    // Set upper view as `tableHeaderView` of the table view.
    headerTitle.constraintHeight(equalToConstant: headerTitle.intrinsicContentSize.height + 24)
    let thv = headerTitle
    tableview.tableHeaderView = thv
    thv.translatesAutoresizingMaskIntoConstraints = false
    
    // Set width same as table view
    thv.matchSizeWith(widthRatio: 1, heightRatio: nil)
    // We need to set layout of header at this time. Otherwise (if we do it later), it will Overflow!
    tableview.tableHeaderView?.setNeedsLayout()
    tableview.tableHeaderView?.layoutIfNeeded()
 
  }
  
  @objc func tapped1 () {
    categoryName0.text = categoryName1.text
    let category = categoryName0.text
    delegate?.edit(category!,row!,section!)
    dismissFunc()
  }
  @objc func tapped2 () {
    categoryName0.text = categoryName2.text
    let category = categoryName0.text
    delegate?.edit(category!,row!,section!)
    dismissFunc()
  }
  @objc func tapped3 () {
    categoryName0.text = categoryName3.text
    let category = categoryName0.text
    delegate?.edit(category!,row!,section!)
    dismissFunc()
  }
  @objc func tapped4 () {
    categoryName0.text = categoryName4.text
    let category = categoryName0.text
    delegate?.edit(category!,row!,section!)
    dismissFunc()
  }
  @objc func tapped5 () {
    categoryName0.text = categoryName5.text
    let category = categoryName0.text
    delegate?.edit(category!,row!,section!)
    dismissFunc()
  }
  @objc func saveToDo() {
    let category = categoryName0.text
    delegate?.edit(category!,row!,section!)
    dismissFunc()
  }
  @objc func dismissFunc() {
    dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return sectionTitle[0]
    } else {
      return sectionTitle[1]
    }
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // set row height caring margin. Top+content+bottom
    switch (indexPath.section, indexPath.row) {
    case (0,0):
      return 8+56+40
    case (1,0):
      return 16+56+8
    default:
      return 8+56+8
    }
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let text = sectionTitle[section]
    let lb = section == 0 ? SubTextLabel(text: text) : MediumHeaderLabel(text: text)
    return lb
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    categoryName0.text = categoryName4.text
    let category = selectArray[1][indexPath.row]
    delegate?.edit(category,row!,section!)
    dismissFunc()
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return 5
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCardTVCell
    cell.category = selectArray[indexPath.section][indexPath.row]
    
    // set content margin
    switch (indexPath.section, indexPath.row) {
    case (0,0):
      cell.setMargin(insets: .init(top: 8, left: 0 , right: 0, bottom: 40))
    case (1,0):
      cell.setMargin(insets: .init(top: 16, left: 0 , right: 0, bottom: 8))
    default:
      cell.setMargin(insets: .init(top: 8, left: 0 , right: 0, bottom: 8))
    }
    
    return cell
  }
}

