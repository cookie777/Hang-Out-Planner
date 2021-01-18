//
//  MainViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

/*
 Main(home and top) screen.
 Here, user can select categories in certain order.
 If user push "go", it will pass [Category] to Planner,
 and move to next VC.
 */

class MainViewController: UIViewController {
  
  // categories that user has selected
  var selectedCategories: [Categories] = []
  
  var goButton = GoButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(goButton)
    goButton.centerXYinSafeArea(view)
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
  }
  
  @objc func goButtonTapped(){
    let plans = Planner.calculatePlans(categories: selectedCategories)
    let nextVC = PlanListTableViewController(plans: plans)
    navigationController?.pushViewController(nextVC, animated: true)
  }
}
