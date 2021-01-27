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
  var cellId = "planCardCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Your Plans"
    tableView.register(PlanCardTVCell.self, forCellReuseIdentifier: cellId)
//    tableView.contentInset = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 0)
//    tableView.matchSize()
//    view.addSubview(tableView)
//    tableView.matchParent(padding: .init(top: 0, left: 40, bottom: 40, right: 0))
  }
  
  init(plans: [Plan]) {
    self.plans = plans
    super.init(style: .insetGrouped)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return plans.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->    Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlanCardTVCell
    
    cell.locationField.numberOfLines = 0
    let plan = plans[indexPath.section]
    cell.update(with: plan)
    
    return cell
  }
  
  // Cell Select -> move to PlanDetailVC
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let planDetailVC = PlanDetailViewController(plan: plans[indexPath.section])
    navigationController?.pushViewController(planDetailVC, animated: true)
  }
  
  
}
