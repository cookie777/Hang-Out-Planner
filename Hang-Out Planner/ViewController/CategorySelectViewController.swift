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


class CategorySelectViewController: UIViewController {
  weak var delegate: EditCategoryDelegate?

  var row: Int?
  var section: Int?
  
  let headerTitle1 = LargeHeaderLabel(text: "How Are")
  let headerTitle2 = LargeHeaderLabel(text: "You Feeling?")
  let smallTitle1 = SmallHeaderLabel(text: "Current Location")
  let smallTitle2 = SmallHeaderLabel(text: "Location Types")
  let categoryName0 = MediumHeaderLabel(text: Categories.cafe.rawValue)
  let categoryName1 = MediumHeaderLabel(text: Categories.amusement.rawValue)
  let categoryName2 = MediumHeaderLabel(text: Categories.clothes.rawValue)
  let categoryName3 = MediumHeaderLabel(text: Categories.cafe.rawValue)
  let categoryName4 = MediumHeaderLabel(text: Categories.restaurant.rawValue)
  let categoryName5 = MediumHeaderLabel(text: Categories.park.rawValue)
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
//    let saveButton = UIBarButtonItem(barButtonSystemItem:.save, target: self, action: #selector(saveToDo))
//    navigationItem.rightBarButtonItem = saveButton
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissFunc))

    view.addSubview(headerTitle1)
    headerTitle1.translatesAutoresizingMaskIntoConstraints = false
    headerTitle1.centerXin(view)
    headerTitle1.topAnchor.constraint(equalTo:view.topAnchor, constant: 56).isActive = true
    
    view.addSubview(headerTitle2)
    headerTitle2.translatesAutoresizingMaskIntoConstraints = false
    headerTitle2.centerXin(view)
    headerTitle2.topAnchor.constraint(equalTo:headerTitle1.bottomAnchor, constant: 8).isActive = true
    
    view.addSubview(smallTitle1)
    smallTitle1.translatesAutoresizingMaskIntoConstraints = false
    smallTitle1.topAnchor.constraint(equalTo: headerTitle2.bottomAnchor, constant: 16).isActive = true
    smallTitle1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    
    view.addSubview(categoryName0)
    categoryName0.translatesAutoresizingMaskIntoConstraints = false
    categoryName0.centerXin(view)
    categoryName0.topAnchor.constraint(equalTo: smallTitle1.bottomAnchor, constant: 24).isActive = true
    categoryName0.constraintWidth(equalToConstant: 280)
    categoryName0.constraintHeight(equalToConstant: 50)
    categoryName0.textAlignment = .center
    categoryName0.layer.borderColor = UIColor.darkGray.cgColor
    categoryName0.layer.borderWidth = 1
    
    view.addSubview(smallTitle2)
    smallTitle2.translatesAutoresizingMaskIntoConstraints = false
    smallTitle2.topAnchor.constraint(equalTo: categoryName0.bottomAnchor, constant: 24).isActive = true
    smallTitle2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    
    view.addSubview(categoryName1)
    categoryName1.translatesAutoresizingMaskIntoConstraints = false
    categoryName1.centerXin(view)
    categoryName1.topAnchor.constraint(equalTo: smallTitle2.bottomAnchor, constant: 24).isActive = true
    categoryName1.constraintWidth(equalToConstant: 280)
    categoryName1.constraintHeight(equalToConstant: 50)
    categoryName1.textAlignment = .center
    categoryName1.layer.borderColor = UIColor.darkGray.cgColor
    categoryName1.layer.borderWidth = 1
    
    view.addSubview(categoryName2)
    categoryName2.translatesAutoresizingMaskIntoConstraints = false
    categoryName2.centerXin(view)
    categoryName2.topAnchor.constraint(equalTo: categoryName1.bottomAnchor, constant: 16).isActive = true
    categoryName2.constraintWidth(equalToConstant: 280)
    categoryName2.constraintHeight(equalToConstant: 50)
    categoryName2.textAlignment = .center
    categoryName2.layer.borderColor = UIColor.darkGray.cgColor
    categoryName2.layer.borderWidth = 1
    
    view.addSubview(categoryName3)
    categoryName3.translatesAutoresizingMaskIntoConstraints = false
    categoryName3.centerXin(view)
    categoryName3.topAnchor.constraint(equalTo: categoryName2.bottomAnchor, constant: 16).isActive = true
    categoryName3.constraintWidth(equalToConstant: 280)
    categoryName3.constraintHeight(equalToConstant: 50)
    categoryName3.textAlignment = .center
    categoryName3.layer.borderColor = UIColor.darkGray.cgColor
    categoryName3.layer.borderWidth = 1
    
    view.addSubview(categoryName4)
    categoryName4.translatesAutoresizingMaskIntoConstraints = false
    categoryName4.centerXin(view)
    categoryName4.topAnchor.constraint(equalTo: categoryName3.bottomAnchor, constant: 16).isActive = true
    categoryName4.constraintWidth(equalToConstant: 280)
    categoryName4.constraintHeight(equalToConstant: 50)
    categoryName4.textAlignment = .center
    categoryName4.layer.borderColor = UIColor.darkGray.cgColor
    categoryName4.layer.borderWidth = 1
    
    view.addSubview(categoryName5)
    categoryName5.translatesAutoresizingMaskIntoConstraints = false
    categoryName5.centerXin(view)
    categoryName5.topAnchor.constraint(equalTo: categoryName4.bottomAnchor, constant: 16).isActive = true
    categoryName5.constraintWidth(equalToConstant: 280)
    categoryName5.constraintHeight(equalToConstant: 50)
    categoryName5.textAlignment = .center
    categoryName5.layer.borderColor = UIColor.darkGray.cgColor
    categoryName5.layer.borderWidth = 1
    
    let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapped1))
    categoryName1.isUserInteractionEnabled = true
    categoryName1.addGestureRecognizer(tap1)
    
    let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapped2))
    categoryName2.isUserInteractionEnabled = true
    categoryName2.addGestureRecognizer(tap2)
    
    let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapped3))
    categoryName3.isUserInteractionEnabled = true
    categoryName3.addGestureRecognizer(tap3)
    
    let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapped4))
    categoryName4.isUserInteractionEnabled = true
    categoryName4.addGestureRecognizer(tap4)
    
    let tap5 = UITapGestureRecognizer(target: self, action: #selector(tapped5))
    categoryName5.isUserInteractionEnabled = true
    categoryName5.addGestureRecognizer(tap5)
    
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
}
