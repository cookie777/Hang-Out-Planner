//
//  CategorySelectViewController.swift
//  Hang-Out Planner
//
//  Created by Takamiya Kengo on 2021/01/20.
//

import UIKit

protocol EditCategoryDelegate: class{
  
  func edit(_ category: Categories)
  func addCategory(_ category: Categories)
  
}


class CategorySelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  
  weak var delegate: EditCategoryDelegate?
  
  var row: Int?
  var section: Int?
  let cellId = "categories"
  
  
//  var selectArray:[[String?]] = [[],[Categories.fashion.rawValue,Categories.amusement.rawValue,Categories.cafe.rawValue,Categories.restaurantAndCafe.rawValue,Categories.artAndGallery.rawValue,]]
  
  var editingCategory : Categories?
  var categoryList : [Categories] = [
    Categories.fashion,
    Categories.amusement,
    Categories.cafe,
    Categories.restaurantAndCafe,
    Categories.artAndGallery
  ]
  
  let headerTitle = LargeHeaderLabel(text: "How Are\nYou Feeling?")

  let categoryName0 = MediumHeaderLabel(text: Categories.cafe.rawValue)
  let categoryName1 = MediumHeaderLabel(text: Categories.amusement.rawValue)
  let categoryName2 = MediumHeaderLabel(text: Categories.fashion.rawValue)
  let categoryName3 = MediumHeaderLabel(text: Categories.cafe.rawValue)
  let categoryName4 = MediumHeaderLabel(text: Categories.restaurantAndCafe.rawValue)
  let categoryName5 = MediumHeaderLabel(text: Categories.artAndGallery.rawValue)
  
  //  tabelView version
  let sectionTitle = ["Current Location Type"," \nLocation Types"]
  
  let tableview: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor
    
    //    navigationItem.rightBarButtonItem = saveButton
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
    
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
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    // add
    guard let _ = editingCategory else { return sectionTitle[1] }
    // edit
    switch section {
      case 0:
        return sectionTitle[0]
      default:
        return sectionTitle[1]
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // add
    guard let _ = editingCategory else { return 1 }
    // edit
    return 2
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // add
    guard let _ = editingCategory else { return 8+56+8 }
    
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
    // add
    guard let _ = editingCategory else {
      let text = sectionTitle[1]
      let lb = MediumHeaderLabel(text: text)
      return lb
    }
    
    // edit
    let text = sectionTitle[section]
    let lb = section == 0 ? SubTextLabel(text: text) : MediumHeaderLabel(text: text)
    return lb
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // when newly add category
//    delegate?.addCategory(<#T##category: String##String#>)
    dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let _ = editingCategory else { return 5 }
    
    if section == 0 {
      return 1
    } else {
      return 5
    }

  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if editingCategory == nil {
      let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCardTVCell
      cell.category = categoryList[indexPath.row].rawValue
      cell.setMargin(insets: .init(top: 8, left: 0 , right: 0, bottom: 8))
      return cell
    } else {
      let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCardTVCell
      cell.category =  categoryList[indexPath.row].rawValue
      /// set content margin
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
}
