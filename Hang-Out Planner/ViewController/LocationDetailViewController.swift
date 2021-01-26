//
//  LocationDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

///  This vc is to display location detail when user select at PlanDetailViewController.Priority is Low.
class LocationDetailViewController: UIViewController {
  
  // A location selected at `PlanDetailViewController`
  let location: Location
  
  
  init(location: Location) {
    self.location = location
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    // This is a test Label to check if the location has passed. You can delete this.
    let testlb = UILabel()
    testlb.text = location.title
    view.addSubview(testlb)
    testlb.centerXYin(view)
  }
  
  
}
