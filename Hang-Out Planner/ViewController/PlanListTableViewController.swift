//
//  PlanListTableViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

///  Screen which display list of plan `[Plan]`.
///  Receive `[Plan]` from Planner.
///  If user select one of `Plan`, it will move to next VC.
class PlanListTableViewController: UITableViewController {
  
  // [Plan] you receive from planner model
  let plans: [Plan]
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  init(plans: [Plan]) {
    self.plans = plans
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->    Int {
    return 0
  }
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
}
